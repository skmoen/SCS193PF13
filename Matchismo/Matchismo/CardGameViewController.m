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
@property (strong, nonatomic) NSMutableArray *cardArray;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardTableView;

@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.cardCount = 1;
    self.cardsToMatch = 1;
}

#pragma mark - Accessors
/*
-(NSMutableArray*)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}
 */

-(Grid*)grid
{
    if (!_grid) _grid = [[Grid alloc] init];
    // required
    _grid.size = self.cardTableView.frame.size;
    _grid.cellAspectRatio = 160.0/240.0;
    _grid.minimumNumberOfCells = self.cardCount;
    // optional
    _grid.minCellWidth = 32;
    _grid.minCellHeight = 48;
    _grid.maxCellWidth = 160;
    _grid.maxCellHeight = 240;
    return _grid.inputsAreValid ? _grid : nil;
}

-(CardMatchingGame*)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardCount
                                                          usingDeck:self.deck];
    _game.cardsToMatch = self.cardsToMatch;
    return _game;
}

-(Deck*)deck
{
    return nil;
}

#pragma mark - Action Handlers
- (IBAction)touchNewGameButton:(id)sender {
    self.game = nil;
    self.cardArray = nil;
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
    int row = 0; int col = 0;
    for (int i = 0; i < self.cardCount; i++) {
        Card *card = [self.game cardAtIndex:i];
        //[self.cardArray addObject:card];
        
        if ( !([self.cardTableView viewWithTag:i]) ) {
            CGRect frame;
            frame.origin = offscreenDeckPoint;
            frame.size = self.grid.cellSize;
            UIView *cardView = [self viewWithCard:card inFrame:frame];
            cardView.tag = i;
            [self.cardTableView addSubview:cardView];
            [UIView animateWithDuration:0.5
                                  delay:0.2*i
                                options:UIViewAnimationOptionCurveLinear
                             animations:^(void){
                                 cardView.center = [self.grid centerOfCellAtRow:row inColumn:col];
                             }
                             completion:^(BOOL finished){}];
        }
        col++;
        if (col >= [self.grid columnCount]) {
            row += 1;
            col = 0;
        }
    }
}

-(UIView*)viewWithCard:(Card*)card inFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor blueColor]];
    return view;
}

-(void)updateUI
{
    [self dealCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
