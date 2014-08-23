//
//  ResultsController.m
//  flags
//
//  Created by Chris Patuzzo on 22/06/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ResultsController.h"
#import "HighlightsController.h"
#import "ScoringService.h"

@interface ResultsController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *playAgainButton;
@property (weak, nonatomic) IBOutlet UIImageView *rosetteImageView;

@property (strong, nonatomic) HighlightsController *highlightsController;

@end

@implementation ResultsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle];
    [self setRosetteImage];
    [self setRosetteFont];
    [self setPlayAgainImage];
    
    NSInteger total = [[ScoringService sharedInstance] roundsCount];
    
    UIFont *font = [UIFont fontWithName:@"Pacifico" size:60];
    [self.scoreLabel setFont:font];
    [self.totalLabel setFont:font];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", [ScoringService sharedInstance].correctCount];
    self.totalLabel.text = [NSString stringWithFormat:@"%d", total];
    
    if ([[ScoringService sharedInstance] correctCount] >= 10) {
        [self.scoreLabel setFrame:CGRectOffset(self.scoreLabel.frame, -7, 0)];
    }
    
    [self showHighlightsIfApplicable];
}

- (void)showHighlights:(id)sender
{
    [self.navigationController pushViewController:self.highlightsController animated:YES];
}

- (void)showHighlightsIfApplicable
{
    self.highlightsController = [self highlightsController];
    
    if ([self.highlightsController shouldShow]) {
        [self.playAgainButton setHidden:YES];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showHighlights:) userInfo:nil repeats:NO];
    }
}

- (void)setTitle
{
    NSString *title = @{
      @"easy":          @"colours",
      @"hard":          @"patterns + colours",
      @"image_to_name": @"which country?",
      @"name_to_image": @"which flag?"
    }[self.variant];
    
    self.navigationItem.title = title;
}

- (void)setRosetteImage
{
    NSString *imageName = @{
      @"easy":          @"Green-Results-Rosette",
      @"hard":          @"Orange-Results-Rosette",
      @"image_to_name": @"Yellow-Results-Rosette",
      @"name_to_image": @"Purple-Results-Rosette"
    }[self.variant];
    
    [self.rosetteImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)setRosetteFont
{
    NSArray *rgb = @{
      @"easy":          @[@207, @62,  @96],
      @"hard":          @[@20,  @96,  @137],
      @"image_to_name": @[@208, @61,  @97],
      @"name_to_image": @[@237, @102, @65]
    }[self.variant];
    
    UIColor *color = [UIColor colorWithRed:([rgb[0] floatValue] / 255) green:([rgb[1] floatValue] / 255) blue:([rgb[2] floatValue] / 255) alpha:1.0f];
    
    self.scoreLabel.textColor = color;
    self.totalLabel.textColor = color;
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

- (IBAction)playAgainTouched:(id)sender {
    [self playAgain];
}

- (HighlightsController *)highlightsController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HighlightsController *highlights = [storyboard instantiateViewControllerWithIdentifier:@"HighlightsController"];
    
    highlights.mode = self.mode;
    highlights.variant = self.variant;
    
    return highlights;
}

@end
