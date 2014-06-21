//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by scott.moen on 6/13/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

-(NSMutableArray*)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray*)statusHistory
{
    if (!_statusHistory) _statusHistory = [[NSMutableArray alloc] init];
    return _statusHistory;
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

-(Card*)cardAtIndex:(NSUInteger)index
{
    return index<[self.cards count] ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(void)choseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSString *status = nil;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            status = [NSString stringWithFormat:@"Unselected %@", card.contents];
        }
        else {
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];
                    if ([chosenCards count] == self.cardsToMatch) {
                        int matchScore = [card match:chosenCards];
                        NSString *chosenString = [[chosenCards valueForKey:@"contents"] componentsJoinedByString:@" "];
                        
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            card.matched = YES;
                            for (Card *card in chosenCards) {
                                card.matched = YES;
                            }
                            status = [NSString stringWithFormat:@"Match found: %@ %@; +%d", card.contents, chosenString, matchScore * MATCH_BONUS];
                        }
                        else {
                            self.score -= MISMATCH_PENALTY;
                            for (Card *card in chosenCards) {
                                card.chosen = NO;
                            }
                            status = [NSString stringWithFormat:@"No Match: %@ %@; -%d", card.contents, chosenString, MISMATCH_PENALTY];
                        }
                        break;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            if (!status) {
                status = [NSString stringWithFormat:@"Selected %@; -%d", card.contents, COST_TO_CHOOSE];
            }
        }
    }
    [self.statusHistory addObject:status];
}

@end
