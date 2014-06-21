//
//  LayeredView.m
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "LayeredView.h"
#import "LayerView.h"
#import "Utils.h"

@interface LayeredView ()

@property (strong, nonatomic) UIColor *paintColor;

@end

@implementation LayeredView

@synthesize paintColor=_paintColor;

- (void)setFlag:(NSString *)flagName
{
    NSArray *layerViews = [self layerViewsFor:flagName];
    
    for (LayerView *view in layerViews) {
        [self addSubview:view];
    }
    
    [self setNeedsDisplay];
}

- (BOOL)isCorrect
{
    for (LayerView *layer in [self subviews]) {
        
        if (![layer isCorrect]) {
            return NO;
        }
    }
    
    return YES;
}

- (NSArray *)layerViewsFor:(NSString *)flagName
{
    NSMutableArray *layerViews = [[NSMutableArray alloc] init];
    
    for (NSString *path in [Utils pathsFor:flagName]) {
        LayerView *layerView = [[LayerView alloc] initWithPath:path];
        
        [layerView sizeToFit];
        [layerView setFrame:self.bounds];
        [layerView setContentMode:UIViewContentModeScaleAspectFit];
        
        [layerViews addObject:layerView];
    }
    
    return [NSArray arrayWithArray:layerViews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.paintColor == nil) return;
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint viewPoint = [touch locationInView:self];
    
    CGPoint subviewPoint = [self subviewPoint:viewPoint];
    if (subviewPoint.x == -1 || subviewPoint.y == 1) return;

    CGPoint imagePoint = [self imagePoint:subviewPoint];
    LayerView *touchedSubview = [self touchedSubview:imagePoint];
    
    if ([touchedSubview isEqual:[self template]]) return;
    
    [touchedSubview setColor:self.paintColor];
}

- (LayerView *)touchedSubview:(CGPoint)point
{
    LayerView *touchedView;
    
    for (LayerView *layerView in [self.subviews reverseObjectEnumerator]) {
        UIColor *color = [Utils getRGBAsFromImage:layerView.image atX:point.x andY:point.y];
        CGFloat red, green, blue, alpha;
        [color getRed: &red green: &green blue: &blue alpha: &alpha];

        if (alpha != 0) {
            touchedView = layerView;
            break;
        }
    }
    
    return touchedView;
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
    
    if ([self outOfSubviewBounds:subviewPoint]) {
        return CGPointMake(-1, -1);
    }
    else {
        return subviewPoint;
    }
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
