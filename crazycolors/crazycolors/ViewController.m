//
//  ViewController.m
//  crazycolors
//
//  Created by Santex on 16/04/14.
//  Copyright (c) 2014 Santex. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+UIColor_Extended.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [self loadRandomPalette];
    arrayQueueObjects = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor getRandomColor];
}

- (void)loadRandomPalette
{
    for (UIButton *aButton in _arrayPalette) {
        
        [aButton setBackgroundColor:[UIColor getRandomColor]];
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.type == UIEventSubtypeMotionShake) {
        
        [self loadRandomPalette];
    }
}

- (IBAction)paletteButtonTouchUpInside:(id)sender
{
    [UIView animateWithDuration:0.2 animations:
     ^{
         self.view.backgroundColor = [UIColor mixColors:@[self.view.backgroundColor,
                                                          [(UIButton *)sender backgroundColor]]];
     }
                     completion:
     ^(BOOL finished)
     {
         if ([arrayQueueObjects count]>2) {
             
             [arrayQueueObjects removeObjectAtIndex:0];
         }
         
         [arrayQueueObjects addObject:[(UIButton *)sender backgroundColor]];
         [self updateQueue];
     }];
}

- (void)updateQueue
{
    int buttonIndex = 0;
    for (UIButton *aButton in _arrayQueue) {
        
        if (arrayQueueObjects.count > buttonIndex) {
            
            [aButton setBackgroundColor:[arrayQueueObjects objectAtIndex:buttonIndex]];
        }
        buttonIndex++;
    }
}

@end
