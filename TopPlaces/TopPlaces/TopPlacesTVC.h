//
//  TopPlacesTVC.h
//  TopPlaces
//
//  Created by Scott Moen on 7/12/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopPlacesTVC : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *itemsBySection;

-(NSArray*)sortedKeys;

@end
