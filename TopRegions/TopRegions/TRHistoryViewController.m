//
//  TRHistoryViewController.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TRHistoryViewController.h"
#import "ImageViewController.h"
#import "Photo+Flickr.h"

@interface TRHistoryViewController ()

@end

@implementation TRHistoryViewController

@synthesize managedObjectContext = _managedObjectContext;

-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"lastViewed != nil"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
    request.fetchLimit = 20;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:_managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"History Cell"];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.descr;
    
    cell.imageView.image = nil;
    if (photo.thumbnail) {
        cell.imageView.image = [UIImage imageWithData:photo.thumbnail];
    }
    else {
        dispatch_queue_t thumbQ = dispatch_queue_create("Thumbnail Queue", NULL);
        dispatch_async(thumbQ, ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumbURL]];
            photo.thumbnail = data;
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setNeedsLayout];
            });
        });
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ImageViewController *ivc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Photo"] && [ivc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ivc.title = photo.title;
        ivc.imageURL = [NSURL URLWithString:photo.imageURL];
    }
}

@end
