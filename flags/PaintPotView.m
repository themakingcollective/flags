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

- (void)setHighlighted:(BOOL)state
{
    if (state) {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 3.0f;
    }
    else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;
    }
}

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
    [self.delegate touchedPaintPot:self];
}

- (UITapGestureRecognizer *)tapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    
    [tap setDelegate:self];
    [tap setNumberOfTapsRequired:1];
    
    return tap;
}

@end
