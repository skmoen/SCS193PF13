//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

@property (strong, nonatomic) NSMutableArray *cardViews;  // of UIView
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardTableView;
@property (nonatomic) NSTimeInterval dealDelay;

@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.cardTableView.backgroundColor = nil;
    self.dealDelay = 0;
}

#pragma mark - Accessors
-(Grid*)grid
{
    if (!_grid) _grid = [[Grid alloc] init];
    _grid.size = self.cardTableView.frame.size;
    _grid.cellAspectRatio = 2.0/3;
    _grid.minimumNumberOfCells = [self.game cardsInPlay];
    return _grid.inputsAreValid ? _grid : nil;
}

-(CardMatchingGame*)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardsToDeal
                                                          usingDeck:self.deck];
    _game.cardsToMatch = self.cardsToMatch;
    _game.removeMatched = self.removeMatched;
    return _game;
}

-(NSMutableArray*)cardViews
{
    if (!_cardViews) _cardViews = [[NSMutableArray alloc] init];
    return _cardViews;
}

-(Deck*)deck
{
    return nil;
}

#pragma mark - Outlets
- (IBAction)moreCardsButton:(id)sender {
    [self.game drawMoreCards:3];
    [self updateUI];
}

- (IBAction)touchNewGameButton:(id)sender {
    for (UIView *view in self.cardViews) {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^(void){
                             view.alpha = 0;
                         }
                         completion:^(BOOL fin){
                             if (fin) [view removeFromSuperview];}];
    }
    
    // give the cards time to disappear
    self.dealDelay = 0.5;
    
    self.cardViews = nil;
    self.deck = nil;
    self.game = nil;
    [self updateUI];
}

-(void)tapCard:(UITapGestureRecognizer*)tap
{
    [self.game choseCardAtIndex:[self.cardViews indexOfObject:tap.view]];
    [self updateUI];
}

#pragma mark - View
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)updateUI
{
    [self dealCards];
    [self alignCardsToGrid];
    
    for (int i = 0; i < [self.cardViews count]; i++) {
        Card *card = [self.game cardAtIndex:i];
        [self updateView:[self.cardViews objectAtIndex:i] withCard:card];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.dealDelay = 0;
}

-(void)dealCards
{
    NSTimeInterval dealDelay = 0;
    for (int i = 0; i < [self.game cardsInPlay]; i++) {
        Card *card = [self.game cardAtIndex:i];
        
        if (i == [self.cardViews count]) {
            UIView *cardView = [self addViewWithCard:card atIndex:i afterDelay:dealDelay];
            dealDelay += 0.3;
            [self.cardViews addObject:cardView];
        }
        else {
            UIView *cardView = [self.cardViews objectAtIndex:i];
        
            if (![self doesView:cardView representCard:card]) {
                int index = [self findViewRepresentingCard:card indexHint:i];
                if (index == NSNotFound) {
                    self.dealDelay = 1;
                    [UIView animateWithDuration:0.5
                                          delay:0
                                        options:UIViewAnimationOptionBeginFromCurrentState
                                     animations:^(void){
                                         cardView.frame = CGRectInset(cardView.frame,
                                                                      (cardView.frame.size.width/2)-1,
                                                                      (cardView.frame.size.height/2)-1);
                                         cardView.alpha = 0.3;
                                     }
                                     completion:^(BOOL fin) {
                                         if (fin) {
                                             [cardView removeFromSuperview];
                                         }
                                     }];

                    UIView *newView = [self addViewWithCard:card atIndex:i afterDelay:dealDelay];
                    dealDelay += 0.3;
                    [self.cardViews replaceObjectAtIndex:i withObject:newView];
                }
                else {
                    [self.cardViews exchangeObjectAtIndex:i withObjectAtIndex:index];
                }
            }
        }
    }
}

-(void)alignCardsToGrid
{
    for (int i = 0; i < [self.cardViews count]; i++) {
        int row = i / self.grid.columnCount;
        int col = i % self.grid.columnCount;
        UIView *view = [self.cardViews objectAtIndex:i];
        
        if (!CGPointEqualToPoint([self.grid centerOfCellAtRow:row inColumn:col], view.center) ||
            !CGRectEqualToRect([self.grid frameOfCellAtRow:row inColumn:col], view.frame)) {
            [UIView animateWithDuration:0.5
                                  delay:self.dealDelay/2
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^(void) {
                                 view.center = [self.grid centerOfCellAtRow:row inColumn:col];
                                 view.frame = [self.grid frameOfCellAtRow:row inColumn:col];
                             }
                             completion:^(BOOL fin) {
                             }];
        }
    }
}

-(UIView*)addViewWithCard:(Card*)card atIndex:(NSUInteger)index afterDelay:(NSTimeInterval)delay
{
    int row = index / self.grid.columnCount;
    int col = index % self.grid.columnCount;

    UIView *view = [self cardViewWithCard:card];
    
    // start card offscreen
    CGRect frame = [self.grid frameOfCellAtRow:row inColumn:col];
    frame.origin = CGPointMake(self.cardTableView.frame.size.width,
                               self.cardTableView.frame.size.height + frame.size.height);
    view.frame = frame;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
    [view addGestureRecognizer:tap];
    
    [self.cardTableView addSubview:view];
    [UIView animateWithDuration:0.3
                          delay:self.dealDelay + 0.05*delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^(void){
                         view.center = [self.grid centerOfCellAtRow:row inColumn:col];
                     }
                     completion:^(BOOL finished){}];
    
    return view;
}

-(NSUInteger)findViewRepresentingCard:(Card*)card indexHint:(NSUInteger)index
{
    @try {
        for (int i = index + 1; i < [self.game cardsInPlay]; i++) {
            UIView *view = [self.cardViews objectAtIndex:i];
            if ([self doesView:view representCard:card]) return i;
        }
    }
    @catch (NSException *exception) {
        return NSNotFound;
    }
    
    return NSNotFound;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self alignCardsToGrid];
}

#pragma mark - Abstract
-(UIView*)cardViewWithCard:(Card*)card
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor blueColor]];
    return view;
}

-(void)updateView:(UIView*)view withCard:(Card*)card
{
    // make any changes to the view based on the changing state of the card
}

-(BOOL)doesView:(UIView*)view representCard:(Card*)card
{
    // check card contents against view contents
    return YES;
}

@end
