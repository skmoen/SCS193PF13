//
//  TopPlacesTVC.m
//  TopPlaces
//
//  Created by Scott Moen on 7/12/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TopPlacesTVC.h"
#import "TopPhotosTVC.h"
#import "FlickrFetcher.h"

@interface TopPlacesTVC ()

@end

@implementation TopPlacesTVC

-(NSMutableDictionary*)itemsBySection
{
    if (!_itemsBySection) _itemsBySection = [[NSMutableDictionary alloc] init];
    //[self.tableView reloadData];
    return _itemsBySection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self numberOfSectionsInTableView:tableView] < 2) return nil;
    return [[self sortedKeys] objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.itemsBySection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = [self.itemsBySection objectForKey:[[self sortedKeys] objectAtIndex:section]];
    return [sectionArray count];
}

-(NSArray*)sortedKeys
{
    return [[self.itemsBySection allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}

@end
