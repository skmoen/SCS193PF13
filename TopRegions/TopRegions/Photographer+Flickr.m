//
//  Photographer+Flickr.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Photographer+Flickr.h"

@implementation Photographer (Flickr)

+(Photographer*)photographerWithName:(NSString*)name inContext:(NSManagedObjectContext*)context
{
    Photographer *photographer = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches) {
        NSLog(@"Error fetching photographer: %@", name);
    }
    if ([matches count] > 1) {
        NSLog(@"Ambiguous results fetching photographer: %@; %@", name, matches);
    }
    if ([matches count] == 1) {
        photographer = [matches firstObject];
    }
    else {
        photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
        photographer.name = name;
    }
    
    return photographer;
}

@end
