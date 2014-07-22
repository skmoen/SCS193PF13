//
//  TRNotifyContextCDTVC.h
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface TRNotifyContextViewController : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
