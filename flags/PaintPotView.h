//
//  PaintPotView.h
//  flags
//
//  Created by Chris Patuzzo on 21/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaintPotViewDelegate <NSObject>

- (void)touchedPaintPot:(UIColor *)color;

@end

@interface PaintPotView : UIView

@property (weak, nonatomic) id delegate;

@end
