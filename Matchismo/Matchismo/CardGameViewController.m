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

-(NSUInteger)modeValue:(NSUInteger)index
{
    return index + 1;
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

+(NSString*)stringFromHistory:(NSDictionary*)history
{
    if (![history objectForKey:@"cards"]) return @"";
    
    int score = [[history objectForKey:@"score"] intValue];
    NSMutableString *status = (NSMutableString*)[[[history objectForKey:@"cards"] valueForKey:@"contents"] componentsJoinedByString:@","];
    if (score > 0) {
        [status appendFormat:@" matched! +%d", score];
    }
    else if (score <0) {
        [status appendFormat:@" didn't match! %d", score];
    }
    return [NSString stringWithFormat:@"%@; %d",
            [[[history objectForKey:@"cards"] valueForKey:@"contents"] componentsJoinedByString:@","], score];
            
}

-(void)updateUI
{
    [self updateCards];
    self.statusLabel.text = [[self class] stringFromHistory:[self.game.statusHistory lastObject]];  // [self.game.statusHistory lastObject];
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
        NSMutableString *history = [[NSMutableString alloc] init];
        for (id item in self.game.statusHistory) {
            [history appendFormat:@"%@\n",[[self class] stringFromHistory:item]];
        }
        hvc.history = history;
    }
}

@end
