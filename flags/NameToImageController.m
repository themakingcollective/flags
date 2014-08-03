//
//  NameToImageController.m
//  flags
//
//  Created by Chris Patuzzo on 03/08/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "NameToImageController.h"
#import "FlagView.h"
#import "Quiz.h"
#import "DifficultyScaler.h"
#import "Flag.h"
#import "ScoringService.h"
#import "HighlightsController.h"
#import "EventRecorder.h"

@interface NameToImageController () <FlagViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet FlagView *aFlagView;
@property (weak, nonatomic) IBOutlet FlagView *bFlagView;
@property (weak, nonatomic) IBOutlet FlagView *cFlagView;
@property (weak, nonatomic) IBOutlet FlagView *dFlagView;

@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, strong) DifficultyScaler *difficultyScaler;
@property (nonatomic, strong) NSArray *choices;

@end

@implementation NameToImageController

- (void)viewDidLoad
{
    self.difficultyScaler = [[DifficultyScaler alloc] initWithDifficultyKey:@"name-to-image-quiz"];
    
    NSArray *flags = [self.difficultyScaler scale:[Flag all]];
    self.quiz = [[Quiz alloc] initWithArray:flags andRounds:10];
    
    [[ScoringService sharedInstance] reset];
    [self nextFlag:nil];
    
    [self.aFlagView setDelegate:self];
    [self.bFlagView setDelegate:self];
    [self.cFlagView setDelegate:self];
    [self.dFlagView setDelegate:self];
    
    self.aFlagView.layer.borderWidth = 3.0f;
    self.bFlagView.layer.borderWidth = 3.0f;
    self.cFlagView.layer.borderWidth = 3.0f;
    self.dFlagView.layer.borderWidth = 3.0f;
    
    [super viewDidLoad];
}

- (void)nextFlag:(NSTimer *)timer
{
    [self.view setUserInteractionEnabled:YES];
    Flag *flag = [self.quiz currentElement];
    
    if (flag) {
        self.label.text = [flag name];
        self.choices = [self.quiz choices:4];
        [self updateFlagViews];
    }
    else {
        [self highlights];
    }
}

- (void)updateFlagViews
{
    UIColor *blue = [UIColor colorWithRed:(110 / 255.0) green:(149 / 255.0) blue:(233 / 255.0) alpha:1.0f];
    
    Flag *aFlag = [self.choices objectAtIndex:0];
    self.aFlagView.flag = aFlag; [self.aFlagView setImage];
    self.aFlagView.layer.borderColor = blue.CGColor;
    
    Flag *bFlag = [self.choices objectAtIndex:1];
    self.bFlagView.flag = bFlag; [self.bFlagView setImage];
    self.bFlagView.layer.borderColor = blue.CGColor;
    
    Flag *cFlag = [self.choices objectAtIndex:2];
    self.cFlagView.flag = cFlag; [self.cFlagView setImage];
    self.cFlagView.layer.borderColor = blue.CGColor;
    
    Flag *dFlag = [self.choices objectAtIndex:3];
    self.dFlagView.flag = dFlag; [self.dFlagView setImage];
    self.dFlagView.layer.borderColor = blue.CGColor;
}

- (void)touchedFlagView:(FlagView *)flagView;
{
    Flag *flag = [flagView flag];
    
    if ([flag isEqualTo:[self.quiz currentElement]]) {
        [self recordEvent:YES flag:flag];
        [[ScoringService sharedInstance] correctForFlag:flag andMode:@"quiz" andVariant:@"name_to_image"];
        flagView.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else {
        [self recordEvent:NO flag:flag];
        [[ScoringService sharedInstance] incorrectForFlag:flag andMode:@"quiz" andVariant:@"name_to_image"];
        flagView.layer.borderColor = [UIColor redColor].CGColor;
    }
    
    [self.quiz nextRound];
    [self.view setUserInteractionEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextFlag:) userInfo:nil repeats:NO];
}

- (void)highlights
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    HighlightsController *highlights = [storyboard instantiateViewControllerWithIdentifier:@"HighlightsController"];
    
    highlights.mode = @"quiz";
    highlights.variant = @"name_to_image";
    
    [self.navigationController pushViewController:highlights animated:YES];
}

- (void)recordEvent:(BOOL)playerWasCorrect flag:(Flag *)flag
{
    [[EventRecorder sharedInstance] record:@{
         @"flag_name": [flag name],
         @"mode": @"quiz",
         @"variant": @"name_to_image",
         @"correct": playerWasCorrect ? @"true" : @"false"
     }];
}



@end
