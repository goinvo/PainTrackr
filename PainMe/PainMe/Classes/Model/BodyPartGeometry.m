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

@implementation BodyPartGeometry

@synthesize pointCount = _pointCount, bezierPath = _bezierPath;

- (id) init {
   self = [super init];
   if (self) {
      // set point count
      // [self setPointCount: 18];
      //_points[0] = CGPointMake(0.46, ...);
   }
   return self;
}

- (UIBezierPath *) bezierPath {
   if (!_bezierPath) {
      _bezierPath = [UIBezierPath bezierPath];
      if (_pointCount > 2) {
         [_bezierPath moveToPoint: _points[0]];
         for (int i=1; i<_pointCount; i++) {
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
