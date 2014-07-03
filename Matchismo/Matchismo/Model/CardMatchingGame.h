//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by scott.moen on 6/13/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck*)deck;

-(void)choseCardAtIndex:(NSUInteger)index;
-(Card*)cardAtIndex:(NSUInteger)index;
-(NSUInteger)cardsInPlay;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, strong) NSMutableArray *statusHistory;  // {"cards": ..., "score": ...}
@property (nonatomic) NSInteger cardsToMatch;
@property (nonatomic) BOOL removeMatched;

@end
