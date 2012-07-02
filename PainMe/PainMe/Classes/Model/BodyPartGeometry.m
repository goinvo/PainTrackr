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
    
    if (point.x >=0.46 && point.x <=0.54) {
        
        if (point.y >=0.36 && point.y <= 0.4) {
            
            [self setPointCount:18];

            CGPoint bellyPoints[] = {   CGPointMake(990, 182),
                                        CGPointMake(921, 190),
                                        CGPointMake(858, 210),
                                        CGPointMake(800, 244),
                                        CGPointMake(748, 285),
                                        CGPointMake(706, 339),
                                        CGPointMake(674, 396),
                                        CGPointMake(654, 458),
                                        CGPointMake(645, 525),
                                        CGPointMake(650, 592),
                                        CGPointMake(667, 656),
                                        CGPointMake(696, 717),
                                        CGPointMake(737, 768),
                                        CGPointMake(786, 814),
                                        CGPointMake(843, 849),
                                        CGPointMake(905, 872),
                                        CGPointMake(939, 879),
                                        CGPointMake(988, 884),
                                        
                                        };
            
            
            _points = memcpy(_points, bellyPoints, _pointCount*sizeof(CGPoint));
            

            return YES;
        }
    }

   return NO;
}

-(CGPoint *)getPoints{
    return _points;   
}

@end
