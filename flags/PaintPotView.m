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

@property (nonatomic, strong) UIImageView *highlightView;

@end

@implementation PaintPotView

@synthesize delegate=_delegate;

- (void)setHighlighted:(BOOL)state
{
    self.highlightView.hidden = !state;
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

- (void)setupHighlights
{
    self.clipsToBounds = NO;
    
    [self setupHighlightView];
    [self addSubview:self.highlightView];

    self.highlightView.hidden = YES;
}

- (void)setupHighlightView
{
    NSString *imageName;
    if (self.frame.size.height == 41) {
        imageName = @"Highlight-45x45";
    }
    else if (self.frame.size.height == 33) {
        imageName = @"Highlight-45x37";
    }
    
    UIImage *highlightImage = [UIImage imageNamed:imageName];
    highlightImage = [UIImage imageWithCGImage:highlightImage.CGImage scale:2 orientation:highlightImage.imageOrientation];
    UIImageView *highlightView = [[UIImageView alloc] initWithImage:highlightImage];
    [highlightView setFrame:CGRectOffset(highlightView.frame, -2, -2)];
    self.highlightView = highlightView;
}

@end
