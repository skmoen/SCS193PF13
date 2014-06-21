//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Scott Moen on 6/10/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

-(Deck *)createDeck;  // abstract

@end
