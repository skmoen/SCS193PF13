//
//  Region+Flickr.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Region+Flickr.h"

@implementation Region (Flickr)

+(Region*)regionWithName:(NSString*)name inContext:(NSManagedObjectContext*)context
{
    Region *region = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches) {
        NSLog(@"Error fetching region: %@", name);
    }
    if ([matches count] > 1) {
        NSLog(@"Ambiguous results fetching region: %@; %@", name, matches);
    }
    if ([matches count] == 1) {
        region = [matches firstObject];
    }
    else {
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
        region.name = name;
    }
    
    return region;
}

@end
