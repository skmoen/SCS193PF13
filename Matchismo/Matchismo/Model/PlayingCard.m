//
//  PlayingCard.m
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "PlayingCard.h"
#import "AttributeCounter.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards
{
    AttributeCounter *ranks = [[AttributeCounter alloc] init];
    AttributeCounter *suits = [[AttributeCounter alloc] init];
    
    int rankScore = 0;
    int suitScore = 0;

    [ranks addItemCount:[NSNumber numberWithInt:self.rank]];
    [suits addItemCount:self.suit];
    
    for (PlayingCard *card in otherCards) {
        [ranks addItemCount:[NSNumber numberWithInt:card.rank]];
        [suits addItemCount:card.suit];
    }
    
    rankScore += 4 * [ranks countMatches];
    rankScore += [suits countMatches];
 
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
