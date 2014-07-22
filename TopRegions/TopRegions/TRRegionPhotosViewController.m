//
//  TRRegionPhotosViewController.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TRRegionPhotosViewController.h"
#import "ImageViewController.h"
#import "Photo+Flickr.h"

@interface TRRegionPhotosViewController ()

@end

@implementation TRRegionPhotosViewController

-(void)setRegion:(Region *)region
{
    _region = region;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"place.region = %@", region];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:[region managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Region Photos Cell"];
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


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ImageViewController *ivc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Photo"] && [ivc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        photo.lastViewed = [NSDate date];
        ivc.title = photo.title;
        ivc.imageURL = [NSURL URLWithString:photo.imageURL];
    }
}


@end
