//
//  PatternView.m
//  flags
//
//  Created by Chris Patuzzo on 12/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PatternView.h"

@interface PatternView ()

@end

@implementation PatternView

@synthesize flag=_flag;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)setFlagImage
{
    self.image = self.flag.patternImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchedPattern:self];
}

@end