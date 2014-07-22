//
//  TRAppDelegate.m
//  TopRegions
//
//  Created by Scott Moen on 7/20/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TRAppDelegate.h"
#import "TRRegionsViewController.h"
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"

@interface TRAppDelegate()

@property (strong, nonatomic) NSManagedObjectContext *topRegionsContext;
@property (strong, nonatomic) UIManagedDocument *managedDocument;

@end

@implementation TRAppDelegate

#pragma mark - Accessors
-(void)setTopRegionsContext:(NSManagedObjectContext *)topRegionsContext
{
    _topRegionsContext = topRegionsContext;
    
    // notify anyone who cares that the context has been updated
    NSDictionary *userInfo = @{@"topRegionsContext": self.topRegionsContext};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topRegionsContext"
                                                        object:self
                                                      userInfo:userInfo];
}

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.managedDocument = [self createContextDocument];
    [self startFlickrFetch];
    return YES;
}


#pragma mark - Flickr
-(void)startFlickrFetch
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]
                                                completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"Flickr background fetch failed: %@", error.localizedDescription);
                                                    } else {
                                                        [self loadFlickrPhotosFromFile:location
                                                                           intoContext:self.topRegionsContext];
                                                    }
                                                }];
    task.taskDescription = @"Flickr GeoreferencedPhotos Download";
    [task resume];
    
}

-(void)loadFlickrPhotosFromFile:(NSURL*)location intoContext:(NSManagedObjectContext*)context
{
    NSData *jsonResults = [NSData dataWithContentsOfURL:location];
    NSDictionary *dictResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                options:0
                                                                  error:NULL];
    NSArray *photos = [dictResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    for (NSDictionary *photoDict in photos) {
        [Photo photoWithFlickrInfo:photoDict inContext:context];

        //break;
    }
    
    [self.managedDocument saveToURL:[self.managedDocument fileURL]
       forSaveOperation:UIDocumentSaveForOverwriting
      completionHandler:^(BOOL success) {
          NSLog(@"SAVED... ?");
      }];

}

//-(NSManagedObjectContext*)createContextDocument
//-(void)createContextDocument
-(UIManagedDocument*)createContextDocument
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *directory = [[manager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *pathURL = [directory URLByAppendingPathComponent:@"TopRegionsData"];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:pathURL];

    if ([[NSFileManager defaultManager] fileExistsAtPath:[pathURL path]]) {
        [document openWithCompletionHandler:^(BOOL success) {
            NSLog(@"Opened %@: %@", pathURL, success ? @"YES" : @"no");
            if ( document.documentState == UIDocumentStateNormal) {
                self.topRegionsContext = document.managedObjectContext;
            }
        }];
    }
    else {
        [document saveToURL:[document fileURL]
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              NSLog(@"Created %@: %@", pathURL, success ? @"YES" : @"no");
              if ( document.documentState == UIDocumentStateNormal) {
                  self.topRegionsContext = document.managedObjectContext;
              }
          }];
    }
    
    return document;
}

/*
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
 */

@end
