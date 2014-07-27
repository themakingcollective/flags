//
//  AggregatesService.m
//  flags
//
//  Created by Chris Patuzzo on 27/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "AggregatesService.h"

@implementation AggregatesService

+ (AggregatesService *)sharedInstance
{
    static dispatch_once_t once;
    static AggregatesService *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSURL *)url
{
    NSString *host = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Flags Server"];
    NSString *path = [NSString stringWithFormat:@"%@/aggregates", host];
    
    return [NSURL URLWithString:path];
}

- (void)fetch
{
    
}

@end
