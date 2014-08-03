//
//  ScoringService.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ScoringService.h"

@implementation ScoringService

@synthesize roundsCount=_roundsCount;
@synthesize correctCount=_correctCount;
@synthesize incorrectCount=_incorrectCount;

+ (ScoringService *)sharedInstance
{
    static dispatch_once_t once;
    static ScoringService *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)reset
{
    self.correctCount = 0;
    self.incorrectCount = 0;
}

- (void)correct
{
    self.correctCount++;
    self.roundsCount++;
}

- (void)incorrect
{
    self.incorrectCount++;
    self.roundsCount++;
}

@end
