//
//  PhotosTVC.m
//  TopPlaces
//
//  Created by Scott Moen on 7/15/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "PhotosTVC.h"
#import "ImageViewController.h"
#import "FlickrFetcher.h"

@interface PhotosTVC ()

@end

@implementation PhotosTVC

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    NSDictionary *selected = [self.itemsBySection[@"photos"] objectAtIndex:indexPath.row];
    
    NSString *title = [selected valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.textLabel.text = [title isEqualToString:@""] ? @"Unknown" : title;
    NSString *description = [selected valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    cell.detailTextLabel.text = [description isEqualToString:@""] ? @"Unknown" : description;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ImageViewController *ivc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Image"] && [ivc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *selected = [self.itemsBySection[@"photos"] objectAtIndex:indexPath.row];
        ivc.title = [selected valueForKeyPath:FLICKR_PHOTO_TITLE];
        ivc.imageURL = [FlickrFetcher URLforPhoto:selected format:FlickrPhotoFormatLarge];
    }
}

@end
