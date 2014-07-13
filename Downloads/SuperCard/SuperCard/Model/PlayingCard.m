//
//  PlayingCard.m
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards
{
    NSMutableDictionary *ranks = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *suits = [[NSMutableDictionary alloc] init];
    
    int rankScore = 0;
    int suitScore = 0;

    ranks[ [NSNumber numberWithInteger:self.rank] ] = @0;
    suits[ self.suit ] = @0;
    
    for (PlayingCard *card in otherCards) {
        NSNumber *numRank = [NSNumber numberWithInteger:card.rank];
        NSNumber *rankVal = [ranks objectForKey:numRank];
        if (rankVal) {
            ranks[numRank] = [NSNumber numberWithInteger:[rankVal intValue] + 1];
        }
        else {
            ranks[numRank] = @0;
        }

        NSNumber *suitVal = [suits objectForKey:card.suit];
        if (suitVal) {
            suits[card.suit] = [NSNumber numberWithInteger:[suitVal intValue] + 1];
        }
        else {
            suits[card.suit] = @0;
        }
    }
    
    for (id key in ranks) {
        rankScore += 4 * [[ranks objectForKey:key] intValue];
    }
    
    for (id key in suits) {
        suitScore += 1 * [[suits objectForKey:key] intValue];
    }
 
    return rankScore + suitScore;
}

-(NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter AND getter

+(NSArray *)validSuits {
    return @[@"♠",@"♣",@"♥",@"♦"];
}
-(void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}
-(NSString *)suit {
    return _suit ? _suit : @"?";
}

+(NSArray *)rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+(NSUInteger)maxRank {
    return [self rankStrings].count-1;
}
-(void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
