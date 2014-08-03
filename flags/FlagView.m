//
//  FlagView.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "FlagView.h"

@implementation FlagView

@synthesize flag=_flag;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)setImage
{
    [self setImage:[self.flag image]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate touchedFlagView:self];
}

@end
