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

@property (weak, nonatomic) IBOutlet UIImageView *rosette;

@property (weak, nonatomic) IBOutlet UILabel *maxScoreTitle;
@property (weak, nonatomic) IBOutlet UILabel *maxScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *minScoreTitle;
@property (weak, nonatomic) IBOutlet UILabel *minScoreLabel;

@property (strong, nonatomic) Flag *bestFlag;
@property (strong, nonatomic) Flag *worstFlag;

@end

@implementation HighlightsController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.bestFlag = [[ScoringService sharedInstance] bestFlag];
        self.worstFlag = [[ScoringService sharedInstance] worstFlag];
    }
    return self;
}

- (BOOL)shouldShow {
    return self.bestFlag || self.worstFlag;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViews];
    [self setPlayAgainImage];
    [self setBest];
    [self setWorst];
    [self setFonts];
    [self setImageBorders];
    [self setMinMaxPhrases];
    
    [self.bestTitleLabel sizeToFit];
    [self.worstTitleLabel sizeToFit];
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

- (void)setPlayAgainImage
{
    NSString *imageName = @{
        @"easy":          @"Play-Again-Green",
        @"hard":          @"Play-Again-Orange",
        @"image_to_name": @"Play-Again-Yellow",
        @"name_to_image": @"Play-Again-Purple"
    }[self.variant];
    
    [self.playAgainButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setBest
{
    if (self.bestFlag) {
        self.bestImage.image = [self.bestFlag image];
        self.bestLabel.text = [self.bestFlag name];
        self.bestSocialLabel.text = [self socialTextForFlag:self.bestFlag];
    }
    else {
        self.bestView.hidden = YES;
        self.minScoreTitle.hidden = NO;
        self.minScoreLabel.hidden = NO;
        
        self.rosette.hidden = YES;
    }
}

- (void)setWorst
{
    if (self.worstFlag) {
        self.worstImage.image = [self.worstFlag image];
        self.worstLabel.text = [self.worstFlag name];
        self.worstSocialLabel.text = [self socialTextForFlag:self.worstFlag];
    }
    else {
        self.worstView.hidden = YES;
        self.maxScoreTitle.hidden = NO;
        self.maxScoreLabel.hidden = NO;
    }
}

- (void)setFonts
{
    UIFont *titleFont = [UIFont fontWithName:@"BPreplay-Bold" size:25];
    [self.bestTitleLabel setFont:titleFont];
    [self.worstTitleLabel setFont:titleFont];
    [self.maxScoreTitle setFont:titleFont];
    [self.minScoreTitle setFont:titleFont];
    
    UIFont *labelFont = [UIFont fontWithName:@"BPreplay-Bold" size:20];
    [self.bestLabel setFont:labelFont];
    [self.worstLabel setFont:labelFont];
    
    UIFont *maxminFont = [UIFont fontWithName:@"BPreplay-Bold" size:16];
    [self.maxScoreLabel setFont:maxminFont];
    [self.minScoreLabel setFont:maxminFont];

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

- (NSString *)socialTextForFlag:(Flag *)flag
{
    return [[AggregatesService sharedInstance] textForFlag:flag
                                                   andMode:self.mode
                                             andVariant:self.variant
                                            andCorrectness:YES];
}

- (IBAction)playAgainTouched:(id)sender {
    [self playAgain];
}

- (void)setMinMaxPhrases
{
    NSArray *maxTitles = @[
        @"You couldn't have done it better!",
        @"A perfect score. That's really impressive!",
        @"You got every single answer right!",
        @"Wow, that was definitely your round!",
        @"You got everything right, yet again!",
    ];
    self.maxScoreTitle.text = [[Utils shuffle:maxTitles] firstObject];
    
    NSArray *maxLabels = @[
        @"Pat yourself on the back for doing an awesome job! You're a superstar.",
        @"There's no fooling you. Well done for getting everything right.",
        @"How on earth did you manage that? You must have been practicing."
    ];
    self.maxScoreLabel.text = [[Utils shuffle:maxLabels] firstObject];
    
    NSArray *minTitles = @[
        @"You didn't do so great that round",
        @"Hmm, that round didn't go so well",
        @"That was a bit of a tricky round",
        @"Don't worry, you'll get the hang of it soon",
        @"Oh well. There's always next time!"
    ];
    self.minScoreTitle.text = [[Utils shuffle:minTitles] firstObject];
    
    NSArray *minLabels = @[
        @"Why not take a look at the flags and have another go?",
        @"It might help to take a look through the different flags.",
        @"How about trying something else, or looking through some flags?"
    ];
    self.minScoreLabel.text = [[Utils shuffle:minLabels] firstObject];
}

@end