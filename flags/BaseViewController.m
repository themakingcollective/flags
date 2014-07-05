//
//  BaseViewController.m
//  flags
//
//  Created by Chris Patuzzo on 06/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"Menu-Button"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(returnToMenu:)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 50, 30)];
    menuButton.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 7);
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuItem;
}

- (void)returnToMenu:(UIButton *)menuButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
