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
@property (nonatomic, assign) BOOL allCorrect;
@property (nonatomic, assign) BOOL allIncorrect;

+ (ScoringService *)sharedInstance;

- (void)reset;
- (void)correctForFlag:(Flag *)flag andMode:(NSString *)mode andVariant:(NSString *)difficulty;
- (void)incorrectForFlag:(Flag *)flag andMode:(NSString *)mode andVariant:(NSString *)difficulty;

- (Flag *)bestFlag;
- (Flag *)worstFlag;

@end
