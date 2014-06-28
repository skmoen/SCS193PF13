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
    NSMutableDictionary* history = [[NSMutableDictionary alloc] init];
    int scoreChange = 0;
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        }
        else {
            [history setObject:[NSMutableArray arrayWithObject:card] forKey:@"cards"];
            NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [chosenCards addObject:otherCard];
                    [history[@"cards"] addObject:otherCard];
                    if ([chosenCards count] == self.cardsToMatch) {
                        int matchScore = [card match:chosenCards];
                        if (matchScore) {
                            scoreChange += matchScore * MATCH_BONUS;
                            card.matched = YES;
                            for (Card *card in chosenCards) {
                                card.matched = YES;
                            }
                        }
                        else {
                            scoreChange -= MISMATCH_PENALTY;
                            for (Card *card in chosenCards) {
                                card.chosen = NO;
                            }
                        }
                        break;
                    }
                }
            }
            scoreChange -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
    self.score += scoreChange;
    [history setObject:[NSNumber numberWithInt:scoreChange] forKey:@"score"];
    [self.statusHistory addObject:history];
}

@end
