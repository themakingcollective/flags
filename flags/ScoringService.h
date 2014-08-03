//
//  ScoringService.h
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flag.h"

@interface ScoringService : NSObject

+ (ScoringService *)sharedInstance;

- (void)reset;
- (void)correct:(Flag *)flag;
- (void)incorrect:(Flag *)flag;

@property (nonatomic, assign) NSInteger roundsCount;
@property (nonatomic, assign) NSInteger correctCount;
@property (nonatomic, assign) NSInteger incorrectCount;

@end
