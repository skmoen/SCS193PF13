//
//  AttributeCounter.m
//  Matchismo
//
//  Created by scott.moen on 6/27/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "AttributeCounter.h"

@interface AttributeCounter()

@property (nonatomic, strong) NSMutableDictionary *counter;

@end

@implementation AttributeCounter

-(NSMutableDictionary*)counter
{
    if (!_counter) _counter = [[NSMutableDictionary alloc] init];
    return _counter;
}

-(void)addItemCount:(id)item
{
    NSNumber *count = [self.counter objectForKey:item];
    if (count) {
        self.counter[item] = [NSNumber numberWithInteger:[count intValue] + 1];
    }
    else {
        self.counter[item] = @0;
    }
}

-(id)objectForKey:(id)key
{
    return [self.counter objectForKey:key];
}

-(NSInteger)countMatches
{
    int count = 0;
    for (id key in self.counter) {
        int val = [[self.counter objectForKey:key] intValue];
        count += val * val;
    }
    return count;
}

-(NSInteger)countMismatches
{
    int mismatch = 0;
    for (id key in self.counter) {
        if ( !([[self.counter objectForKey:key] isEqualToNumber:@0] ||
               [[self.counter objectForKey:key] isEqualToNumber:@2]) ) {
            mismatch++;
        }
    }
    return mismatch;
}


@end
