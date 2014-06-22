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

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(NSInteger)viewCardsToMatch
{
    return 2;
}

-(void)updateCards
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        SetCard *card = (SetCard*)[self.game cardAtIndex:cardButtonIndex];
        NSMutableAttributedString *cardString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%@", card.number, card.symbol]];
        [cardString addAttribute:NSForegroundColorAttributeName value:[self colorForString:card.color] range:NSMakeRange(0, [cardString length])];
        [cardString addAttribute:NSStrokeWidthAttributeName value:[self shadingForString:card.shading] range:NSMakeRange(0, [cardString length])];

        [cardButton setAttributedTitle:cardString forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
}

-(UIColor*)colorForString:(NSString*)string
{
    NSDictionary *colors = @{@"red": [UIColor redColor],
                             @"green": [UIColor greenColor],
                             @"blue": [UIColor blueColor]};
    return [colors objectForKey:string];
}

-(NSDictionary*)shadingForString:(NSString*)string
{
    NSDictionary *shading = @{@"open": @0,
                              @"striped": @(-4),
                              @"solid": @4};
    
    return [shading objectForKey:string];
}

-(UIImage*)backgroundImageForCard:(Card*)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardback" : @"cardfront"];
}

@end
