//
//  BaseViewController.m
//  flags
//
//  Created by Chris Patuzzo on 06/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "BaseViewController.h"
#import "Utils.h"

@implementation BaseViewController

@synthesize mode=_mode;
@synthesize variant=_variant;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setModeAndVariant];
    [self setupBarStyles];
    [self setBackgroundColor];
}

- (void)setModeAndVariant
{
    NSString *title = self.navigationItem.title;
    
    if (!self.mode) {
        NSDictionary *modeByTitle = @{
            @"puzzles":            @"puzzle",
            @"colours":            @"puzzle",
            @"patterns + colours": @"puzzle",
            @"quiz":               @"quiz",
            @"all flags":          @"quiz",
            @"easy quiz":          @"quiz",
            @"hard quiz":          @"quiz",
        };
        
        self.mode = modeByTitle[title];
    }
    
    if (!self.variant) {
        NSDictionary *variantByTitle = @{
            @"colours":            @"easy",
            @"patterns + colours": @"hard",
            @"easy quiz":          @"easy",
            @"hard quiz":          @"hard",
        };
        
        self.variant = variantByTitle[title];
    }
    
//    NSLog(@"Mode: %@, Variant: %@", self.mode, self.variant);
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
    
    NSArray *menuIcon = [self menuIcon];
    if (menuIcon) {
        NSString *iconName = menuIcon[0];
        NSInteger iconWidth = [menuIcon[1] intValue];
        NSInteger iconHeight = [menuIcon[2] intValue];
        UIButton *iconButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
        [iconButton setFrame:CGRectMake(0, 0, iconWidth, iconHeight)];
        iconButton.imageEdgeInsets = UIEdgeInsetsMake(0, 16 - padding, 0, padding - 16);
        iconButton.userInteractionEnabled = NO;
        UIBarButtonItem *iconItem = [[UIBarButtonItem alloc] initWithCustomView:iconButton];
        self.navigationItem.rightBarButtonItem = iconItem;
    }
    
    NSArray *menuColor = [self menuColor];
    if (menuColor) {
        float red   = [menuColor[0] intValue] / 255.0f;
        float green = [menuColor[1] intValue] / 255.0f;
        float blue  = [menuColor[2] intValue] / 255.0f;
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        self.navigationController.navigationBar.barTintColor = color;
    }
}

- (void)returnToMenu:(UIButton *)menuButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setBackgroundColor
{
    // Use a default colour unless we explicitly set it in storyboard.
    if (self.view.backgroundColor == nil) {
        self.view.backgroundColor = [Utils backgroundColor];
    }
}

- (NSArray *)menuColor
{
    NSDictionary *menuColors = @{
         @"puzzle": @{
             @"default": @[@209, @62,  @97],
             @"easy":    @[@67,  @188, @137],
             @"hard":    @[@238, @103, @65]
         },
         @"quiz": @{
             @"default": @[@83,  @152, @180],
             @"easy":    @[@67,  @188, @137],
             @"hard":    @[@238, @103, @65],
         }
    };
    
    NSString *variant = self.variant ? self.variant : @"default";
    return menuColors[self.mode][variant];
}

- (NSArray *)menuIcon
{
    NSDictionary *menuIcons = @{
        @"puzzle": @[@"Puzzles-Bar-Icon", @28, @28],
        @"quiz":   @[@"Quiz-Bar-Icon",    @25, @27]
    };
    
    return menuIcons[self.mode];
}

@end
