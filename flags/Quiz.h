//
//  Quiz.h
//  flags
//
//  Created by Chris Patuzzo on 22/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quiz : NSObject

@property (nonatomic, assign) NSInteger correctCount;
@property (nonatomic, assign) NSInteger incorrectCount;

- (id)initWithArray:(NSArray *)array andRounds:(NSInteger)rounds;
- (id)currentElement;
- (void)nextRound;
- (NSArray *)choices:(NSInteger)numberOfChoices;

@end
