//
//  BaseViewController.m
//  flags
//
//  Created by Chris Patuzzo on 06/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "BaseViewController.h"
#import "Utils.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBarStyles];
    
    // Use a default colour unless we explicitly set it in storyboard.
    if (self.view.backgroundColor == nil) {
        self.view.backgroundColor = [Utils backgroundColor];
    }
}

- (void)setupBarStyles
{
    NSInteger padding = 10;
    
    // Set up the menu button.
    UIButton *menuButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"Menu-Button"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(returnToMenu:)forControlEvents:UIControlEventTouchUpInside];
    [menuButton setFrame:CGRectMake(0, 0, 50, 30)];
    menuButton.imageEdgeInsets = UIEdgeInsetsMake(0, padding - 16, 0, 16 - padding);
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = menuItem;
    
    // Get the bar styles based on the title.
    NSArray *rgbIcon = @{  // red  green blue      icon name       width height
      @"puzzles":            @[@209, @62,  @97,  @"Puzzles-Bar-Icon", @28, @28],
      @"colours":            @[@67,  @188, @137, @"Puzzles-Bar-Icon", @28, @28],
      @"patterns + colours": @[@238, @103, @65,  @"Puzzles-Bar-Icon", @28, @28],
      @"your highlights":    @[@67,  @188, @137, @"Puzzles-Bar-Icon", @28, @28], // todo - make this better
      @"quiz":               @[@83,  @152, @180, @"Quiz-Bar-Icon",    @25, @27],
      @"all flags":          @[@83,  @152, @180, @"Quiz-Bar-Icon",    @25, @27],
      @"easy quiz":          @[@67,  @188, @137, @"Quiz-Bar-Icon",    @25, @27],
      @"hard quiz":          @[@238, @103, @65,  @"Quiz-Bar-Icon",    @25, @27]
     }[self.navigationItem.title];
    
    // Set the bar icon.
    if (rgbIcon) {
        NSString *iconName = rgbIcon[3];
        NSInteger iconWidth = [rgbIcon[4] intValue];
        NSInteger iconHeight = [rgbIcon[5] intValue];
        UIButton *iconButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
        [iconButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
        iconButton.imageEdgeInsets = UIEdgeInsetsMake(0, 16 - padding, 0, padding - 16);
        iconButton.userInteractionEnabled = NO;
        UIBarButtonItem *iconItem = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
        self.navigationItem.rightBarButtonItem = iconItem;
    }
    
    // Set the bar colour.
    float red   = [rgbIcon[0] intValue] / 255.0f;
    float green = [rgbIcon[1] intValue] / 255.0f;
    float blue  = [rgbIcon[2] intValue] / 255.0f;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
    self.navigationController.navigationBar.barTintColor = color;
}

- (void)returnToMenu:(UIButton *)menuButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
