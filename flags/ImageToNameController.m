//
//  ImageToNameController.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "ImageToNameController.h"
#import "Quiz.h"
#import "DifficultyScaler.h"
#import "Flag.h"
#import "ScoringService.h"
#import "HighlightsController.h"
#import "EventRecorder.h"
#import "Utils.h"

@interface ImageToNameController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *aButton;
@property (weak, nonatomic) IBOutlet UIButton *bButton;
@property (weak, nonatomic) IBOutlet UIButton *cButton;
@property (weak, nonatomic) IBOutlet UIButton *dButton;

@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, strong) DifficultyScaler *difficultyScaler;
@property (nonatomic, strong) NSArray *choices;

@end

@implementation ImageToNameController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.variant = @"image_to_name";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.imageView.layer.borderWidth = 2.0f;
    [self.imageView.layer setCornerRadius:5.0f];
    
    self.difficultyScaler = [[DifficultyScaler alloc] initWithDifficultyKey:@"image-to-name-quiz"];
    
    NSArray *flags = [self.difficultyScaler scale:[Flag all]];
    self.quiz = [[Quiz alloc] initWithArray:flags andRounds:10];
    
    [[ScoringService sharedInstance] reset];
    [self nextFlag:nil];
}

- (void)viewDidLayoutSubviews
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView setAnimationsEnabled:NO];
}

- (void)returnToMenu:(UIButton *)menuButton
{
    [UIView setAnimationsEnabled:YES];
    [super returnToMenu:menuButton];
}

- (void)nextFlag:(NSTimer *)timer
{
    [self.view setUserInteractionEnabled:YES];
    Flag *flag = [self.quiz currentElement];
    
    if (flag) {
        self.imageView.image = [flag image];
        [self updateBorders];
        self.choices = [self.quiz choices:4];
        [self updateButtons];
    }
    else {
        [UIView setAnimationsEnabled:YES];
        [self highlights];
    }
}

- (void)updateButtons
{
    UIImage *image = [UIImage imageNamed:@"Quiz-Answer"];
    
    Flag *aFlag = [self.choices objectAtIndex:0];
    [self.aButton setTitle:[aFlag name] forState:UIControlStateNormal];
    [self.aButton setBackgroundImage:image forState:UIControlStateNormal];
    
    Flag *bFlag = [self.choices objectAtIndex:1];
    [self.bButton setTitle:[bFlag name] forState:UIControlStateNormal];
    [self.bButton setBackgroundImage:image forState:UIControlStateNormal];
    
    Flag *cFlag = [self.choices objectAtIndex:2];
    [self.cButton setTitle:[cFlag name] forState:UIControlStateNormal];
    [self.cButton setBackgroundImage:image forState:UIControlStateNormal];
    
    Flag *dFlag = [self.choices objectAtIndex:3];
    [self.dButton setTitle:[dFlag name] forState:UIControlStateNormal];
    [self.dButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)submit:(UIButton *)button
{
    NSString *flagName = button.titleLabel.text;
    Flag *flag = [Flag find_by_name:flagName];
    float delay;
    
    if ([flag isEqualTo:[self.quiz currentElement]]) {
        [self recordEvent:YES flag:flag];
        [[ScoringService sharedInstance] correctForFlag:flag andMode:@"quiz" andVariant:self.variant];
        [button setBackgroundImage:[UIImage imageNamed:@"Quiz-Answer-Correct"] forState:UIControlStateNormal];
        delay = 0.5f;
    }
    else {
        [self recordEvent:NO flag:flag];
        [[ScoringService sharedInstance] incorrectForFlag:flag andMode:@"quiz" andVariant:self.variant];
        [button setBackgroundImage:[UIImage imageNamed:@"Quiz-Answer-Incorrect"] forState:UIControlStateNormal];
        [[self correctButton] setBackgroundImage:[UIImage imageNamed:@"Quiz-Answer-Outlined"] forState:UIControlStateNormal];
        delay = 1;
    }
    
    [self.quiz nextRound];
    [self.view setUserInteractionEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(nextFlag:) userInfo:nil repeats:NO];
}

- (UIButton *)correctButton
{
    NSString *answer = [[self.quiz currentElement] name];
    
    if ([answer isEqualToString:self.aButton.titleLabel.text]) {
        return self.aButton;
    }
    if ([answer isEqualToString:self.bButton.titleLabel.text]) {
        return self.bButton;
    }
    if ([answer isEqualToString:self.cButton.titleLabel.text]) {
        return self.cButton;
    }
    if ([answer isEqualToString:self.dButton.titleLabel.text]) {
        return self.dButton;
    }
    return nil;
}

- (void)highlights
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HighlightsController *highlights = [storyboard instantiateViewControllerWithIdentifier:@"HighlightsController"];
    
    highlights.mode = self.mode;
    highlights.variant = self.variant;
    
    [self.navigationController pushViewController:highlights animated:YES];
}

- (void)recordEvent:(BOOL)playerWasCorrect flag:(Flag *)flag
{
    [[EventRecorder sharedInstance] record:@{
         @"flag_name": [flag name],
         @"mode": self.mode,
         @"variant": self.variant,
         @"correct": playerWasCorrect ? @"true" : @"false"
    }];
}

- (void)updateBorders
{
    [self.imageView setFrame:CGRectMake(35, 20, 250, 173)];
    [Utils resizeFrameToFitImage:self.imageView];
}

@end
