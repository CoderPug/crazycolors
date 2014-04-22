//
//  ViewController.h
//  crazycolors
//
//  Created by Santex on 16/04/14.
//  Copyright (c) 2014 Santex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    NSMutableArray *arrayQueueObjects;
}

@property(nonatomic, retain) IBOutlet UILabel *labelParticipantsCount;
@property(nonatomic, retain) IBOutletCollection(UIButton) NSArray *arrayPalette;
@property(nonatomic, retain) IBOutletCollection(UIButton) NSArray *arrayQueue;

@end
