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
#import "AggregatesService.h"

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
    
    [self syncWithFlagsServer:nil];
    NSString *freq = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Transmission Frequency"];
    [NSTimer scheduledTimerWithTimeInterval:[freq intValue] target:self selector:@selector(syncWithFlagsServer:) userInfo:nil repeats:YES];
                                                               
    return YES;
}
							
- (void)syncWithFlagsServer:(NSTimer *)timer
{
    if (!timer) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[EventRecorder sharedInstance] transmit];
            [[AggregatesService sharedInstance] fetch];
        });
    }
    else {
        [[EventRecorder sharedInstance] transmit];
        [[AggregatesService sharedInstance] fetch];
    }
}

@end
