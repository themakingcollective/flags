//
//  Flag.h
//  flags
//
//  Created by Chris Patuzzo on 29/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flag : NSObject

@property (nonatomic, strong, readonly) NSString *name;

+ (NSArray *)all;
- (NSDictionary *)metadata;
- (NSArray *)imagePaths;
- (NSArray *)correctColors;
- (NSArray *)incorrectColors;

@end
