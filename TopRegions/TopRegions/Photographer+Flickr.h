//
//  Photographer+Flickr.h
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Flickr)

+(Photographer*)photographerWithName:(NSString*)name inContext:(NSManagedObjectContext*)context;

@end
