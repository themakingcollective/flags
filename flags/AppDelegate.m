//
//  AppDelegate.m
//  flags
//
//  Created by chris on 22/03/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "AppDelegate.h"
#import "Flag.h"
#import "EventRecorder.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIFont *font = [UIFont fontWithName:@"BPreplay" size:17];
    [[UILabel appearance] setFont:font];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName: [UIColor whiteColor],
       NSFontAttributeName: [UIFont fontWithName:@"BPreplay" size:22]
     }];
    
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:2 forBarMetrics:UIBarMetricsDefault];
    
    [self transmitEvents:nil];
    [NSTimer scheduledTimerWithTimeInterval:(5 * 60) target:self selector:@selector(transmitEvents:) userInfo:nil repeats:YES];

    return YES;
}
							
- (void)transmitEvents:(NSTimer *)timer
{
    [[EventRecorder sharedInstance] transmit];
}

@end
