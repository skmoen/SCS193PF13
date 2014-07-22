//
//  Photo+Flickr.h
//  TopRegions
//
//  Created by Scott Moen on 7/20/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+(Photo*)photoWithFlickrInfo:(NSDictionary*)info inContext:(NSManagedObjectContext*)context;

@end
