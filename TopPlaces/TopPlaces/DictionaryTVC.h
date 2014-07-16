//
//  DictionaryTVC.h
//  TopPlaces
//
//  Created by scott.moen on 7/15/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DictionaryTVC : UITableViewController

@property (strong, nonatomic) NSDictionary *tableData;

-(NSArray*)sortedKeys;

@end
