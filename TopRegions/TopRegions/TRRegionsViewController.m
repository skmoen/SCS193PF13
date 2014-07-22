//
//  TRRegionsViewController.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TRRegionsViewController.h"
#import "TRRegionPhotosViewController.h"
#import "Region+Flickr.h"

@interface TRRegionsViewController ()

@end

@implementation TRRegionsViewController

@synthesize managedObjectContext = _managedObjectContext;

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"photographerCount"
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
                                                               
    request.fetchLimit = 50;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Regions Cell"];

    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = region.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [region.photographers count]];  //region.photographerCount.intValue];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TRRegionPhotosViewController *trpvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Region Photos"] && [trpvc isKindOfClass:[TRRegionPhotosViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
        trpvc.title = region.name;
        trpvc.region = region;
    }
    
}

@end
