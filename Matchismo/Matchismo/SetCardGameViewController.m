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
        [cardString addAttribute:NSForegroundColorAttributeName value:[self colorForString:card.color withShading:card.shading] range:NSMakeRange(0, [cardString length])];
        if ( [card.shading isEqualToString:@"open"] )
            [cardString addAttribute:NSStrokeWidthAttributeName value:@3 range:NSMakeRange(0, [cardString length])];
        [cardButton setAttributedTitle:cardString forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
}

-(UIColor*)colorForString:(NSString*)string withShading:(NSString*)shading
{
    NSDictionary *shadeAlpha = @{@"striped": @0.3,
                                 @"solid": @1,
                                 @"open": @1};
    
    NSDictionary *colors = @{@"red": [UIColor colorWithRed:1 green:0 blue:0 alpha:[shadeAlpha[shading] floatValue]],  //[UIColor redColor],
                             @"green": [UIColor colorWithRed:0 green:1 blue:0 alpha:[shadeAlpha[shading] floatValue]],  //[UIColor greenColor],
                             @"blue": [UIColor colorWithRed:0 green:0 blue:1 alpha:[shadeAlpha[shading] floatValue]]};  // [UIColor blueColor]};
    return [colors objectForKey:string];
}

-(UIImage*)backgroundImageForCard:(Card*)card
{
    return [UIImage imageNamed:card.isChosen ? @"selectedcardfront" : @"cardfront"];
}

@end
