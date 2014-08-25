//
//  FlagView.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "FlagView.h"
#import "Utils.h"

@interface FlagView ()

@property (nonatomic, assign) CGRect defaultFrame;

@end

@implementation FlagView

@synthesize flag=_flag;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.defaultFrame = self.frame;
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.cornerRadius = 3.0f;
        self.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}

- (void)setImage
{
    [self setImage:[self.flag image]];
    
    if ([[self.flag name] isEqualToString:@"Nepal"]) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchedFlagView:self];
}

- (void)correct
{
    self.layer.borderWidth = 5.0f;
    self.frame = CGRectInset(self.frame, -5, -5);
    self.layer.borderColor = [UIColor colorWithRed:(68 / 255.0) green:(187 / 255.0) blue:(137 / 255.0) alpha:1.0f].CGColor;
}

- (void)incorrect
{
    self.layer.borderWidth = 5.0f;
    self.frame = CGRectInset(self.frame, -5, -5);
    self.layer.borderColor = [UIColor colorWithRed:(194 / 255.0) green:(35 / 255.0) blue:(40 / 255.0) alpha:1.0f].CGColor;
}

- (void)reset
{
    self.frame = self.defaultFrame;
    self.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
    self.layer.borderWidth = 1.0f;
}

@end
