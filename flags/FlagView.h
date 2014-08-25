//
//  FlagView.h
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flag.h"

@protocol FlagViewDelegate <NSObject>

- (void)touchedFlagView:(id)flagView;

@end

@interface FlagView : UIImageView

@property (strong, nonatomic) Flag *flag;
@property (weak, nonatomic) id delegate;

- (void)setImage;
- (void)correct;
- (void)incorrect;
- (void)reset;

@end
