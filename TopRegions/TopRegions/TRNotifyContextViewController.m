//
//  TRNotifyContextCDTVC.m
//  TopRegions
//
//  Created by Scott Moen on 7/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "TRNotifyContextViewController.h"

@interface TRNotifyContextViewController ()

@end

@implementation TRNotifyContextViewController

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"topRegionsContext"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      self.managedObjectContext = note.userInfo[@"topRegionsContext"];
                                                  }]; 
}

@end
