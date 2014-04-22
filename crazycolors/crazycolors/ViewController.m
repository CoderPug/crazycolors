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
    
    [PubNub requestHistoryForChannel:[PNChannel channelWithName:kChannelIdentifier_CrazyColors]
                                from:nil
                                  to:nil
                               limit:3
                      reverseHistory:NO
                 withCompletionBlock:^(NSArray *pMessages, PNChannel *pChannel, PNDate *pBeginDate, PNDate *pEndDate, PNError *pError)
    {
        if (pMessages && pMessages.count > 0) {
            
            NSMutableArray *temporalMessagesArray = [NSMutableArray arrayWithArray:pMessages];
            [temporalMessagesArray removeLastObject];
            [self updateQueueWithArray:temporalMessagesArray];
            
            [self colorPaletteHasBeenSelected:[pMessages lastObject]];
            
        } else {
            
            self.view.backgroundColor = [UIColor getRandomColor];
            [self sendChangeOfColor:[UIColor getRandomColor]];
        }
        
    }];
    
    [self setUpNotifications];
    [self setUpPubNub];
}

- (void)setUpNotifications
{
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self
                                                         withBlock:
     ^(PNMessage *message)
    {
        [self colorPaletteHasBeenSelected:message];
    }];
    
    [[PNObservationCenter defaultCenter] addPresenceEventObserver:self
                                                        withBlock:
     ^(PNPresenceEvent *event)
     {
         _labelParticipantsCount.text = [NSString stringWithFormat:@"%d",event.channel.participantsCount];
         
     }];
        
}

- (void)setUpPubNub
{
    channel = [PNChannel channelWithName:kChannelIdentifier_CrazyColors
                   shouldObservePresence:YES];
    [PubNub subscribeOnChannel:channel];
    [PubNub enablePresenceObservationForChannel:channel];
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
    
    self.view.backgroundColor = [UIColor getColorFromDictionary:dictionaryCurrentColor];
    [self changeBackgroundColor:[UIColor getColorFromDictionary:dictionaryNextColor]];
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

- (void)updateQueueWithArray:(NSArray *)arrayMessages
{
    for (PNMessage *message in arrayMessages) {
        
        if ([arrayQueueObjects count]>2) {
            
            [arrayQueueObjects removeObjectAtIndex:0];
        }
        [arrayQueueObjects addObject:[UIColor getColorFromDictionary:[[message message] objectForKey:@"nextColor"]]];
    }
    [self updateQueue];
}

@end
