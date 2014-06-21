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
    
    return 0;
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
