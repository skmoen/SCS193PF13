//
//  HistoryUserDefaults.m
//  Shutterbug
//
//  Created by Scott Moen on 7/13/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "HistoryUserDefaults.h"

@implementation HistoryUserDefaults

+(void)addPhotoToDefaults:(NSDictionary*)photo
{
    NSMutableArray *current = [[[NSUserDefaults standardUserDefaults] objectForKey:@"history"] mutableCopy];
    if (!current) current = [[NSMutableArray alloc] init];
    
    NSUInteger index = [current indexOfObject:photo];
    if (index != NSNotFound) {
        [current removeObjectAtIndex:index];
    }
    [current insertObject:photo atIndex:0];
    if ([current count] > 20) {
        [current removeLastObject];
    }
    [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"history"];
}


+(NSArray*)photoDefaults
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"history"];
}

@end
