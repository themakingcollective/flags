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
    NSString *freq = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Transmission Frequency"];
    [NSTimer scheduledTimerWithTimeInterval:[freq intValue] target:self selector:@selector(transmitEvents:) userInfo:nil repeats:YES];

    return YES;
}
							
- (void)transmitEvents:(NSTimer *)timer
{
    if (!timer) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[EventRecorder sharedInstance] transmit];
        });
    }
    else {
        [[EventRecorder sharedInstance] transmit];
    }
}

@end
