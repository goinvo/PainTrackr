//
//  BodyPartView.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/2/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "BodyPartView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BodyPartView
@synthesize partPath = _partPath;

/*
+(Class)layerClass
{
    return [CATiledLayer class];
}
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithShape:(UIBezierPath *)shapePath{

    self = [super init];
    
    if(self){
                
        [self setUserInteractionEnabled:NO];
        self.backgroundColor = [UIColor clearColor];
        self.partPath = [shapePath copy];
        self.partPath.lineJoinStyle = kCGLineJoinRound;
          
        [self setNeedsDisplay];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    NSLog(@"Yes");

    _partPath.lineWidth = 2.0;
    
    NSLog(@"partpath curr point x:%f y:%f", _partPath.currentPoint.x, _partPath.currentPoint.y);
    NSLog(@"curr bounds are width:%f height:%f", self.bounds.size.width, self.bounds.size.height);
    NSLog(@"super view bounds are %f %f", self.superview.bounds.size.width,self.superview.bounds.size.height);

//    [_partPath applyTransform:CGAffineTransformMakeScale(1024, self.bounds.size.height)];

    [[UIColor blackColor] setStroke];
    [[UIColor colorWithRed:1.0 green:192.0/255 blue:203.0/255 alpha:1.0] setFill];
    [_partPath fill];
    [_partPath stroke];

    self.partPath = nil;
    
//    CGAffineTransform tranSelf = CGAffineTransformMakeTranslation(512 +(3*1024), 8*1024);
//    [self setTransform:CGAffineTransformScale(tranSelf,8, 17)];

}


@end
