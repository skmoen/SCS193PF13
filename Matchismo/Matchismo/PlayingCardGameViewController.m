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

-(UIView*)cardViewWithCard:(Card*)card
{
    if ( !([card isKindOfClass:[PlayingCard class]]) ) return nil;
    
    PlayingCard *playingCard = (PlayingCard*)card;
    PlayingCardView *view = [[PlayingCardView alloc] init];
    view.rank = playingCard.rank;
    view.suit = playingCard.suit;

    return view;
}

-(void)updateView:(UIView *)view withCard:(Card *)card
{
    if (![view isKindOfClass:[PlayingCardView class]]) return;
    if (![card isKindOfClass:[PlayingCard class]]) return;
    
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
    if ( card.isMatched && cardView.alpha == 1 ) {
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             cardView.alpha = 0.5;
                         }];
    }
}

-(BOOL)doesView:(UIView*)view representCard:(Card*)card
{
    if (![view isKindOfClass:[PlayingCardView class]]) return NO;
    if (![card isKindOfClass:[PlayingCard class]]) return NO;
    
    PlayingCardView *cardView = (PlayingCardView*)view;
    PlayingCard *playingCard = (PlayingCard*)card;
    
    if (![playingCard.suit isEqualToString:cardView.suit]) return NO;
    if (playingCard.rank != cardView.rank) return NO;
    
    return YES;
}

@end

