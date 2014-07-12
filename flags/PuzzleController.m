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
#import "ResultsController.h"
#import "Flag.h"

@interface PuzzleController () <PaintPotViewDelegate, PatternViewDelegate, LayeredViewDelegate>

@property (nonatomic, weak) IBOutlet LayeredView *layeredView;
@property (nonatomic, strong) Quiz *quiz;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *feedbackLabel;
@property (nonatomic, strong) NSArray *paintPots;
@property (nonatomic, strong) NSArray *patterns;
@property (nonatomic, weak) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) DifficultyScaler *difficultyScaler;
@property (nonatomic, strong) Flag *currentPatternFlag;

@end

@implementation PuzzleController

@synthesize difficulty=_difficulty;

- (void)viewDidLoad
{
    NSString *previousTitle = [self previousTitle];
    
    self.difficulty = [previousTitle isEqualToString:@"colours"] ? @"easy" : @"hard";
    self.navigationItem.title = previousTitle;
    
    self.layeredView.backgroundColor = [UIColor clearColor];
    [self.layeredView setDelegate:self];
    
    NSString *difficultyKey = [NSString stringWithFormat:@"puzzle-%@", self.difficulty];
    self.difficultyScaler = [[DifficultyScaler alloc] initWithDifficultyKey:difficultyKey];
    
    NSArray *flags = [self.difficultyScaler scale:[Flag all]];
    self.quiz = [[Quiz alloc] initWithArray:flags andRounds:1];
    
    UIFont *titleFont = [UIFont fontWithName:@"BPreplay-Bold" size:30];
    [self.nameLabel setFont:titleFont];
    
    UIFont *feedbackFont = [UIFont fontWithName:@"BPreplay" size:24];
    [self.feedbackLabel setFont:feedbackFont];
    
    [self nextFlag:nil];
    
    [super viewDidLoad];
}

- (void)nextFlag:(NSTimer *)timer
{
    [self setUserInteraction:YES];
    [self.layeredView setPaintColor:nil];
    
    Flag *flag = [self.quiz currentElement];
    
    if (flag) {
        [self.difficultyScaler increaseDifficulty];
        [self setSubmitButtonState:NO];
        [self.nameLabel setText:[flag name]];
        [self.feedbackLabel setText:@""];
        [self.layeredView setFlag:flag];
        [self setupPaintPots:flag];
        [self setupPatterns:flag];
        [self touchFirstPaintPot];
    }
    else {
        [self showResults];
    }
}

- (IBAction)submit
{
    if ([self isCorrect]) {
        [self.quiz correct];
        [self.feedbackLabel setTextColor:[UIColor colorWithRed:(73 / 255.0f) green:(142 / 255.0f) blue:(93 / 255.0f) alpha:1.0f]];
        [self.feedbackLabel setText:@"correct!"];
    }
    else {
        [self.quiz incorrect];
        [self.feedbackLabel setTextColor:[UIColor colorWithRed:(194 / 255.0f) green:(32 / 255.0f) blue:(38 / 255.0f) alpha:1.0f]];
        [self.feedbackLabel setText:@"try again!"];
    }
    
    [self setUserInteraction:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(nextFlag:) userInfo:nil repeats:NO];
}

- (void)showResults
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ResultsController *results = [storyboard instantiateViewControllerWithIdentifier:@"ResultsController"];
    results.quiz = self.quiz;
    results.difficulty = self.difficulty;
    
    [self.navigationController pushViewController:results animated:YES];
}

- (void)setupPaintPots:(Flag *)flag
{
    self.paintPots = [self viewsForClass:[PaintPotView class]];
    NSArray *colors = [flag shuffledColors];
    
    if ([self.paintPots count] != [colors count]) {
        [NSException raise:@"Counts do not match" format:@"For flag %@", [flag name]];
    }
    
    for (NSInteger i = 0; i < [self.paintPots count]; i++) {
        PaintPotView *pot = [self.paintPots objectAtIndex:i];
        UIColor *color = [colors objectAtIndex:i];
        
        [pot setDelegate:self];
        [pot setColor:color];
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
    }
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
    NSLog(@"touched flag: %@", pattern.flag.name);
//    [self.layeredView setFlag:[[Flag all] firstObject]];
    
    self.currentPatternFlag = pattern.flag;
}

- (void)touchedLayeredView:(LayeredView *)layeredView
{
    [self setSubmitButtonState:YES];
}

- (void)touchFirstPaintPot
{
    [self touchedPaintPot:[self.paintPots firstObject]];
}

- (void)setUserInteraction:(BOOL)state
{
    self.view.userInteractionEnabled = state;
    self.navigationController.view.userInteractionEnabled = state;
    
    for (UIView *view in self.view.subviews) {
        [view setUserInteractionEnabled:state];
    }
}

- (void)setSubmitButtonState:(BOOL)state
{
    NSString *difficulty = [self.difficulty isEqualToString:@"easy"] ? @"Easy" : @"Hard";
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
    if ([self.difficulty isEqualToString:@"easy"]) {
        return [self.layeredView isCorrect];
    }
    else {
        return [self.layeredView isCorrect] && [self.currentPatternFlag isEqualTo:self.quiz.currentElement];
    }
}

@end
