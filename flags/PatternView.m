//
//  PatternView.m
//  flags
//
//  Created by Chris Patuzzo on 12/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PatternView.h"

@interface PatternView () <UIGestureRecognizerDelegate>

@end

@implementation PatternView

@synthesize flag=_flag;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addGestureRecognizer:[self tapGesture]];
        [self.layer setCornerRadius:3.0f];
    }
    return self;
}

- (void)setFlagImage
{
    self.image = self.flag.patternImage;
}

- (void)onTap
{
    [self.delegate touchedPattern:self];
}

- (UITapGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    [tap setDelegate:self];
    [tap setNumberOfTapsRequired:1];
    
    return tap;
}

@end