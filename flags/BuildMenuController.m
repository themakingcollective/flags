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
    if ([self showExplanation:@"easy-explanation-views"]) {
        [self navigateTo:@"PuzzleEasyStart" variant:@"easy"];
    }
    else {
        [self navigateTo:@"PuzzleController" variant:@"easy"];
    }
}

- (IBAction)optionTwo:(id)sender {
    if ([self showExplanation:@"hard-explanation-views"]) {
        [self navigateTo:@"PuzzleHardStart" variant:@"hard"];
    }
    else {
        [self navigateTo:@"PuzzleController" variant:@"hard"];
    }
}

- (void)navigateTo:(NSString *)controllerId variant:(NSString *)variant
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BaseViewController *controller = [storyboard instantiateViewControllerWithIdentifier:controllerId];
    
    controller.mode = self.mode;
    controller.variant = variant;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)showExplanation:(NSString *)key
{
    NSInteger views = [self get:key];
    if (views < 3) {
        views += 1;
        [self set:key value:views];
        return YES;
    }
    else {
        return NO;
    }
}

- (NSInteger)get:(NSString *)key
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences integerForKey:key];
}

- (void)set:(NSString *)key value:(NSInteger)value
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:value forKey:key];
    [preferences synchronize];
}

@end
