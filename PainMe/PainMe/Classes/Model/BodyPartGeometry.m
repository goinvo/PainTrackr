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
       
       [self setPointCount: 18];
       
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
       
         }
   return self;
}

- (UIBezierPath *) bezierPath {
   if (!_bezierPath) {

       _bezierPath = [UIBezierPath bezierPath];

       if (_pointCount > 2) {
         
          [_bezierPath moveToPoint: _points[0]];

          for (int i=1; i<_pointCount; i++) {
             
             NSLog(@"Point is x:%f y:%f",_points[i].x, _points[i].y);
             
            [_bezierPath addLineToPoint: _points[i]];
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
   return [self.bezierPath containsPoint: point];
}

-(CGPoint *)getPoints{
    return _points;   
}

@end
