//
//  PaintPotView.m
//  flags
//
//  Created by Chris Patuzzo on 21/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PaintPotView.h"

@interface PaintPotView () <UIGestureRecognizerDelegate>

@end

@implementation PaintPotView

@synthesize delegate=_delegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addGestureRecognizer:[self tapGesture]];
    }
    return self;
}

- (void)onTap
{
    [self.delegate touchedPaintPot:[self backgroundColor]];
}

- (UITapGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    [tap setDelegate:self];
    [tap setNumberOfTapsRequired:1];
    
    return tap;
}

@end
