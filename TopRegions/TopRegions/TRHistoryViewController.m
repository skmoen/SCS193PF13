//
//  TRHistoryViewController.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TRHistoryViewController.h"

@interface TRHistoryViewController ()

@end

@implementation TRHistoryViewController

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"History Cell"];
    
    return cell;
}

@end
