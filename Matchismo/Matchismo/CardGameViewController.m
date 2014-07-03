//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()

//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) NSMutableArray *cardViews;  // of UIView
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardTableView;

@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.cardsToMatch = 0;
    self.cardsToDeal = 1;
    self.removeMatched = NO;
    self.cardTableView.backgroundColor = nil;
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

#pragma mark - Action Handlers
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

    self.cardViews = nil;
    self.deck = nil;
    self.game = nil;
    [self updateUI];
}

#pragma mark - UI Drawing

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)dealCards
{
    int row, col;
    for (int i = 0; i < [self.game cardsInPlay]; i++) {
        Card *card = [self.game cardAtIndex:i];

        row = i / self.grid.columnCount;
        col = i % self.grid.columnCount;
        
        if ( i < [self.cardViews count]) {
            UIView *cardView = [self.cardViews objectAtIndex:i];
            if (![self doesView:cardView representCard:card]) {
                //UIView *existingView = [self findViewRepresentingCard:card indexHint:i];
                int index = [self findViewRepresentingCard:card indexHint:i];
                if (index == NSNotFound) {
                    [[self.cardViews objectAtIndex:i] removeFromSuperview];
                    
                    CGRect frame = [self.grid frameOfCellAtRow:row inColumn:col];
                    frame = CGRectInset(frame, 2, 2);
                    frame.origin =  CGPointMake(self.cardTableView.frame.size.width, self.cardTableView.frame.size.height*2);
                    UIView *newCardView = [self viewWithCard:card inFrame:frame];
                    //cardView.tag = i;
                    [self addTapToView:newCardView];
                    //[self.cardViews addObject:cardView];
                    self.cardViews[i] = newCardView;
                    [self.cardTableView addSubview:newCardView];
                    [UIView animateWithDuration:0.3
                                          delay:0.5 + 0.05*i
                                        options:UIViewAnimationOptionCurveLinear
                                     animations:^(void){
                                         newCardView.center = [self.grid centerOfCellAtRow:row inColumn:col];
                                     }
                                     completion:^(BOOL finished){}];
                }
                else {
                    [self.cardViews exchangeObjectAtIndex:i withObjectAtIndex:index];
                    [self.cardViews[i] setCenter:[self.grid centerOfCellAtRow:row inColumn:col]];
                }
            }
            else {
                [self updateView:cardView withCard:card];
            }
        }
        else {
            CGRect frame = [self.grid frameOfCellAtRow:row inColumn:col];
            frame = CGRectInset(frame, 2, 2);
            frame.origin =  CGPointMake(self.cardTableView.frame.size.width, self.cardTableView.frame.size.height);
            UIView *newCardView = [self viewWithCard:card inFrame:frame];
            //cardView.tag = i;
            [self addTapToView:newCardView];
            [self.cardViews addObject:newCardView];
            [self.cardTableView addSubview:newCardView];
            [UIView animateWithDuration:0.3
                                  delay:0.5 + 0.05*i
                                options:UIViewAnimationOptionCurveLinear
                             animations:^(void){
                                 newCardView.center = [self.grid centerOfCellAtRow:row inColumn:col];
                             }
                             completion:^(BOOL finished){}];
        }
        
        if ([self.cardViews count] > [self.game cardsInPlay]) {
            NSLog(@"EXTRA VIEWZ");
        }
         
    }
}

             
-(void)addTapToView:(UIView*)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapCard:)];
    [view addGestureRecognizer:tap];
}

-(void)tapCard:(UITapGestureRecognizer*)tap
{
    [self.game choseCardAtIndex:[self.cardViews indexOfObject:tap.view]];
    [self updateUI];
}

-(NSUInteger)findViewRepresentingCard:(Card*)card indexHint:(NSUInteger)index
{
    /*
    // check at index
    UIView *view = [self.cardViews objectAtIndex:index];
    if ([self doesView:view representCard:card]) return index;
    */
    for (int i = index + 1; i < [self.game cardsInPlay]; i++) {
        UIView *view = [self.cardViews objectAtIndex:i];
        if ([self doesView:view representCard:card]) return i;
    }
    
    /*
    for (int i = 0; i < index; i++) {
        UIView *view = [self.cardViews objectAtIndex:i];
        if ([self doesView:view representCard:card]) return view;
    }
     */
    
    return NSNotFound;
}

// abstract
-(UIView*)viewWithCard:(Card*)card inFrame:(CGRect)frame
{
    // create and return a card view based on the provided card in the provided frame
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor blueColor]];
    return view;
}

// abstract
-(BOOL)doesView:(UIView*)view representCard:(Card*)card
{
    // determine whether the view is a representation of the card value
    return YES;
}

// abstract
-(void)updateView:(UIView*)view withCard:(Card*)card
{
    // make any changes to the view based on the changing state of the card
}

-(void)updateUI
{
    [self dealCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
