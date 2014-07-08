//
//  SetCard.m
//  Matchismo
//
//  Created by Scott Moen on 6/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

-(int)match:(NSArray *)otherCards
{
    int mismatch = 0;
    
    NSMutableDictionary *numbers = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *colors = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *shadings = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *symbols = [[NSMutableDictionary alloc] init];
    
    numbers[ [NSNumber numberWithInteger:self.number] ] = @0;
    colors[self.color] = @0;
    shadings[self.shading] = @0;
    symbols[self.symbol] = @0;
    
    for (SetCard *card in otherCards) {
        NSNumber *num = [NSNumber numberWithInt:card.number];
        NSNumber *numVal = [numbers objectForKey:num];
        if (numVal) {
            numbers[num] = [NSNumber numberWithInt:[numVal intValue] + 1];
        }
        else {
            numbers[num] = @0;
        }
        
        NSNumber *colorVal = [colors objectForKey:card.color];
        if (colorVal) {
            colors[card.color] = [NSNumber numberWithInt:[colorVal intValue] + 1];
        }
        else {
            colors[card.color] = @0;
        }
        
        NSNumber *shadVal = [shadings objectForKey:card.shading];
        if (shadVal) {
            shadings[card.shading] = [NSNumber numberWithInt:[shadVal intValue] +1];
        }
        else {
            shadings[card.shading] = @0;
        }
        
        NSNumber *symVal = [symbols objectForKey:card.symbol];
        if (symVal) {
            symbols[card.symbol] = [NSNumber numberWithInt:[symVal intValue] + 1];
        }
        else {
            symbols[card.symbol] = @0;
        }
    }
    
    mismatch += [self countMismatchInDictionary:numbers];
    mismatch += [self countMismatchInDictionary:colors];
    mismatch += [self countMismatchInDictionary:shadings];
    mismatch += [self countMismatchInDictionary:symbols];
    
    return mismatch > 0 ? 0 : 5;
}

-(NSInteger)countMismatchInDictionary:(NSDictionary*)dictionary
{
    int mismatch = 0;
    for (id key in dictionary) {
        if ( !([[dictionary objectForKey:key] isEqualToNumber:@0] || [[dictionary objectForKey:key] isEqualToNumber:@2]) ) {
            mismatch++;
        }
    }
    return mismatch;
}

-(NSString*)contents
{
    return [NSString stringWithFormat:@"%d%@", self.number, self.symbol];
}

+(NSUInteger)maxNumber
{
    return 3;
}

+(NSUInteger)minNumber
{
    return 1;
}

+(NSArray*)validSymbols
{
    return @[@"▲", @"●", @"■"];
}

+(NSArray*)validColors
{
    return @[@"red", @"green", @"blue"];
}

+(NSArray*)validShadings
{
    return @[@"open", @"striped", @"solid"];
}

@end
