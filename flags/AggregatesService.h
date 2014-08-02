//
//  AggregatesService.h
//  flags
//
//  Created by Chris Patuzzo on 27/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AggregatesService : NSObject

+ (AggregatesService *)sharedInstance;
- (void)fetch;
- (NSArray *)where:(NSDictionary *)filters;

@end
