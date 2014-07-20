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
    
    NSDictionary *selected = [self.tableData[@"photos"] objectAtIndex:indexPath.row];
    
    NSString *title = [[selected valueForKeyPath:FLICKR_PHOTO_TITLE] stringByReplacingOccurrencesOfString:@"\n"
                                                                                               withString:@" "];
    NSString *description = [[selected valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] stringByReplacingOccurrencesOfString:@"\n"
                                                                                                           withString:@" "];
    
    if ([title isEqualToString:@""] && [description isEqualToString:@""]) {
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";
    }
    else {
        cell.textLabel.text = [title isEqualToString:@""] ? description : title;
        cell.detailTextLabel.text = description;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the Detail view controller in our UISplitViewController (nil if not in one)
    id detail = self.splitViewController.viewControllers[1];
    // if Detail is a UINavigationController, look at its root view controller to find it
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    // is the Detail is an ImageViewController?
    if ([detail isKindOfClass:[ImageViewController class]]) {
        // yes ... we know how to update that!
        ImageViewController *ivc = (ImageViewController*)detail;
        NSDictionary *selected = [self.tableData[@"photos"] objectAtIndex:indexPath.row];
        ivc.title = [selected valueForKeyPath:FLICKR_PHOTO_TITLE];
        ivc.imageURL = [FlickrFetcher URLforPhoto:selected format:FlickrPhotoFormatLarge];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ImageViewController *ivc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Image"] && [ivc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *selected = [self.tableData[@"photos"] objectAtIndex:indexPath.row];
        ivc.title = [selected valueForKeyPath:FLICKR_PHOTO_TITLE];
        ivc.imageURL = [FlickrFetcher URLforPhoto:selected format:FlickrPhotoFormatLarge];
    }
}

@end
