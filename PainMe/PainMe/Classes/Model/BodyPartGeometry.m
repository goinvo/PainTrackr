//
//  BodyPartGeometry.m
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "BodyPartGeometry.h"

@interface BodyPartGeometry() {
   CGPoint *_points;
}

@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, retain) UIBezierPath *bezierPath;


@end

#define NUM_TO_DIVIDEX (1024.0*8)
#define NUM_TO_DIVIDEY (1024.0*17)

@implementation BodyPartGeometry

@synthesize pointCount = _pointCount, bezierPath = _bezierPath;

- (id) init {
   self = [super init];
   if (self) {
      // set point count
       
       float numToAddX = 3.0/8; // 3rd column
       float numToAddY = 6.0/17; // 6th row 
       
       [self setPointCount: 35];
       
       _points[0] = CGPointMake(numToAddX +(990/NUM_TO_DIVIDEX), numToAddY +(182/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(921/NUM_TO_DIVIDEX), numToAddY +(190/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(858/NUM_TO_DIVIDEX), numToAddY +(210/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(800/NUM_TO_DIVIDEX), numToAddY +(244/NUM_TO_DIVIDEY));
       _points[4] = CGPointMake(numToAddX +(748/NUM_TO_DIVIDEX), numToAddY +(285/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(706/NUM_TO_DIVIDEX), numToAddY +(339/NUM_TO_DIVIDEY));
       _points[6] = CGPointMake(numToAddX +(674/NUM_TO_DIVIDEX), numToAddY +(396/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(654/NUM_TO_DIVIDEX), numToAddY +(458/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(645/NUM_TO_DIVIDEX), numToAddY +(525/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(650/NUM_TO_DIVIDEX), numToAddY +(592/NUM_TO_DIVIDEY));
       _points[10] = CGPointMake(numToAddX +(667/NUM_TO_DIVIDEX), numToAddY +(656/NUM_TO_DIVIDEY));
       _points[11] = CGPointMake(numToAddX +(696/NUM_TO_DIVIDEX), numToAddY +(717/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(737/NUM_TO_DIVIDEX), numToAddY +(768/NUM_TO_DIVIDEY));
       _points[13] = CGPointMake(numToAddX +(786/NUM_TO_DIVIDEX), numToAddY +(814/NUM_TO_DIVIDEY));
       _points[14] = CGPointMake(numToAddX +(843/NUM_TO_DIVIDEX), numToAddY +(849/NUM_TO_DIVIDEY));
       _points[15] = CGPointMake(numToAddX +(905/NUM_TO_DIVIDEX), numToAddY +(872/NUM_TO_DIVIDEY));
       _points[16] = CGPointMake(numToAddX +(939/NUM_TO_DIVIDEX), numToAddY +(879/NUM_TO_DIVIDEY));
       _points[17] = CGPointMake(numToAddX +(988/NUM_TO_DIVIDEX), numToAddY +(884/NUM_TO_DIVIDEY));
       
       numToAddX = 4.0/8;
       
       _points[18] = CGPointMake(numToAddX +(0/NUM_TO_DIVIDEX), numToAddY +(883/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(31/NUM_TO_DIVIDEX), numToAddY +(879/NUM_TO_DIVIDEY));
       _points[20] = CGPointMake(numToAddX +(95/NUM_TO_DIVIDEX), numToAddY +(869/NUM_TO_DIVIDEY));
       _points[21] = CGPointMake(numToAddX +(156/NUM_TO_DIVIDEX), numToAddY +(833/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(209/NUM_TO_DIVIDEX), numToAddY +(793/NUM_TO_DIVIDEY));
       _points[23] = CGPointMake(numToAddX +(255/NUM_TO_DIVIDEX), numToAddY +(749/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(288/NUM_TO_DIVIDEX), numToAddY +(685/NUM_TO_DIVIDEY));
       _points[25] = CGPointMake(numToAddX +(313/NUM_TO_DIVIDEX), numToAddY +(629/NUM_TO_DIVIDEY));
       _points[26] = CGPointMake(numToAddX +(323/NUM_TO_DIVIDEX), numToAddY +(556/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(322/NUM_TO_DIVIDEX), numToAddY +(490/NUM_TO_DIVIDEY));
       _points[28] = CGPointMake(numToAddX +(307/NUM_TO_DIVIDEX), numToAddY +(424/NUM_TO_DIVIDEY));
       _points[29] = CGPointMake(numToAddX +(282/NUM_TO_DIVIDEX), numToAddY +(363/NUM_TO_DIVIDEY));
       _points[30] = CGPointMake(numToAddX +(244/NUM_TO_DIVIDEX), numToAddY +(308/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(197/NUM_TO_DIVIDEX), numToAddY +(260/NUM_TO_DIVIDEY));
       _points[32] = CGPointMake(numToAddX +(141/NUM_TO_DIVIDEX), numToAddY +(223/NUM_TO_DIVIDEY));
       _points[33] = CGPointMake(numToAddX +(81/NUM_TO_DIVIDEX), numToAddY +(197/NUM_TO_DIVIDEY));
       _points[34] = CGPointMake(numToAddX +(14/NUM_TO_DIVIDEX), numToAddY +(183/NUM_TO_DIVIDEY));
       
         }
   return self;
}

- (UIBezierPath *) bezierPath {
    
    
   if (!_bezierPath) {

       _bezierPath = [UIBezierPath bezierPath];

       if (_pointCount > 2) {
         
//          [_bezierPath moveToPoint: _points[0]];
           [_bezierPath moveToPoint: CGPointMake(_points[0].x*NUM_TO_DIVIDEX,_points[0].y*NUM_TO_DIVIDEY ) ];

          for (int i=1; i<_pointCount; i++) {
             
             NSLog(@"Point is x:%f y:%f",_points[i].x, _points[i].y);
             
//            [_bezierPath addLineToPoint: _points[i]];
              [_bezierPath addLineToPoint:CGPointMake(_points[i].x*NUM_TO_DIVIDEX,_points[i].y*NUM_TO_DIVIDEY )];
         }
         [_bezierPath closePath];
     }
   }
   return _bezierPath;
}

- (void) setPointCount: (NSInteger) newPoints {
   if (_points) free(_points);
   _points = calloc(sizeof(CGPoint), newPoints);
   _pointCount = newPoints;
   self.bezierPath = nil;
    
}

- (void) dealloc {
   if (_points) free(_points);
}

- (BOOL) containsPoint: (CGPoint) point {
   // TODO:  Find an algorithm for quickly determining whether a polygon contains a point
        
    NSLog(@"The bounds of Bezierpath are %f %f", self.bezierPath.bounds.size.width,self.bezierPath.bounds.size.height);
    
    return [self.bezierPath containsPoint:CGPointMake(point.x*NUM_TO_DIVIDEX, point.y*NUM_TO_DIVIDEY)];
//    return (CGRectContainsPoint(self.bezierPath.bounds, point));
    
//    return [self.bezierPath containsPoint: point];
}

-(CGPoint *)getPoints{
    return _points;   
}

@end
