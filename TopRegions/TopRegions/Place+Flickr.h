//
//  Place+Flickr.h
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Place.h"

@interface Place (Flickr)

+(Place*)placeWithId:(NSString*)place_id inContext:(NSManagedObjectContext*)context;

@end
