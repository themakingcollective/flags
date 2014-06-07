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
    CGPoint subviewPoint = [self subviewPoint:viewPoint];
    
    if (subviewPoint.x == -1 || subviewPoint.y == 1) return;

    CGPoint imagePoint = [self imagePoint:subviewPoint];
    
    NSLog(@"%f, %f", imagePoint.x, imagePoint.y);
    
    
    //[Utils getRGBAsFromImage:[self template].image atX:flagPoint.x andY:flagPoint.y];
    
}

- (CGPoint)subviewPoint:(CGPoint)point
{
    CGPoint subviewSize = [self subviewSize];
    CGPoint viewSize = [self viewSize];
    
    float xOffset = (viewSize.x - subviewSize.x) / 2;
    float yOffset = (viewSize.y - subviewSize.y) / 2;
    
    float pointX = roundf(point.x - xOffset);
    float pointY = roundf(point.y - yOffset);
    
    CGPoint subviewPoint = CGPointMake(pointX, pointY);
    
//    if ([self outOfSubviewBounds:subviewPoint]) {
//        return CGPointMake(-1, -1);
//    }
//    else {
        return subviewPoint;
//    }
}

- (CGPoint)imagePoint:(CGPoint)point
{
    CGPoint subviewSize = [self subviewSize];
    CGPoint imageSize = [self imageSize];
    
    float xRatio = imageSize.x / subviewSize.x;
    float yRatio = imageSize.y / subviewSize.y;
    
    float imageX = point.x * xRatio;
    float imageY = point.y * yRatio;
    
    return CGPointMake(imageX, imageY);
}

- (CGPoint)viewSize
{
    float viewWidth = self.bounds.size.width;
    float viewHeight = self.bounds.size.height;
    
    return CGPointMake(viewWidth, viewHeight);
}

- (CGPoint)subviewSize
{
    UIImageView *t = [self template];
    float widthRatio = t.bounds.size.width / t.image.size.width;
    float heightRatio = t.bounds.size.height / t.image.size.height;
    
    float scale = MIN(widthRatio, heightRatio);
    
    CGPoint imageSize = [self imageSize];
    float imageWidth = scale * imageSize.x;
    float imageHeight = scale * imageSize.y;
    
    return CGPointMake(imageWidth, imageHeight);
}

- (CGPoint)imageSize
{
    UIImageView *t = [self template];
    
    float imageWidth = t.image.size.width;
    float imageHeight = t.image.size.height;
    
    return CGPointMake(imageWidth, imageHeight);
}

- (BOOL)outOfSubviewBounds:(CGPoint)point
{
    CGPoint s = [self subviewSize];
    return (point.x < 0 || point.x > s.x || point.y < 0 || point.y > s.y);
}

- (UIImageView *)template
{
    return [[self subviews] firstObject];
}


@end
