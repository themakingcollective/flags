//
//  PatternView.m
//  flags
//
//  Created by Chris Patuzzo on 12/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PatternView.h"

@interface PatternView ()

@property (nonatomic, strong) UIImageView *highlightView;

@end

@implementation PatternView

@synthesize flag=_flag;

- (void)setHighlighted:(BOOL)state
{
    self.highlightView.hidden = !state;
}

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

- (void)setupHighlights
{
    self.clipsToBounds = NO;
    
    [self setupHighlightView];
    [self addSubview:self.highlightView];
    
    self.highlightView.hidden = YES;
}

- (void)setupHighlightView
{
    NSString *imageName = @"Highlight-64x44";
    UIImage *highlightImage = [UIImage imageNamed:imageName];
    UIImageView *highlightView = [[UIImageView alloc] initWithImage:highlightImage];
    [highlightView setFrame:CGRectOffset(highlightView.frame, -2, -2)];
    self.highlightView = highlightView;
}

@end