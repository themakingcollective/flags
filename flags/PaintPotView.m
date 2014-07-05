//
//  PaintPotView.m
//  flags
//
//  Created by Chris Patuzzo on 21/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PaintPotView.h"
#import "Utils.h"

@interface PaintPotView () <UIGestureRecognizerDelegate>

@end

@implementation PaintPotView

@synthesize delegate=_delegate;

- (void)setHighlighted:(BOOL)state
{
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,2);
    self.layer.shadowRadius = 5.0f;
    self.layer.shadowOpacity = 1;
    
    if (state) {
        self.clipsToBounds = NO;
    }
    else {
        self.clipsToBounds = YES;
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addGestureRecognizer:[self tapGesture]];
        [self.layer setCornerRadius:3.0f];
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

- (void)setColor:(UIColor *)color
{
    [self setBackgroundColor:color];

    if ([Utils equalColors:color and:[UIColor whiteColor]]) {
        NSLog(@"setting border - todo");
    }
}

@end
