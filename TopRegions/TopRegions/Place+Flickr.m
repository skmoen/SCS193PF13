//
//  Place+Flickr.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Place+Flickr.h"
#import "Region+Flickr.h"
#import "FlickrFetcher.h"

@implementation Place (Flickr)

+(Place*)placeWithId:(NSString*)place_id inContext:(NSManagedObjectContext*)context
{
    Place *place = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"place_id = %@", place_id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches) {
        NSLog(@"Error fetching place: %@", place_id);
    }
    if ([matches count] > 1) {
        NSLog(@"Ambiguous results fetching place: %@; %@", place_id, matches);
    }
    if ([matches count] == 1) {
        place = [matches firstObject];
    }
    else {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        
        NSData *jsonPlace = [NSData dataWithContentsOfURL:[FlickrFetcher URLforInformationAboutPlace:place_id]];
        NSDictionary *dictPlace = [NSJSONSerialization JSONObjectWithData:jsonPlace
                                                                  options:0
                                                                    error:NULL];
        
        place.name = [FlickrFetcher extractNameOfPlace:place_id fromPlaceInformation:dictPlace];
        place.place_id = place_id;
        
        //place.region = [dictPlace valueForKeyPath:@"place.region._content"];
        place.region = [Region regionWithName:[FlickrFetcher extractRegionNameFromPlaceInformation:dictPlace] inContext:context];
    }

    return place;
}

@end
