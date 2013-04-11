//
//  UIColor+PainColor.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 4/11/13.
//  Copyright (c) 2013 InvolutionStudios. All rights reserved.
//

#import "UIColor+PainColor.h"

@implementation UIColor (PainColor)

+(UIColor *)colorfromPain:(int)painLvl{
    
    UIColor *colorToFill = nil;
    
    switch (painLvl) {
        case 0:
            colorToFill = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.0f];
            // colorToFill = [UIColor clearColor];
            break;
        case 1:
            colorToFill = [UIColor colorWithRed:0.99f green:0.71f blue:0.51f alpha:0.9f];
            break;
        case 2:
            colorToFill = [UIColor colorWithRed:0.98f green:0.57f blue:0.26f alpha:0.9f];
            break;
        case 3:
            colorToFill = [UIColor colorWithRed:0.92 green:0.41 blue:0.42 alpha:0.9f];
            break;
        case 4:
            colorToFill = [UIColor colorWithRed:0.95 green:0.15 blue:0.21 alpha:0.9f];
            break;
        case 5:
            colorToFill = [UIColor colorWithRed:0.8 green:0.15 blue:0.24 alpha:0.9f];
            break;
            
        default:
            break;
    }
    
    return colorToFill;
}

+(UIColor *)indicatiorColor{

    return [UIColor grayColor];
}

+(UIColor *)flipButnBackColor{

    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8f];
}

@end
