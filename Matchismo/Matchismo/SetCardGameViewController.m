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
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;

@end

@implementation SetCardGameViewController

- (void)drawRandomPlayingCard
{
    Card *card = [[self createDeck] drawRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard*)card;
        self.setCardView.number = setCard.number;
        self.setCardView.shading = setCard.shading;
        self.setCardView.color = setCard.color;
        self.setCardView.symbol = setCard.symbol;
    }
}

- (IBAction)tappedCard:(UITapGestureRecognizer *)sender {
    [self drawRandomPlayingCard];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.setCardView.number = 1;
    self.setCardView.color = 1;
    self.setCardView.symbol = 1;
    self.setCardView.shading = 1;
}

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(NSInteger)viewCardsToMatch
{
    return 2;
}

@end
