//
//  ViewController.m
//  flags
//
//  Created by chris on 22/03/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "MenuController.h"
#import "PointsService.h"

@interface MenuController ()

@property (weak, nonatomic) IBOutlet UILabel *totalPointsLabel;

@end

@implementation MenuController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    NSInteger points = [PointsService sharedInstance].totalPoints;
    self.totalPointsLabel.text = [NSString stringWithFormat:@"Total points: %ld", points];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

@end
