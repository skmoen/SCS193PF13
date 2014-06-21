//
//  SetCard.h
//  Matchismo
//
//  Created by Scott Moen on 6/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic, strong) NSString *symbol;
//@property (nonatomic, strong) NSString *shading;
//@property (nonatomic, strong) NSString *color;

+(NSUInteger)maxNumber;
+(NSUInteger)minNumber;

+(NSArray*)validSymbols;
+(NSArray*)validShadings;
+(NSArray*)validColors;

@end
