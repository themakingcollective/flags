//
//  LayeredView.m
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "LayeredView.h"
#import "Utils.h"

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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint viewPoint = [touch locationInView:self];
    CGPoint flagPoint = [self convertViewPoint:viewPoint];
    
    if (flagPoint.x == -1 || flagPoint.y == 1) return;
    
    
    [Utils getRGBAsFromImage:[self template].image atX:flagPoint.x andY:flagPoint.y];
    
}

- (CGPoint)convertViewPoint:(CGPoint)point
{
    CGPoint imageSize = [self imageSize];
    
    float xOffset = (self.bounds.size.width - imageSize.x) / 2;
    float yOffset = (self.bounds.size.height - imageSize.y) / 2;
    
    float pointX = roundf(point.x - xOffset);
    float pointY = roundf(point.y - yOffset);
    
    CGPoint imagePoint = CGPointMake(pointX, pointY);
    
    if ([self outOfBounds:imagePoint]) {
        return CGPointMake(-1, -1);
    }
    else {
        return imagePoint;
    }
}

- (CGPoint)imageSize
{
    UIImageView *t = [self template];
    
    float widthRatio = t.bounds.size.width / t.image.size.width;
    float heightRatio = t.bounds.size.height / t.image.size.height;
    float scale = MIN(widthRatio, heightRatio);
    float imageWidth = scale * t.image.size.width;
    float imageHeight = scale * t.image.size.height;
    
    return CGPointMake(imageWidth, imageHeight);
}

- (BOOL)outOfBounds:(CGPoint)point
{
    CGPoint s = [self imageSize];
    return (point.x < 0 || point.x > s.x || point.y < 0 || point.y > s.y);
}

- (UIImageView *)template
{
    return [[self subviews] firstObject];
}


@end
