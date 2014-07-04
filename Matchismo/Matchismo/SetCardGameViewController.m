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
    self.cardsToMatch = 2;
    self.removeMatched = YES;
}

-(UIView*)cardViewWithCard:(Card*)card
{
    if ( !([card isKindOfClass:[SetCard class]]) ) return nil;
    
    SetCard *setCard = (SetCard*)card;
    SetCardView *view = [[SetCardView alloc] init];
    view.number = setCard.number;
    view.symbol = setCard.symbol;
    view.color = setCard.color;
    view.shading = setCard.shading;
    
    return view;
}
-(void)updateView:(UIView *)view withCard:(Card *)card
{
    if (![view isKindOfClass:[SetCardView class]]) return;
    if (![card isKindOfClass:[SetCard class]]) return;
    
    SetCardView *cardView = (SetCardView*)view;
    SetCard *setCard = (SetCard*)card;
        
    cardView.selected = setCard.isChosen;
}

-(BOOL)doesView:(UIView*)view representCard:(Card*)card
{
    if (![view isKindOfClass:[SetCardView class]]) return NO;
    if (![card isKindOfClass:[SetCard class]]) return NO;
    
    SetCardView *cardView = (SetCardView*)view;
    SetCard *setCard = (SetCard*)card;
    
    if (setCard.number != cardView.number) return NO;
    if (setCard.symbol != cardView.symbol) return NO;
    if (setCard.color != cardView.color) return NO;
    if (setCard.shading != cardView.shading) return NO;
    
    return YES;
}

@end
