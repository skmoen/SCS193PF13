//
//  SetCard.m
//  Matchismo
//
//  Created by Scott Moen on 6/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "SetCard.h"
#import "AttributeCounter.h"

@implementation SetCard

-(int)match:(NSArray *)otherCards
{
    int mismatch = 0;
    
    AttributeCounter *numbers = [[AttributeCounter alloc] init];
    AttributeCounter *colors = [[AttributeCounter alloc] init];
    AttributeCounter *shadings = [[AttributeCounter alloc] init];
    AttributeCounter *symbols = [[AttributeCounter alloc] init];
    
    [numbers addItemCount:[NSNumber numberWithInt:self.number]];
    [colors addItemCount:[NSNumber numberWithInt:self.color]];
    [shadings addItemCount:[NSNumber numberWithInt:self.shading]];
    [symbols addItemCount:[NSNumber numberWithInt:self.symbol]];
    
    for (SetCard *card in otherCards) {
        [numbers addItemCount:[NSNumber numberWithInt:card.number]];
        [colors addItemCount:[NSNumber numberWithInt:card.color]];
        [shadings addItemCount:[NSNumber numberWithInt:card.shading]];
        [symbols addItemCount:[NSNumber numberWithInt:card.symbol]];
    }
    
    mismatch += [numbers countMismatches];
    mismatch += [colors countMismatches];
    mismatch += [shadings countMismatches];
    mismatch += [symbols countMismatches];
    
    return mismatch > 0 ? 0 : 5;
}

-(NSString*)contents
{
    return nil;
}

+(NSUInteger)maxValue
{
    return 2;
}

@end
