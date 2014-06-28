//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Scott Moen on 6/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"

@interface PlayingCardGameViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end

@implementation PlayingCardGameViewController

- (void)drawRandomPlayingCard
{
    Card *card = [[self createDeck] drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        self.playingCardView.rank = playingCard.rank;
        self.playingCardView.suit = playingCard.suit;
    }
}

- (IBAction)tappedCard:(UITapGestureRecognizer *)sender {
    if (!self.playingCardView.faceUp) [self drawRandomPlayingCard];
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.playingCardView.rank = 13;
    self.playingCardView.suit = @"♥︎";
}

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSInteger)viewCardsToMatch
{
    return 1;
}
@end

