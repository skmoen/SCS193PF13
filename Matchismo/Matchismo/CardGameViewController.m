//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Card.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeControl;

@property (strong, nonatomic) CardMatchingGame *game;

@end

@implementation CardGameViewController

-(CardMatchingGame*)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    _game.cardsToMatch = [self modeValue:self.modeControl.selectedSegmentIndex];
    return _game;
}

-(Deck*)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game choseCardAtIndex:chosenButtonIndex];
    self.statusLabel.text = self.game.status;
    self.modeControl.enabled = NO;
    [self updateUI];
}

- (IBAction)touchNewGameButton:(id)sender {
    self.modeControl.enabled = YES;
    self.game = nil;
    [self updateUI];
}

-(NSUInteger)modeValue:(NSUInteger)index
{
    return index + 1;
}

- (IBAction)changeModeControl:(id)sender {
    self.game.cardsToMatch = [self modeValue:self.modeControl.selectedSegmentIndex];
}

-(void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

-(NSString*)titleForCard:(Card*)card
{
    return card.isChosen ? card.contents : @"";
}

-(UIImage*)backgroundImageForCard:(Card*)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
