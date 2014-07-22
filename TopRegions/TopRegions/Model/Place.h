//
//  Place.h
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Region;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * place_id;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) Region *region;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
