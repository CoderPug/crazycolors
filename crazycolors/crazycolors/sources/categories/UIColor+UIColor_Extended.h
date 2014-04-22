//
//  UIColor+UIColor_Extended.h
//  crazycolors
//
//  Created by Santex on 16/04/14.
//  Copyright (c) 2014 Santex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UIColor_Extended)

+ (UIColor *)getRandomColor;
+ (UIColor *)mixColors:(NSArray *)arrayOfColors;
+ (UIColor *)getColorFromDictionary:(NSDictionary *)dictionary;

@end
