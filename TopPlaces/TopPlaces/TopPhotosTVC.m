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
#import "HistoryUserDefaults.h"

@interface TopPhotosTVC ()

@property (nonatomic) int maxResults;

@end

@implementation TopPhotosTVC

- (void)viewDidLoad
{
    self.maxResults = 50;
    self.cellIdentifier = @"Flickr Photo Cell";
    [self fetchPhotos];
    [super viewDidLoad];
}

-(void)fetchPhotos
{
    dispatch_queue_t fetchQ = dispatch_queue_create("top photos", NULL);
    dispatch_async(fetchQ, ^(void) {
        [self.refreshControl beginRefreshing]; // start the spinner
        NSURL *url = [FlickrFetcher URLforPhotosInPlace:[self.place valueForKeyPath:FLICKR_PLACE_ID] maxResults:self.maxResults];
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *dictResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                    options:0
                                                                      error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableData = @{@"photos": [dictResults valueForKeyPath:FLICKR_RESULTS_PHOTOS]};
            [self.refreshControl endRefreshing];
        });
    });
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    ImageViewController *ivc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Image"] && [ivc isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSDictionary *selected = [self.tableData[@"photos"] objectAtIndex:indexPath.row];
        [HistoryUserDefaults addPhotoToDefaults:selected];
    }
}


@end
