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

@property (nonatomic, assign) NSInteger roundsCount;
@property (nonatomic, assign) NSInteger correctCount;
@property (nonatomic, assign) NSInteger incorrectCount;

+ (ScoringService *)sharedInstance;

- (void)reset;
- (void)correctForFlag:(Flag *)flag andMode:(NSString *)mode andDifficulty:(NSString *)difficulty;
- (void)incorrectForFlag:(Flag *)flag andMode:(NSString *)mode andDifficulty:(NSString *)difficulty;

- (Flag *)bestFlag;
- (Flag *)worstFlag;

@end
