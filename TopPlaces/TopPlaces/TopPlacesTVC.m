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

@property (nonatomic, strong) NSMutableDictionary *placesByCountry;

@end

@implementation TopPlacesTVC

-(NSMutableDictionary*)placesByCountry
{
    if (!_placesByCountry) _placesByCountry = [[NSMutableDictionary alloc] init];
    return _placesByCountry;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing]; // start the spinner
    NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrFetcher URLforTopPlaces]];
    NSDictionary *dictResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                options:0
                                                                  error:NULL];
    
    for (NSDictionary *place in [dictResults valueForKeyPath:FLICKR_RESULTS_PLACES]) {
        NSArray *placeParts = [[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
        NSString *country = [placeParts lastObject];

        NSMutableArray *placeList = [self.placesByCountry objectForKey:country];
        if (!placeList) {
            placeList = [[NSMutableArray alloc] init];
            [self.placesByCountry setObject:placeList forKey:country];
        }
        [placeList addObject:place];
    }
    
    [self.refreshControl endRefreshing];
/*
    NSURL *url = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    // create a (non-main) queue to do fetch on
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    // put a block to do the fetch onto that queue
    dispatch_async(fetchQ, ^{
        // fetch the JSON data from Flickr
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        // convert it to a Property List (NSArray and NSDictionary)
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        // get the NSArray of photo NSDictionarys out of the results
        NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        // update the Model (and thus our UI), but do so back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing]; // stop the spinner
            self.photos = photos;
        });
    });
 */
}

#pragma mark - Table view data source

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self sortedKeys] objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.placesByCountry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.placesByCountry objectForKey:[[self sortedKeys] objectAtIndex:section]] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Flickr Place Cell" forIndexPath:indexPath];
    NSDictionary *city = [self cityAtIndexPath:indexPath];
    NSArray *cityParts = [[city valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    cell.textLabel.text = [cityParts firstObject];
    return cell;
}

-(NSArray*)sortedKeys
{
    return [[self.placesByCountry allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

}

-(NSDictionary*)cityAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *cities = [self.placesByCountry objectForKey:[[self sortedKeys] objectAtIndex:indexPath.section]];
    return [cities objectAtIndex:indexPath.row];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TopPhotosTVC *tptvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Top Photos"] && [tptvc isKindOfClass:[TopPhotosTVC class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        tptvc.place = [self cityAtIndexPath:indexPath];
        NSArray *cityParts = [[tptvc.place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
        tptvc.title = [cityParts firstObject];
    }
}


@end
