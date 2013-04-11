//
//  InvoFlipView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 11/20/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoFlipButtonView.h"
#import "InvoDataManager.h"

#import "UIColor+PainColor.h"

@interface InvoFlipButtonView ()

+(UIBezierPath *)createUIBezierWithdata:(NSData *)vertices Offset:(CGPoint)offsetPoint;
@end

@implementation InvoFlipButtonView

+(UIImage *)imageWithOrientation:(int)side{

    CGRect flipRect = CGRectMake(0, 0, 40, 90.0);
   
    float offsetY = 0.0;
    NSArray *entryToRender = [PainLocation  painEntryToRenderWithOrient:side Zoom:1];
    
// selecting the UIImage based on the orientation
    NSString *flipImageName = (side ==1)? @"zout_back_image.png":@"historyBodyImage.png";
    UIImage *flipImage = [UIImage imageNamed:flipImageName];
    float newHeight = flipRect.size.height;
//resetting the frame to match the flipsize image aspect ratio
    if (side ==1) {
        //0.5
        newHeight = flipRect.size.width/(flipImage.size.width/flipImage.size.height);
        offsetY = -(flipRect.size.height - newHeight)*0.25;
        CGRect newRect = CGRectMake(flipRect.origin.x, flipRect.origin.y + (flipRect.size.height - newHeight)*0.25, flipRect.size.width,newHeight);
        flipRect = newRect;
        
        NSLog(@"new rect is %@", NSStringFromCGRect(newRect));
    }
//starting the drawing
    UIGraphicsBeginImageContextWithOptions(flipRect.size, NO, [[UIScreen mainScreen]scale]);
    
    [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4]setFill];
    UIRectFill(flipRect);
    [[UIColor blackColor]setStroke];
    
    [flipImage drawInRect:flipRect
                blendMode:kCGBlendModeNormal
                    alpha:0.8];
    
    [entryToRender enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        UIColor *fillColor = [UIColor colorfromPain:[[obj valueForKey:@"painLevel"] integerValue]];
        PainLocation *loc = [(PainEntry *)obj location];
        int zoom = [[loc valueForKey:@"zoomLevel"] intValue];
//if a painLevel other than 0
        if (fillColor && zoom ==1) {
            NSData *vertices = [loc valueForKey:@"shape"];
            UIBezierPath *path = [InvoFlipButtonView createUIBezierWithdata:[vertices copy]
                                                                     Offset:CGPointMake(0, offsetY)];
    
            [fillColor setFill];
            [path fill];
        }
    }];
    
    flipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return flipImage;
}

+(UIBezierPath *)createUIBezierWithdata:(NSData *)vertices Offset:(CGPoint)offsetPoint {
    
    CGFloat viewWidth = 40 -offsetPoint.x;
    CGFloat viewHeight = 90.0;
    //CGFloat viewHeight = 90.0 - offsetPoint.y;
    
    int pointCount = 0;
    UIBezierPath *bezierPath = nil;
    CGPoint *points = NULL;
    
    int count = ([vertices length])/sizeof(CGPoint);
    
    //set Point Count to calloc enough memory
    if (points) {free(points);}
    points = (CGPoint *)calloc(sizeof(CGPoint), count);
    pointCount = count;
    
    // copy bytes to buffer _points
    [vertices getBytes:(CGPoint *)points length:[vertices length]];
    
    if (!bezierPath) {
        
        bezierPath = [UIBezierPath bezierPath];
            
            [bezierPath moveToPoint: CGPointMake(points[0].x*viewWidth,offsetPoint.y + points[0].y*viewHeight) ];
            
            for (int i=1; i<pointCount; i++) {
                
                [bezierPath addLineToPoint:CGPointMake(points[i].x*viewWidth ,offsetPoint.y+ points[i].y*viewHeight)];
            }
        [bezierPath closePath];
    }
    
    free(points);
    return [bezierPath copy];
}


@end
