//
//  BuildMenuController.m
//  flags
//
//  Created by Chris Patuzzo on 23/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "BuildMenuController.h"

@interface BuildMenuController ()

@end

@implementation BuildMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)optionOne:(id)sender {
    [self navigateTo:@"PuzzleEasyStart"];
}

- (IBAction)optionTwo:(id)sender {
    [self navigateTo:@"PuzzleHardStart"];
}

- (void)navigateTo:(NSString *)controllerId
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BaseViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    controller.mode = self.mode;
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
