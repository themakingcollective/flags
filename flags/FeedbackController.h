//
//  FeedbackController.h
//  flags
//
//  Created by Chris Patuzzo on 19/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "LayeredView.h"
#import "Flag.h"
#import "Quiz.h"

@interface FeedbackController : BaseViewController

@property (nonatomic, assign) BOOL playerWasCorrect;
@property (nonatomic, strong) UIView *yourFlagView;
@property (nonatomic, strong) Flag *chosenFlag;
@property (nonatomic, strong) Flag *correctFlag;

@end
