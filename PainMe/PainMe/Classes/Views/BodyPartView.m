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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithShape:(UIBezierPath *)shapePath{

    self = [super initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        self.partPath = shapePath;
        self.partPath.lineJoinStyle = kCGLineJoinRound;
  
 //        CGAffineTransform trans = CGAffineTransformMakeTranslation(-100, 100);
//        trans = CGAffineTransformScale(trans, 1024.0 * (8.0/3), 1024.0 *(17.0/6));
//        [_partPath applyTransform:trans];

//        [_partPath applyTransform:CGAffineTransformMakeScale(400.0f, 400.0f)];
        
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
    
    [_partPath applyTransform:CGAffineTransformMakeScale(400.0f, 400.0f)];
//    CGAffineTransform trans = CGAffineTransformTranslate(CGAffineTransformIdentity, 0.5 *self.bounds.size.width, 0.36 *self.bounds.size.height);
    
    [_partPath fill];
    [_partPath stroke];

}


@end
