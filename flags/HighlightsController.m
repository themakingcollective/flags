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
#import "Utils.h"

@interface HighlightsController ()

@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;

@property (weak, nonatomic) IBOutlet UIView *bestView;
@property (weak, nonatomic) IBOutlet UILabel *bestTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bestImage;
@property (weak, nonatomic) IBOutlet UILabel *bestLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestSocialLabel;

@property (weak, nonatomic) IBOutlet UIView *worstView;
@property (weak, nonatomic) IBOutlet UILabel *worstTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *worstImage;
@property (weak, nonatomic) IBOutlet UILabel *worstLabel;
@property (weak, nonatomic) IBOutlet UILabel *worstSocialLabel;

@property (strong, nonatomic) Flag *bestFlag;
@property (strong, nonatomic) Flag *worstFlag;

@end

@implementation HighlightsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bestFlag = [[ScoringService sharedInstance] bestFlag];
    self.worstFlag = [[ScoringService sharedInstance] worstFlag];

    [self setViews];
    [self setPlayAgain];
    [self setBest];
    [self setWorst];
    [self setFonts];
    [self setImageBorders];
}

- (void)viewDidLayoutSubviews
{
    if (self.bestFlag) {
        [Utils resizeFrameToFitImage:self.bestImage];
    }
    
    if (self.worstFlag) {
        [Utils resizeFrameToFitImage:self.worstImage];
    }
    
    [super viewDidLayoutSubviews];
}

- (void)setViews
{
    self.bestView.backgroundColor = [UIColor whiteColor];
    self.bestView.layer.borderColor = [UIColor colorWithRed:(73 / 255.0) green:(143 / 255.0) blue:(94 / 255.0) alpha:1.0f].CGColor;
    self.bestView.layer.cornerRadius = 8.0f;
    self.bestView.layer.borderWidth = 3.0f;
    
    self.worstView.backgroundColor = [UIColor whiteColor];
    self.worstView.layer.borderColor = [UIColor colorWithRed:(196 / 255.0) green:(33 / 255.0) blue:(39 / 255.0) alpha:1.0f].CGColor;
    self.worstView.layer.cornerRadius = 8.0f;
    self.worstView.layer.borderWidth = 3.0f;
}

- (void)setPlayAgain
{
    NSString *imageName = [self.variant isEqualToString:@"easy"] ? @"Easy-Play-Again" : @"Hard-Play-Again";
    [self.playAgainButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setBest
{
    if (self.bestFlag) {
        self.bestImage.image = [self.bestFlag image];
        self.bestLabel.text = [self.bestFlag name];
        self.bestSocialLabel.text = [self socialTextForFlag:self.bestFlag andCorrectness:NO];
    }
    else {
        self.bestView.hidden = YES;
        // move elements
    }
}

- (void)setWorst
{
    if (self.worstFlag) {
        self.worstImage.image = [self.worstFlag image];
        self.worstLabel.text = [self.worstFlag name];
        self.worstSocialLabel.text = [self socialTextForFlag:self.worstFlag andCorrectness:YES];
    }
    else {
        self.worstView.hidden = YES;
        // move elements
    }
}

- (void)setFonts
{
    UIFont *titleFont = [UIFont fontWithName:@"BPreplay-Bold" size:25];
    [self.bestTitleLabel setFont:titleFont];
    [self.worstTitleLabel setFont:titleFont];
    
    UIFont *labelFont = [UIFont fontWithName:@"BPreplay-Bold" size:20];
    [self.bestLabel setFont:labelFont];
    [self.worstLabel setFont:labelFont];

    UIColor *socialColor = [UIColor colorWithRed:(26 / 255.0) green:(97 / 255.0) blue:(139 / 255.0) alpha:1.0f];
    self.bestSocialLabel.textColor = socialColor;
    self.worstSocialLabel.textColor = socialColor;
    
    UIColor *labelColor = [UIColor colorWithRed:(50 / 255.0) green:(50 / 255.0) blue:(50 / 255.0) alpha:1.0f];
    self.bestLabel.textColor = labelColor;
    self.worstLabel.textColor = labelColor;
}

- (void)setImageBorders {
    [self.bestImage setContentMode:UIViewContentModeScaleAspectFit];
    self.bestImage.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
    self.bestImage.layer.borderWidth = 1.0f;
    [self.bestImage.layer setCornerRadius:3.0f];
    
    [self.worstImage setContentMode:UIViewContentModeScaleAspectFit];
    self.worstImage.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
    self.worstImage.layer.borderWidth = 1.0f;
    [self.worstImage.layer setCornerRadius:3.0f];
}

- (NSString *)socialTextForFlag:(Flag *)flag andCorrectness:(BOOL)correct
{
    return [[AggregatesService sharedInstance] textForFlag:flag
                                                   andMode:self.mode
                                             andVariant:self.variant
                                            andCorrectness:correct];
}

@end