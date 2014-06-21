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

@interface PuzzleController () <PaintPotViewDelegate>

@property (weak, nonatomic) IBOutlet LayeredView *layeredView;

@end

@implementation PuzzleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.layeredView setBackgroundColor:[UIColor clearColor]];
    [self.layeredView setFlag:@"France"];
    [self setupPaintPots];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit
{
    if ([self.layeredView isCorrect]) {
        NSLog(@"correct!");
    }
    else {
        NSLog(@"incorrect!");
    }
}

- (void)setupPaintPots
{
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[PaintPotView class]]) {
            [(PaintPotView *)subview setDelegate:self];
        }
    }
}

- (void)touchedPaintPot:(UIColor *)color
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    NSLog(@"touched paint pot with color: %f,%f,%f,%f",red,green,blue,alpha);
}

@end
