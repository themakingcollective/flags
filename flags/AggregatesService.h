//
//  AggregatesService.h
//  flags
//
//  Created by Chris Patuzzo on 27/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flag.h"

@interface AggregatesService : NSObject

+ (AggregatesService *)sharedInstance;
+ (NSDictionary *)withStats:(NSDictionary *)aggregate;

- (void)fetch;
- (NSString *)textForFlag:(Flag *)flag andMode:(NSString *)mode andDifficulty:(NSString *)difficulty andCorrectness:(BOOL)correct;
- (NSArray *)where:(NSDictionary *)filters;

@end
