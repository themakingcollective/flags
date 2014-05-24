//
//  LayeredView.m
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "LayeredView.h"

@implementation LayeredView

- (void)setFlag:(NSString *)flagName
{
    NSArray *imageViews = [self imageViewsFor:flagName];
    
    for (UIImageView *view in imageViews) {
        [self addSubview:view];
        
    }
    
//    self.layer.borderColor = [UIColor redColor].CGColor;
//    self.layer.borderWidth = 3.0f;
    
    [self setNeedsDisplay];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"rendering view");
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSArray *)imageViewsFor:(NSString *)flagName
{
    NSMutableArray *imageViews = [[NSMutableArray alloc] init];
    
    for (UIImage *image in [self imagesFor:flagName]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        [imageView sizeToFit];
        [imageView setFrame:self.bounds];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageViews addObject:imageView];
    }
    
    return [NSArray arrayWithArray:imageViews];
}

- (NSArray *)imagesFor:(NSString *)flagName
{
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (NSString *path in [self pathsFor:flagName]) {
        [images addObject:[UIImage imageWithContentsOfFile:path]];
    }
    
    return [NSArray arrayWithArray:images];
}

- (NSArray *)pathsFor:(NSString *)flagName
{
    return [[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:flagName];
}

@end
