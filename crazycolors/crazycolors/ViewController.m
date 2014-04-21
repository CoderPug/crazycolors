//
//  ViewController.m
//  crazycolors
//
//  Created by Santex on 16/04/14.
//  Copyright (c) 2014 Santex. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+UIColor_Extended.h"

@interface ViewController () {
    
    PNChannel *channel;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [self loadRandomPalette];

    arrayQueueObjects = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor getRandomColor];
    [self sendChangeOfColor:[UIColor getRandomColor]];
    
    [self setUpNotifications];
    [self setUpPubNub];
}

- (void)setUpNotifications
{
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self
                                                         withBlock:^(PNMessage *message)
    {
        [self colorPaletteHasBeenSelected:message];
    }];
}

- (void)setUpPubNub
{
    channel = [PNChannel channelWithName:kChannelIdentifier_CrazyColors
                   shouldObservePresence:NO];
    [PubNub subscribeOnChannel:channel];
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
    UIColor *receivedColor = [(UIButton *)sender backgroundColor];
    [self sendChangeOfColor:receivedColor];
}

- (void)sendChangeOfColor:(UIColor *)color
{
    CGFloat colorRedA, colorGreenA, colorBlueA, alphaA;
    CGFloat colorRedB, colorGreenB, colorBlueB, alphaB;
    
    [self.view.backgroundColor getRed:&colorRedA green:&colorGreenA blue:&colorBlueA alpha:&alphaA];
    [color getRed:&colorRedB green:&colorGreenB blue:&colorBlueB alpha:&alphaB];
    
    NSDictionary *dictionaryColor = @{@"currentColor":@{@"red":[NSString stringWithFormat:@"%.6f",colorRedA],
                                                        @"green":[NSString stringWithFormat:@"%.6f",colorGreenA],
                                                        @"blue":[NSString stringWithFormat:@"%.6f",colorBlueA]},
                                      
                                      @"nextColor":@{@"red":[NSString stringWithFormat:@"%.6f",colorRedB],
                                                     @"green":[NSString stringWithFormat:@"%.6f",colorGreenB],
                                                     @"blue":[NSString stringWithFormat:@"%.6f",colorBlueB]}};
    
    [PubNub sendMessage:dictionaryColor toChannel:channel];
}

- (IBAction)colorPaletteHasBeenSelected:(id)sender
{
    PNMessage *receivedMessage = (PNMessage *)sender;
    NSDictionary *dictionaryCurrentColor = [(NSDictionary *)[receivedMessage message] objectForKey:@"currentColor"];
    NSDictionary *dictionaryNextColor = [(NSDictionary *)[receivedMessage message] objectForKey:@"nextColor"];
    
    CGFloat colorRedA = [[dictionaryCurrentColor objectForKey:@"red"] floatValue];
    CGFloat colorGreenA = [[dictionaryCurrentColor objectForKey:@"green"] floatValue];
    CGFloat colorBlueA = [[dictionaryCurrentColor objectForKey:@"blue"] floatValue];
    
    UIColor *colorCurrent = [UIColor colorWithRed:colorRedA
                                             green:colorGreenA
                                              blue:colorBlueA
                                             alpha:1.0];
    
    self.view.backgroundColor = colorCurrent;
    
    CGFloat colorRedB = [[dictionaryNextColor objectForKey:@"red"] floatValue];
    CGFloat colorGreenB = [[dictionaryNextColor objectForKey:@"green"] floatValue];
    CGFloat colorBlueB = [[dictionaryNextColor objectForKey:@"blue"] floatValue];
    
    UIColor *colorNext = [UIColor colorWithRed:colorRedB
                                             green:colorGreenB
                                              blue:colorBlueB
                                             alpha:1.0];
    
    [self changeBackgroundColor:colorNext];
}

- (void)changeBackgroundColor:(UIColor *)color
{
    [UIView animateWithDuration:0.2 animations:
     ^{
         self.view.backgroundColor = [UIColor mixColors:@[self.view.backgroundColor,
                                                          color]];
     }
                     completion:
     ^(BOOL finished)
     {
         if ([arrayQueueObjects count]>2) {
             
             [arrayQueueObjects removeObjectAtIndex:0];
         }
         
         [arrayQueueObjects addObject:color];
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
