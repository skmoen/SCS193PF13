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
#import "Grid.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

@synthesize deck = _deck;

-(Deck*)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.cardsToMatch = 1;
    self.cardsToDeal = 24;
    self.grid.minimumNumberOfCells = self.cardsToDeal;
}

-(UIView*)viewWithCard:(Card*)card inFrame:(CGRect)frame
{
    if ( !([card isKindOfClass:[PlayingCard class]]) ) return nil;
    
    PlayingCard *playingCard = (PlayingCard*)card;
    PlayingCardView *view = [[PlayingCardView alloc] initWithFrame:frame];
    view.rank = playingCard.rank;
    view.suit = playingCard.suit;

    return view;
}

-(void)updateView:(UIView *)view withCard:(Card *)card
{
    PlayingCardView *cardView = (PlayingCardView*)view;
    if ( cardView.faceUp != card.isChosen ) {
        [UIView transitionWithView:cardView
                          duration:0.2
                           options:card.isChosen ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                        animations:^(void){
                            cardView.faceUp = card.isChosen;
                        }
                        completion:nil];
    }
}

- (void)drawRandomPlayingCard
{
    /*
    Card *card = [[self createDeck] drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        self.playingCardView.rank = playingCard.rank;
        self.playingCardView.suit = playingCard.suit;
    }
     */
}

@end

