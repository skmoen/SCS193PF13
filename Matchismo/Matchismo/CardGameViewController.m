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
    // required
    _grid.size = self.cardTableView.frame.size;
    _grid.cellAspectRatio = 2.0/3.0;
    _grid.minimumNumberOfCells = self.game.cardsInPlay;
    _grid.minCellHeight = 3;
    _grid.minCellWidth = 2;
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

-(Deck*)deck
{
    return nil;
}

#pragma mark - Action Handlers
- (IBAction)touchNewGameButton:(id)sender {
    for (int i = 0; i < [self.game cardsInPlay]; i++ ) {
        UIView *view = [self.cardTableView viewWithTag:i];
        if (view) {
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^(void){
                                 view.alpha = 0;
                                 view.tag = -1;
                             }
                             completion:^(BOOL fin){ if (fin) [view removeFromSuperview];}];

        }
    }
    self.deck = nil;
    self.game = nil;
    [self updateUI];
}

#pragma mark - UI Drawing
static const CGPoint offscreenDeckPoint = { 500, 500 };

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
        
        UIView *cardView = [self.cardTableView viewWithTag:i];
        if ( !cardView ) {
            CGRect frame = [self.grid frameOfCellAtRow:row inColumn:col];
            frame = CGRectInset(frame, 2, 2);
            frame.origin = offscreenDeckPoint;
            cardView = [self viewWithCard:card inFrame:frame];
            cardView.tag = i;
            [self addTapToView:cardView];
            [self.cardTableView addSubview:cardView];
            [UIView animateWithDuration:0.3
                                  delay:0.5 + 0.05*i
                                options:UIViewAnimationOptionCurveLinear
                             animations:^(void){
                                 cardView.center = [self.grid centerOfCellAtRow:row inColumn:col];
                             }
                             completion:^(BOOL finished){}];
        }
        [self updateView:cardView withCard:card];
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
    [self.game choseCardAtIndex:tap.view.tag];
    [self updateUI];
}

-(UIView*)viewWithCard:(Card*)card inFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor blueColor]];
    return view;
}

-(void)updateView:(UIView*)view withCard:(Card*)card
{
    
}

-(BOOL)card:(Card*)card isRepresentedByView:(UIView*)cardView
{
    return YES;
}

-(void)updateUI
{
    [self dealCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
