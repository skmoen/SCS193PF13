//
//  AttributeCounter.h
//  Matchismo
//
//  Created by scott.moen on 6/27/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttributeCounter : NSObject

-(void)addItemCount:(id)item;
-(id)objectForKey:(id)key;
-(NSInteger)countMatches;
-(NSInteger)countMismatches;

@end
