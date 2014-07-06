//
//  LayeredView.h
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flag.h"

@protocol LayeredViewDelegate <NSObject>

- (void)touchedLayeredView:layeredView;

@end

@interface LayeredView : UIView

@property (nonatomic, strong) id delegate;

- (void)setFlag:(Flag *)flag;
- (void)setPaintColor:(UIColor *)color;
- (BOOL)isCorrect;

@end
