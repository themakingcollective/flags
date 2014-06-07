//
//  LayerView.h
//  flags
//
//  Created by Chris Patuzzo on 07/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayerView : UIImageView

- (id)initWithPath:(NSString *)path;
- (void)setColor:(UIColor *)color;
- (BOOL)isCorrect;

@end
