//
//  PaintPotView.m
//  flags
//
//  Created by Chris Patuzzo on 21/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PaintPotView.h"
#import "Utils.h"

@interface PaintPotView ()

@end

@implementation PaintPotView

@synthesize delegate=_delegate;

- (void)setHighlighted:(BOOL)state
{
    self.layer.shadowColor = [UIColor colorWithRed:(16 / 255.0) green:(234 / 255.0) blue:(238 / 255.0) alpha:1.0f].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
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
        [self.layer setCornerRadius:3.0f];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchedPaintPot:self];
}

- (void)setColor:(UIColor *)color
{
    [self setBackgroundColor:color];

    if ([Utils equalColors:color and:[UIColor whiteColor]]) {
        self.layer.borderColor = [Utils colorWithHexString:@"d1d2d4"].CGColor;
        self.layer.borderWidth = 2.0f;
    }
    else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
