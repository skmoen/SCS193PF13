//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "CardGameViewController.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()

//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation CardGameViewController

-(CardMatchingGame*)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
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

- (IBAction)touchCardButton:(UIButton *)sender {
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game choseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)touchNewGameButton:(id)sender {
    self.game = nil;
    [self updateUI];
}

-(void)updateCards
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
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(NSAttributedString*)attributedStringFromHistory:(NSDictionary*)history
{
    if (![history objectForKey:@"cards"]) return [[NSAttributedString alloc] init];
    
    int score = [[history objectForKey:@"score"] intValue];
    NSMutableAttributedString *status = [[NSMutableAttributedString alloc] initWithString:@"("];
    [status appendAttributedString:[[NSAttributedString alloc] initWithString:[[[history objectForKey:@"cards"] valueForKey:@"contents"] componentsJoinedByString:@" "]]];
    [status appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@")"]]];
    
    if (score > 0) {
        [status appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" matched! +%d", score]]];
    }
    else if (score < 0 ) {
        if ([[history objectForKey:@"cards"] count] > 1) {
            [status appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" didn't match! %d", score]]];
        }
        else {
            [status appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" selected. %d", score]]];
        }
    }
    
    return status;
}

-(void)updateUI
{
    [self updateCards];
    self.statusLabel.attributedText = [self attributedStringFromHistory:[self.game.statusHistory lastObject]];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"historySegue"]) {
        HistoryViewController *hvc = [segue destinationViewController];
        NSMutableAttributedString *history = [[NSMutableAttributedString alloc] init];
        int count = 1;
        for (id item in self.game.statusHistory) {
            [history appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d. ", count]]];
            [history appendAttributedString:[self attributedStringFromHistory:item]];
            [history appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n"]]];
            count++;
        }
        hvc.history = history;
    }
}

@end
