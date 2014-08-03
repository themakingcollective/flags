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

@interface HighlightsController ()

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;

@property (weak, nonatomic) IBOutlet UIImageView *bestImage;
@property (weak, nonatomic) IBOutlet UILabel *bestLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestSocialLabel;

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
    
    [self setBestFlag:[[Flag all] firstObject]];
    [self setWorstFlag:[[Flag all] firstObject]];
    
    [super viewDidLoad];
}

- (void)setBestFlag:(Flag *)flag
{
    self.bestImage.image = [flag image];
    self.bestLabel.text = [flag name];
    self.bestSocialLabel.text = [self socialTextForFlag:flag andCorrectness:NO];
}

- (void)setWorstFlag:(Flag *)flag
{
    self.worstImage.image = [flag image];
    self.worstLabel.text = [flag name];
    self.worstSocialLabel.text = [self socialTextForFlag:flag andCorrectness:YES];
}

- (NSString *)socialTextForFlag:(Flag *)flag andCorrectness:(BOOL)correct
{
    return [[AggregatesService sharedInstance] textForFlag:flag
                                                   andMode:self.mode
                                             andDifficulty:self.difficulty
                                            andCorrectness:correct];
}

@end