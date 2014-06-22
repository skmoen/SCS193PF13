//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;

+(NSString*)stringFromHistory:(NSDictionary*)history;

-(NSInteger)viewCardsToMatch;  // abstract
-(Deck *)createDeck;  // abstract

@end
