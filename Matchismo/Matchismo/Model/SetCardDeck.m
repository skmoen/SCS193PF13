//
//  SetDeck.m
//  Matchismo
//
//  Created by Scott Moen on 6/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init {
    self = [super init];
        
    if (self) {
        for (NSUInteger number = 0; number <= [SetCard maxValue]; number++) {
            for (NSUInteger symbol = 0; symbol <= [SetCard maxValue]; symbol++) {
                for (NSUInteger shading = 0; shading <= [SetCard maxValue]; shading++) {
                    for (NSUInteger color = 0; color <= [SetCard maxValue]; color++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }    
    
    return self;
}

@end
