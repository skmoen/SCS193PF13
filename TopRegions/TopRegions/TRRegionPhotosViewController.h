//
//  TRRegionPhotosViewController.h
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Region+Flickr.h"

@interface TRRegionPhotosViewController : CoreDataTableViewController

@property (strong, nonatomic) Region *region;

@end
