//
//  Quiz.h
//  flags
//
//  Created by Chris Patuzzo on 22/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quiz : NSObject

- (id)initWithArray:(NSArray *)array andRounds:(NSInteger)rounds;
- (id)currentElement;
- (void)correct;
- (void)incorrect;

@end
