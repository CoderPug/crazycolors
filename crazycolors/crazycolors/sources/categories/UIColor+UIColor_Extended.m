//
//  UIColor+UIColor_Extended.m
//  crazycolors
//
//  Created by Santex on 16/04/14.
//  Copyright (c) 2014 Santex. All rights reserved.
//

#import "UIColor+UIColor_Extended.h"

@implementation UIColor (UIColor_Extended)

+ (UIColor *)getRandomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
}

+ (UIColor*)mixColors:(NSArray *)arrayOfColors
{
    UIColor *resultColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    CGFloat c1, c2, c3, c1Total, c2Total, c3Total, notUsed;
    NSInteger count = [arrayOfColors count];
    
    if (count == 0)
        return resultColor;
    if (count == 1)
        return [[arrayOfColors lastObject] copy];
    
    c1Total = c2Total = c3Total = 0;
    
    for (UIColor* aColor in arrayOfColors) {
        
        [aColor getRed:&c1 green:&c2 blue:&c3 alpha:&notUsed];
        c1Total += c1;
        c2Total += c2;
        c3Total += c3;
    }
    
    c1 = c1Total/count;
    c2 = c2Total/count;
    c3 = c3Total/count;
    
    resultColor = [UIColor colorWithRed:c1 green:c2 blue:c3 alpha:1.0];
    
    return resultColor;
}

+ (UIColor *)getColorFromDictionary:(NSDictionary *)dictionary
{
    CGFloat colorRed = [[dictionary objectForKey:@"red"] floatValue];
    CGFloat colorGreen = [[dictionary objectForKey:@"green"] floatValue];
    CGFloat colorBlue = [[dictionary objectForKey:@"blue"] floatValue];
    
    UIColor *color = [UIColor colorWithRed:colorRed
                                     green:colorGreen
                                      blue:colorBlue
                                     alpha:1.0];
    return color;
}

@end
