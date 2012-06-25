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

@end

@implementation BodyPartGeometry

@synthesize pointCount = _pointCount;

- (id) init {
   self = [super init];
   if (self) {
      
   }
   return self;
}

- (void) setPointCount: (NSInteger) newPoints {
   if (_points) free(_points);
   _points = calloc(sizeof(CGPoint), newPoints);
   _pointCount = newPoints;
}

- (void) dealloc {
   if (_points) free(_points);
}

- (BOOL) containsPoint: (CGPoint) point {
   // TODO:  Find an algorithm for quickly determining whether a polygon contains a point
   return NO;
}


@end
