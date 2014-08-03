//
//  HighlightsController.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "HighlightsController.h"
#import "Flag.h"
#import "AggregatesService.h"
#import "ScoringService.h"

@interface HighlightsController ()

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;

@property (weak, nonatomic) IBOutlet UIView *bestView;
@property (weak, nonatomic) IBOutlet UIImageView *bestImage;
@property (weak, nonatomic) IBOutlet UILabel *bestLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestSocialLabel;

@property (weak, nonatomic) IBOutlet UIView *worstView;
@property (weak, nonatomic) IBOutlet UIImageView *worstImage;
@property (weak, nonatomic) IBOutlet UILabel *worstLabel;
@property (weak, nonatomic) IBOutlet UILabel *worstSocialLabel;

@end

@implementation HighlightsController

@synthesize mode=_mode;
@synthesize difficulty=_difficulty;

- (void)viewDidLoad
{
    NSString *imageName = [self.difficulty isEqualToString:@"easy"] ? @"Easy-Play-Again" : @"Hard-Play-Again";
    [self.playAgainButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [self setBestFlag];
    [self setWorstFlag];
    
    [super viewDidLoad];
}

- (void)setBestFlag
{
    Flag *bestFlag = [[ScoringService sharedInstance] bestFlag];
    
    if (bestFlag) {
        self.bestImage.image = [bestFlag image];
        self.bestLabel.text = [bestFlag name];
        self.bestSocialLabel.text = [self socialTextForFlag:bestFlag andCorrectness:NO];
    }
    else {
        self.bestView.hidden = YES;
        // move elements
    }
}

- (void)setWorstFlag
{
    Flag *worstFlag = [[ScoringService sharedInstance] worstFlag];
    
    if (worstFlag) {
        self.worstImage.image = [worstFlag image];
        self.worstLabel.text = [worstFlag name];
        self.worstSocialLabel.text = [self socialTextForFlag:worstFlag andCorrectness:YES];
    }
    else {
        self.worstView.hidden = YES;
        // move elements
    }
}

- (NSString *)socialTextForFlag:(Flag *)flag andCorrectness:(BOOL)correct
{
    return [[AggregatesService sharedInstance] textForFlag:flag
                                                   andMode:self.mode
                                             andDifficulty:self.difficulty
                                            andCorrectness:correct];
}

@end