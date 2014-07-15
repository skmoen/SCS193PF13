//
//  RecentPhotosTVC.m
//  TopPlaces
//
//  Created by Scott Moen on 7/13/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "HistoryUserDefaults.h"
#import "FlickrFetcher.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cellIdentifier = @"Recent Photo Cell";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.itemsBySection[@"photos"] = [HistoryUserDefaults photoDefaults];
    [self.tableView reloadData];
}

@end
