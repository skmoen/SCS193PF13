//
//  TopPhotosTVC.m
//  TopPlaces
//
//  Created by Scott Moen on 7/13/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TopPhotosTVC.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface TopPhotosTVC ()

@property (nonatomic, strong) NSArray *photos; // of NSDictionary
@property (nonatomic) int maxResults;

@end

@implementation TopPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.maxResults = 50;
    [self fetchPhotos];
}

-(void)fetchPhotos
{
    [self.refreshControl beginRefreshing]; // start the spinner
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:[self.place valueForKeyPath:FLICKR_PLACE_ID] maxResults:self.maxResults];
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *dictResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                options:0
                                                                  error:NULL];
    self.photos = [dictResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Photo Cell" forIndexPath:indexPath];
    
    NSString *title = [[self.photos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.textLabel.text = [title isEqualToString:@""] ? @"Unknown" : title;
    NSString *description = [[self.photos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    cell.detailTextLabel.text = [description isEqualToString:@""] ? @"Unknown" : description;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ImageViewController *ivc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Image"] && [ivc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ivc.title = [[self.photos objectAtIndex:indexPath.row] valueForKeyPath:FLICKR_PHOTO_TITLE];
        ivc.imageURL = [FlickrFetcher URLforPhoto:[self.photos objectAtIndex:indexPath.row]
                                           format:FlickrPhotoFormatLarge];
    }
}


@end
