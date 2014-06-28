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

@end

@implementation CardGameViewController

-(CardMatchingGame*)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:1
                                                          usingDeck:[self createDeck]];
    _game.cardsToMatch = [self viewCardsToMatch];
    return _game;
}

// abstract
-(NSInteger)viewCardsToMatch
{
    return 0;
}

// abstract
-(Deck*)createDeck
{
    return nil;
}

- (IBAction)touchNewGameButton:(id)sender {
    self.game = nil;
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(void)updateUI
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
