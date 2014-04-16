//
//  ViewController.m
//  crazycolors
//
//  Created by Santex on 16/04/14.
//  Copyright (c) 2014 Santex. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+UIColor_Extended.h"

static NSString *kPubNubPublishKey = @"pub-c-ae8c55a7-a336-4beb-a9fa-4db8dadd742e";
static NSString *kPubNubSubscribeKey = @"sub-c-dd51faf4-b5dc-11e3-85fc-02ee2ddab7fe";
static NSString *kPubNubSecretKey = @"sec-c-MmQxYzg0YTYtYzg0MC00MzEzLThhMzgtZjBmNGQ4ZWI5NWJl";

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
 
    [self setUpNotifications];
    [self setUpPubNub];
}

- (void)setUpNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(colorPaletteHasBeenSelected:)
                                                 name:kChannelIdentifier_CrazyColors
                                               object:nil];
}

- (void)setUpPubNub
{
    [PubNub setClientIdentifier:@"CrazyColors"];
    
    [PubNub setConfiguration:
     [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                                  publishKey:kPubNubPublishKey
                                subscribeKey:kPubNubSubscribeKey
                                   secretKey:kPubNubSecretKey]];
    [PubNub connect];
    
    channel = [PNChannel channelWithName:@"my_channel"
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
         
         [PubNub sendMessage:[NSString stringWithFormat:@"%@",self.view.backgroundColor]
                   toChannel:channel];
     }];
}

- (IBAction)colorPaletteHasBeenSelected:(id)sender
{
    
    PNMessage *receivedMessage = (PNMessage *)sender;
    UIColor *receivedColor = (UIColor *)[receivedMessage message];
    
    [UIView animateWithDuration:0.2 animations:
     ^{
         self.view.backgroundColor = [UIColor mixColors:@[self.view.backgroundColor,
                                                          receivedColor]];
     }
                     completion:
     ^(BOOL finished)
     {
         if ([arrayQueueObjects count]>2) {
             
             [arrayQueueObjects removeObjectAtIndex:0];
         }
         
         [arrayQueueObjects addObject:receivedColor];
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
