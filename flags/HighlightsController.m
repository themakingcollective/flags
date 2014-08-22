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
      @"easy":          @"Green-Play-Again",
      @"hard":          @"Orange-Play-Again",
      @"image_to_name": @"Yellow-Play-Again",
      @"name_to_image": @"Purple-Play-Again"
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
        self.bestImage.hidden = YES;
        self.bestLabel.hidden = YES;
        self.bestView.layer.borderColor = [UIColor clearColor].CGColor;
        self.bestView.backgroundColor = [UIColor clearColor];
        
        UIColor *red = [UIColor colorWithRed:(196 / 255.0) green:(33 / 255.0) blue:(39 / 255.0) alpha:1.0f];
        [self.bestTitleLabel setTextColor:red];
        
        self.bestTitleLabel.text = @"You didn't do so great that round";
        self.bestSocialLabel.text = @"Why not take a look at the flags and have another go?";
        
        [self.bestSocialLabel setFrame:CGRectMake(20, 90, 240, 52)];
        [self.bestSocialLabel setNumberOfLines:2];
        [self.bestSocialLabel setFont:[UIFont fontWithName:@"BPreplay-Bold" size:17]];
        [self.bestSocialLabel sizeToFit];
        
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
        self.worstImage.hidden = YES;
        self.worstLabel.hidden = YES;
        self.worstView.layer.borderColor = [UIColor clearColor].CGColor;
        self.worstView.backgroundColor = [UIColor clearColor];
        
        UIColor *green = [UIColor colorWithRed:(73 / 255.0) green:(143 / 255.0) blue:(94 / 255.0) alpha:1.0f];
        [self.worstTitleLabel setTextColor:green];
        
        self.worstTitleLabel.text = @"You couldn't have done it better!";
        self.worstSocialLabel.text = @"Pat yourself on the back for doing an awesome job!";
        
        [self.worstSocialLabel setFrame:CGRectMake(20, 90, 240, 52)];
        [self.worstSocialLabel setNumberOfLines:2];
        [self.worstSocialLabel setFont:[UIFont fontWithName:@"BPreplay-Bold" size:17]];
        [self.worstSocialLabel sizeToFit];
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

@end