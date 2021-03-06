//
//  FeedbackController.m
//  flags
//
//  Created by Chris Patuzzo on 19/07/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "FeedbackController.h"
#import "PuzzleController.h"
#import "Utils.h"
#import "ResultsController.h"
#import "AggregatesService.h"

@interface FeedbackController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *correctFlagView;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation FeedbackController

@synthesize playerWasCorrect=_playerWasCorrect;
@synthesize yourFlagView=_yourFlagView;
@synthesize chosenFlag=_chosenFlag;
@synthesize correctFlag=_correctFlag;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self puzzleController].navigationItem.title;
    
    UIColor *green = [UIColor colorWithRed:(73 / 255.0f) green:(142 / 255.0f) blue:(93 / 255.0f) alpha:1.0f];
    UIColor *red = [UIColor colorWithRed:(194 / 255.0f) green:(32 / 255.0f) blue:(38 / 255.0f) alpha:1.0f];
    
    UIColor *color = self.playerWasCorrect ? green : red;
    UIFont *titleFont = [UIFont fontWithName:@"BPreplay-Bold" size:30];
    UIFont *nameFont = [UIFont fontWithName:@"BPreplay" size:16];
    
    [self.titleLabel setTextColor:color];
    [self.titleLabel setFont:titleFont];
    [self.socialLabel setTextColor:color];
    [self.flagLabel setFont:nameFont];
    [self.yoursLabel setFont:nameFont];
    
    NSArray *phrases = self.playerWasCorrect ? [self goodPhrases] : [self badPhrases];
    phrases = [Utils shuffle:phrases];
    self.titleLabel.text = [phrases firstObject];
    
    if (self.playerWasCorrect) {
        self.yourFlagView = [[UIImageView alloc] initWithImage:[self.correctFlag image]];
        [self.yourFlagView setContentMode:UIViewContentModeScaleAspectFit];
        self.yourFlagView.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
        self.yourFlagView.layer.borderWidth = 1.0f;
        [self.yourFlagView.layer setCornerRadius:3.0f];
    }
    
    [self.view addSubview:self.yourFlagView];
    
    [self.correctFlagView setImage:[self.correctFlag image]];
    [self.correctFlagView setContentMode:UIViewContentModeScaleAspectFit];
    self.correctFlagView.layer.borderColor = [Utils colorWithHexString:@"777779"].CGColor;
    self.correctFlagView.layer.borderWidth = 1.0f;
    [self.correctFlagView.layer setCornerRadius:3.0f];

    NSString *flagName = [self.correctFlag name];
    flagName = [flagName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    self.flagLabel.text = [NSString stringWithFormat:@"%@:", flagName];
    
    NSString *imageName = [self.variant isEqualToString:@"easy"] ? @"Next-Button-Easy-Enabled" : @"Next-Button-Hard-Enabled";
    [self.nextButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [self setSocialText];
    
    if (!self.playerWasCorrect) {
        self.iconView.image = [UIImage imageNamed:@"Transparent-Cross"];
    }
}

- (void)viewDidLayoutSubviews
{
    [self.yourFlagView setFrame:CGRectMake(20, 106, 130, 90)];
    [Utils resizeFrameToFitImage:self.correctFlagView];
    
    if ([self.yourFlagView isKindOfClass:[UIImageView class]]) {
        [Utils resizeFrameToFitImage:(UIImageView *)self.yourFlagView];
    }
    
    [self removeBordersIfNepal];
    
    [super viewDidLayoutSubviews];
}

- (IBAction)dismiss:(id)sender {
    if ([[self puzzleController] nextFlag]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else {
        [self showResults];
    }
}

- (PuzzleController *)puzzleController
{
    NSInteger previousIndex = [self.navigationController.viewControllers count] - 2;
    UIViewController *previousController = [self.navigationController.viewControllers objectAtIndex:previousIndex];
    return (PuzzleController *)previousController;
}

- (void)showResults
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ResultsController *results = [storyboard instantiateViewControllerWithIdentifier:@"ResultsController"];
    results.variant = self.variant;
    results.mode = self.mode;
    results.variant = self.variant;
    
    [self.navigationController pushViewController:results animated:YES];
}

- (void)removeBordersIfNepal
{
    if ([[self.chosenFlag name] isEqualToString:@"Nepal"]) {
        if ([self.yourFlagView isKindOfClass:[LayeredView class]]) {
            [(LayeredView *)self.yourFlagView removeBorders];
        }
        else {
            self.yourFlagView.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    
    if ([[self.correctFlag name] isEqualToString:@"Nepal"]) {
        self.correctFlagView.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)setSocialText
{
    UIFont *normal = [UIFont fontWithName:@"BPreplay" size:17];
    UIFont *bold = [UIFont fontWithName:@"BPreplay-Bold" size:17];
    
    NSString *socialText = [[AggregatesService sharedInstance] textForFlag:self.correctFlag andMode:@"puzzle" andVariant:self.variant andCorrectness:YES];
    
    if ([socialText isEqualToString:@""]) {
        return;
    }
    
    NSRange range = NSMakeRange(0, [socialText rangeOfString:@"%"].location + 1);
    NSString *percentage = [socialText substringWithRange:range];
    
    self.socialLabel.font = normal;
    self.socialLabel.attributedText = [Utils style:socialText with:@{
         @"right":bold,
         percentage:bold
    }];
}

- (NSArray *)goodPhrases
{
    return @[
        @"Good job!",
        @"Awesome!",
        @"Nice one!",
        @"You're a pro!",
        @"Way to go!"
    ];
}

- (NSArray *)badPhrases
{
    return @[
        @"Bad luck!",
        @"Not quite",
        @"Nice try",
        @"That's not right",
        @"Nuh-uh"
    ];
}

@end
