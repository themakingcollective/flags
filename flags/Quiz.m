//
//  Quiz.m
//  flags
//
//  Created by Chris Patuzzo on 22/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "Quiz.h"
#import "Utils.h"

@interface Quiz ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) NSInteger rounds;
@property (nonatomic, strong) NSArray *chosenElements;
@property (nonatomic, assign) NSInteger currentRound;

@end

@implementation Quiz

@synthesize correctCount=_correctCount;
@synthesize incorrectCount=_incorrectCount;

- (id)initWithArray:(NSArray *)array andRounds:(NSInteger)rounds
{
    self = [super init];
    if (self) {
        self.array = array;
        self.rounds = rounds;
        self.correctCount = 0;
        self.incorrectCount = 0;
        
        [self setupRounds];
    }
    return self;
}

- (void)setupRounds
{
    NSArray *shuffledArray = [Utils shuffle:self.array];
    NSArray *slicedArray = [shuffledArray subarrayWithRange:(NSRange){0, self.rounds}];
    
    self.chosenElements = slicedArray;
    self.currentRound = 0;
}

- (id)currentElement
{
    if (self.currentRound < [self.chosenElements count]) {
        return [self.chosenElements objectAtIndex:self.currentRound];
    }
    else {
        return nil;
    }
}

- (void)nextRound
{
    self.currentRound++;
}

@end
