//
//  HistoryUserDefaults.h
//  Shutterbug
//
//  Created by Scott Moen on 7/13/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryUserDefaults : NSObject

+(void)addPhotoToDefaults:(NSDictionary*)photo;
+(NSArray*)photoDefaults;

@end
