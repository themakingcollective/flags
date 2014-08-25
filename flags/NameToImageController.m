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
#import "ResultsController.h"
#import "EventRecorder.h"
#import "Utils.h"

@interface NameToImageController () <FlagViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet FlagView *aFlagView;
@property (weak, nonatomic) IBOutlet FlagView *bFlagView;
@property (weak, nonatomic) IBOutlet FlagView *cFlagView;
@property (weak, nonatomic) IBOutlet FlagView *dFlagView;

@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, strong) DifficultyScaler *difficultyScaler;
@property (nonatomic, strong) NSArray *choices;

@property (nonatomic, strong) UIImageView *tick;
@property (nonatomic, strong) UIImageView *cross;

@end

@implementation NameToImageController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.variant = @"name_to_image";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.font = [UIFont fontWithName:@"BPreplay-Bold" size:30];
    
    self.difficultyScaler = [[DifficultyScaler alloc] initWithDifficultyKey:@"name-to-image-quiz"];
    
    NSArray *flags = [self.difficultyScaler scale:[Flag all]];
    self.quiz = [[Quiz alloc] initWithArray:flags andRounds:10];
    
    [[ScoringService sharedInstance] reset];
    
    self.aFlagView.delegate = self;
    self.bFlagView.delegate = self;
    self.cFlagView.delegate = self;
    self.dFlagView.delegate = self;
    
    [self nextFlag:nil];
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
    [self.tick removeFromSuperview];
    [self.cross removeFromSuperview];
    
    Flag *flag = [self.quiz currentElement];
    
    if (flag) {
        [self.difficultyScaler increaseDifficulty];
        self.label.text = [flag name];
        self.choices = [self.quiz choices:4];

        [self updateFlagView:self.aFlagView index:0];
        [self updateFlagView:self.bFlagView index:1];
        [self updateFlagView:self.cFlagView index:2];
        [self updateFlagView:self.dFlagView index:3];
    }
    else {
        [UIView setAnimationsEnabled:YES];
        [self results];
    }
}

- (void)updateFlagView:(FlagView *)view index:(NSInteger)index
{
    [view reset];
    view.flag = [self.choices objectAtIndex:index];
    [view setImage];
    [Utils resizeFrameToFitImage:view];
}

- (void)touchedFlagView:(FlagView *)flagView;
{
    Flag *guessedFlag = [flagView flag];
    Flag *correctFlag = [self.quiz currentElement];
    
    float delay;
    
    if ([guessedFlag isEqualTo:correctFlag]) {
        [self recordEvent:YES flag:correctFlag];
        [[ScoringService sharedInstance] correctForFlag:correctFlag andMode:@"quiz" andVariant:self.variant];
        [flagView correct];
        [self addTick:flagView];
        delay = 0.5f;
    }
    else {
        [self recordEvent:NO flag:correctFlag];
        [[ScoringService sharedInstance] incorrectForFlag:correctFlag andMode:@"quiz" andVariant:self.variant];
        [flagView incorrect];
        [self addCross:flagView];
        [[self correctFlagView] correct];
        delay = 1.5f;
    }
    
    [self.quiz nextRound];
    [self.view setUserInteractionEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(nextFlag:) userInfo:nil repeats:NO];
}

- (void)results
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ResultsController *results = [storyboard instantiateViewControllerWithIdentifier:@"ResultsController"];
    
    results.mode = self.mode;
    results.variant = self.variant;
    
    [self.navigationController pushViewController:results animated:YES];
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

- (FlagView *)correctFlagView
{
    NSString *answer = [[self.quiz currentElement] name];
    
    if ([answer isEqualToString:self.aFlagView.flag.name]) {
        return self.aFlagView;
    }
    if ([answer isEqualToString:self.bFlagView.flag.name]) {
        return self.bFlagView;
    }
    if ([answer isEqualToString:self.cFlagView.flag.name]) {
        return self.cFlagView;
    }
    if ([answer isEqualToString:self.dFlagView.flag.name]) {
        return self.dFlagView;
    }
    return nil;
}

- (void)addTick:(FlagView *)view
{
    self.tick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Opaque-Tick"]];
    
    self.tick.frame = CGRectMake(
        view.frame.origin.x + view.frame.size.width - 22,
        view.frame.origin.y - 12,
        30,
        32
    );
    
    [self.view addSubview:self.tick];
}

- (void)addCross:(FlagView *)view
{
    self.cross = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Opaque-Cross"]];
    
    self.cross.frame = CGRectMake(
        view.frame.origin.x + view.frame.size.width - 22,
        view.frame.origin.y - 12,
        30,
        30
    );

    [self.view addSubview:self.cross];
}

@end
