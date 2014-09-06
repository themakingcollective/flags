//
//  PuzzleController.m
//  flags
//
//  Created by Edwin Bos on 24/05/2014.
//  Copyright (c) 2014 chris. All rights reserved.
//

#import "PuzzleController.h"
#import "LayeredView.h"
#import "PaintPotView.h"
#import "PatternView.h"
#import "Quiz.h"
#import "FeedbackController.h"
#import "Flag.h"
#import "Utils.h"
#import "EventRecorder.h"
#import "AggregatesService.h"
#import "ScoringService.h"

@interface PuzzleController () <PaintPotViewDelegate, PatternViewDelegate, LayeredViewDelegate>

@property (nonatomic, weak) IBOutlet LayeredView *layeredView;
@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSArray *paintPots;
@property (nonatomic, strong) NSArray *patterns;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) DifficultyScaler *difficultyScaler;
@property (nonatomic, strong) Flag *currentPatternFlag;

@end

@implementation PuzzleController

- (void)viewDidLoad
{
    [self setModeAndVariant];
    [super viewDidLoad];
    
    self.navigationItem.title = [self.variant isEqualToString:@"easy"] ? @"colours" : @"patterns + colours";
    
    self.layeredView.backgroundColor = [UIColor clearColor];
    [self.layeredView setDelegate:self];
    
    NSString *difficultyKey = [NSString stringWithFormat:@"puzzle-%@", self.variant];
    self.difficultyScaler = [[DifficultyScaler alloc] initWithDifficultyKey:difficultyKey];
    
    NSArray *flags = [self.difficultyScaler scale:[Flag all]];
    self.quiz = [[Quiz alloc] initWithArray:flags andRounds:10];
    
    UIFont *titleFont = [UIFont fontWithName:@"BPreplay-Bold" size:30];
    [self.nameLabel setFont:titleFont];
    
    [[ScoringService sharedInstance] reset];
    [self nextFlag];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.variant isEqualToString:@"easy"]) {
        NSInteger y = 266 + 14; // 14 points padding below layered view.
        
        for (PaintPotView *pot in self.paintPots) {
            CGRect f = pot.frame;
            pot.frame = CGRectMake(f.origin.x, y, f.size.width, 41);
        }
        
        y += 41 + 16; // 16 points padding below paint pots.
        
        CGRect f = self.submitButton.frame;
        self.submitButton.frame = CGRectMake(f.origin.x, y, f.size.width, f.size.height);
    }
    
    for (PaintPotView *pot in self.paintPots) {
        [pot setupHighlights];
    }
    
    for (PatternView *pattern in self.patterns) {
        [pattern setupHighlights];
    }
    
    [self touchFirstPaintPot];
}

- (BOOL)nextFlag
{
    [self.layeredView setPaintColor:nil];
    
    Flag *flag = [self.quiz currentElement];
    
    if (flag) {
        [self.difficultyScaler increaseDifficulty];
        [self setSubmitButtonState:NO];
        [self.nameLabel setText:[flag name]];
        [self setupChoices:flag];
        if ([[flag name] isEqualToString:@"Nepal"]) {
            [self.layeredView removeBorders];
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

- (IBAction)submit
{
    BOOL playerWasCorrect = [self isCorrect];
    Flag *correctFlag = [self.quiz currentElement];
    [self recordEvent:playerWasCorrect flag:correctFlag];
    
    if (playerWasCorrect) {
        [[ScoringService sharedInstance] correctForFlag:correctFlag andMode:@"puzzle" andVariant:self.variant];
    }
    else {
        [[ScoringService sharedInstance] incorrectForFlag:correctFlag andMode:@"puzzle" andVariant:self.variant];
    }

    [self.quiz nextRound];
    [self showFeedback:playerWasCorrect withFlag:correctFlag];
}

- (void)showFeedback:(BOOL)playerWasCorrect withFlag:(Flag *)correctFlag
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    FeedbackController *feedback = [storyboard instantiateViewControllerWithIdentifier:@"FeedbackController"];
    
    Flag *chosenFlag = self.currentPatternFlag;
    if (!chosenFlag) {
        chosenFlag = correctFlag;
    }
    
    feedback.yourFlagView = [Utils copyView:self.layeredView];
    feedback.playerWasCorrect = playerWasCorrect;
    feedback.chosenFlag = chosenFlag;
    feedback.correctFlag = correctFlag;
    feedback.mode = self.mode;
    feedback.variant = self.variant;
    
    [self.navigationController pushViewController:feedback animated:NO];
}

- (NSArray *)viewsForClass:(id)class
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[class class]]) {
            [array addObject:subview];
        }
    }
    
    return [NSArray arrayWithArray:array];
}

- (void)touchedLayeredView:(LayeredView *)layeredView
{
    [self setSubmitButtonState:YES];
}

- (void)setSubmitButtonState:(BOOL)state
{
    NSString *difficulty = [self.variant isEqualToString:@"easy"] ? @"Easy" : @"Hard";
    NSString *active = state ? @"Enabled" : @"Disabled";
    NSString *imageName = [NSString stringWithFormat:@"Done-Button-%@-%@", difficulty, active];
    
    [self.submitButton setUserInteractionEnabled:state];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (NSString *)previousTitle
{
    NSInteger previousIndex = [self.navigationController.viewControllers count] - 2;
    UIViewController *previousController = [self.navigationController.viewControllers objectAtIndex:previousIndex];
    return previousController.navigationItem.title;
}

- (BOOL)isCorrect
{
    if ([self.variant isEqualToString:@"easy"]) {
        return [self.layeredView isCorrect];
    }
    else {
        return [self.layeredView isCorrect] && [self.currentPatternFlag isEqualTo:self.quiz.currentElement];
    }
}

# pragma mark choice set up

- (void)setupChoices:(Flag *)flag
{
    [self setupPaintPots:flag];
    [self setupPatterns:flag];
    
    if ([self.variant isEqualToString:@"easy"]) {
        [self.layeredView setFlag:flag];
        [self removePatterns];
    }
    else {
        [self.layeredView setBlank];
        [self hidePaintPots];
        [self hideSubmitButton];
    }
    [self touchFirstPaintPot];
}

- (void)setupPaintPots:(Flag *)flag
{
    self.paintPots = [self viewsForClass:[PaintPotView class]];
    NSArray *colors = [flag shuffledColors];
    
    for (NSInteger i = 0; i < [self.paintPots count]; i++) {
        PaintPotView *pot = [self.paintPots objectAtIndex:i];
        
        if (i < [colors count]) {
            UIColor *color = [colors objectAtIndex:i];
        
            [pot setDelegate:self];
            [pot setColor:color];
        }
        else {
            NSLog(@"Missing incorrect color - skipping");
        }
    }
}

- (void)setupPatterns:(Flag *)flag
{
    self.patterns = [self viewsForClass:[PatternView class]];
    NSArray *patternFlags = [self.quiz.currentElement patternFlags];
    
    for (NSInteger i = 0; i < [self.patterns count]; i++) {
        PatternView *pattern = [self.patterns objectAtIndex:i];
        Flag *patternFlag = [patternFlags objectAtIndex:i];
        
        [pattern setFlag:patternFlag];
        [pattern setFlagImage];
        [pattern setDelegate:self];
        [pattern setHighlighted:NO];
    }
}

- (void)touchFirstPaintPot
{
    [self touchedPaintPot:[self.paintPots firstObject]];
}

- (void)removePatterns
{
    for (PatternView *patternView in self.patterns) {
        [patternView removeFromSuperview];
    }
}

- (void)hidePaintPots
{
    for (PaintPotView *paintPot in self.paintPots) {
        paintPot.hidden = YES;
    }
}

- (void)showPaintPots
{
    for (PaintPotView *paintPot in self.paintPots) {
        paintPot.hidden = NO;
    }
}

- (void)hideSubmitButton
{
    self.submitButton.hidden = YES;
}

- (void)showSubmitButton
{
    self.submitButton.hidden = NO;
}

- (void)touchedPaintPot:(PaintPotView *)paintPot
{
    [self.layeredView setPaintColor:paintPot.backgroundColor];
    
    for (PaintPotView *view in self.paintPots) {
        [view setHighlighted:NO];
    }
    [paintPot setHighlighted:YES];
}

- (void)touchedPattern:(PatternView *)pattern
{
    self.currentPatternFlag = pattern.flag;
    [self.layeredView setFlag:pattern.flag];
    
    if ([[pattern.flag name] isEqualToString:@"Nepal"]) {
        [self.layeredView removeBorders];
    }
    
    for (PatternView *v in self.patterns) {
        [v setHighlighted:NO];
    }
    [pattern setHighlighted:YES];
    
    [self showPaintPots];
    [self showSubmitButton];
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

- (void)setModeAndVariant
{
    self.mode = @"puzzle";
    
    if (!self.variant) {
        NSInteger previousIndex = [self.navigationController.viewControllers count] - 2;
        BaseViewController *previousController = [self.navigationController.viewControllers objectAtIndex:previousIndex];
        
        if (previousController.variant) {
            self.variant = previousController.variant;
        }
        else {
            NSString *previousTitle = previousController.navigationItem.title;
            self.variant = [previousTitle isEqualToString:@"colours"] ? @"easy" : @"hard";
        }
    }
}

@end
