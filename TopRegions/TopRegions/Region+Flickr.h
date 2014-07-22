//
//  Region+Flickr.h
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Region.h"

@interface Region (Flickr)

+(Region*)regionWithName:(NSString*)name inContext:(NSManagedObjectContext*)context;

@end
