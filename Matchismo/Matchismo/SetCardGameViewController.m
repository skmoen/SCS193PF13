//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Scott Moen on 6/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()
@end

@implementation SetCardGameViewController

@synthesize deck = _deck;

-(Deck*)deck
{
    if (!_deck) _deck = [[SetCardDeck alloc] init];
    return _deck;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.cardsToDeal = 12;
    self.grid.minimumNumberOfCells = self.cardsToDeal;
    self.cardsToMatch = 2;
    self.removeMatched = YES;
}

-(UIView*)viewWithCard:(Card*)card inFrame:(CGRect)frame
{
    if ( !([card isKindOfClass:[SetCard class]]) ) return nil;
    
    SetCard *setCard = (SetCard*)card;
    SetCardView *view = [[SetCardView alloc] initWithFrame:frame];
    view.number = setCard.number;
    view.symbol = setCard.symbol;
    view.color = setCard.color;
    view.shading = setCard.shading;
    
    return view;
}
-(void)updateView:(UIView *)view withCard:(Card *)card
{
    SetCardView *cardView = (SetCardView*)view;
    SetCard *setCard = (SetCard*)card;
    
    if ( card.isMatched && cardView.alpha == 1 ) {
        [UIView animateWithDuration:0.5
                         animations:^(void){
                             cardView.alpha = 0.5;
                         }];
    }
    
    cardView.selected = setCard.isChosen;
}

-(BOOL)card:(Card*)card isRepresentedByView:(UIView*)view
{
    SetCardView *cardView = (SetCardView*)view;
    SetCard *setCard = (SetCard*)card;

    if (setCard.number != cardView.number) return NO;
    if (setCard.symbol != cardView.symbol) return NO;
    if (setCard.color != cardView.color) return NO;
    if (setCard.shading != cardView.shading) return NO;
    
    return YES;
}

- (void)drawRandomPlayingCard
{
    /*
    Card *card = [[self createDeck] drawRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard*)card;
        self.setCardView.number = setCard.number;
        self.setCardView.shading = setCard.shading;
        self.setCardView.color = setCard.color;
        self.setCardView.symbol = setCard.symbol;
    }
     */
}

@end
