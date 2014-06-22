//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Scott Moen on 6/21/14.
//  Copyright (c) 2014 Scott Moen. All rights reserved.
//

#import "HistoryViewController.h"
#import "CardGameViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;

@end

@implementation HistoryViewController

-(void)updateUI
{
    self.statusTextView.text = self.history;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
}


@end
