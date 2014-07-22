//
//  Photo+Flickr.m
//  TopRegions
//
//  Created by Scott Moen on 7/20/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Photo+Flickr.h"
#import "Photographer+Flickr.h"
#import "Place+Flickr.h"
#import "Region+Flickr.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

+(Photo*)photoWithFlickrInfo:(NSDictionary*)info inContext:(NSManagedObjectContext*)context
{
    Photo *photo = nil;
    
    NSString *photo_id = [info valueForKeyPath:FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"photo_id = %@", photo_id];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (error || !matches) {
        NSLog(@"Error fetching photo: %@", info);
    }
    if ([matches count] > 1) {
        NSLog(@"Ambiguous results fetching photo: %@; %@", info, matches);
    }
    if ([matches count] == 1) {
        photo = [matches firstObject];
    }
    else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.photo_id = [info valueForKeyPath:FLICKR_PHOTO_ID];
        photo.title = [info valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.descr = [info valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.imageURL = [[FlickrFetcher URLforPhoto:info format:FlickrPhotoFormatLarge] absoluteString];
        
        photo.photographer = [Photographer photographerWithName:[info valueForKeyPath:FLICKR_PHOTO_OWNER]
                                                      inContext:context];
        
        photo.place = [Place placeWithId:[info valueForKeyPath:FLICKR_PHOTO_PLACE_ID] inContext:context];
        
        if (![photo.place.region.photographers containsObject:photo.photographer]) {
            [photo.photographer addRegionsObject:photo.place.region];
            photo.place.region.photographerCount = @(photo.place.region.photographerCount.intValue + 1);
        }
    }
    
    return photo;
}

@end
