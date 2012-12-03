//
//  InvoFlipView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 11/20/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoFlipButtonView.h"
#import "InvoDataManager.h"
#import "InvoPainColorHelper.h"


@interface InvoFlipButtonView ()

+(UIBezierPath *)createUIBezierWithdata:(NSData *)vertices Offset:(CGPoint)offsetPoint;
@end

@implementation InvoFlipButtonView

+(UIImage *)imageWithOrientation:(int)side{

    CGRect flipRect = CGRectMake(0, 0, 40, 90);
   
    int currSide = (side ==0)?1 : 0;
    
    PainEntry *entry = [[InvoDataManager sharedDataManager] lastPainEntryToRenderWithOrient:currSide];
    PainLocation *loc = [entry valueForKey:@"location"];
    
// getting data points to draw the bezier shape
    NSData *vertices = [loc valueForKey:@"shape"];
    UIBezierPath *path = [InvoFlipButtonView createUIBezierWithdata:[vertices copy] Offset:CGPointZero];

// selecting the UIImage based on the orientation
    NSString *flipImageName = (side ==0)? @"zout_back_image.png":@"historyBodyImage.png";
    UIImage *flipImage = [UIImage imageNamed:flipImageName];

//Pain Color
    UIColor *painColor = [InvoPainColorHelper colorfromPain:[[entry valueForKey:@"painLevel"]intValue]];
    
// drawing with the coloring of the most recent PainEntry
    UIGraphicsBeginImageContext(flipRect.size);
    
    [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4]setFill];
    UIRectFill(flipRect);

    [painColor setFill];
    [[UIColor blackColor]setStroke];
    [flipImage drawInRect:flipRect blendMode:kCGBlendModeNormal alpha:0.8];
    [path fill];
    
    flipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return flipImage;
}

+(UIBezierPath *)createUIBezierWithdata:(NSData *)vertices Offset:(CGPoint)offsetPoint {
    
    CGFloat viewWidth = 40 -offsetPoint.x;
    CGFloat viewHeight = 90 - offsetPoint.y;
    
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
            
            [bezierPath moveToPoint: CGPointMake(points[0].x*viewWidth,points[0].y*viewHeight) ];
            
            for (int i=1; i<pointCount; i++) {
                
                [bezierPath addLineToPoint:CGPointMake(points[i].x*viewWidth ,points[i].y*viewHeight)];
            }
        [bezierPath closePath];
    }
    return [bezierPath copy];
}


@end
