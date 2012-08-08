//
//  BodyPartGeometry.m
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "BodyPartGeometry.h"
#import "PainLocation.h"

@interface BodyPartGeometry() {
   CGPoint *_points;
}

@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, retain) UIBezierPath *bezierPath;

@property (nonatomic, retain) NSArray *painLocDetails;
@property (nonatomic, retain) NSMutableDictionary *painShapes;


@end

#define NUM_TO_DIVIDEX (1024.0*8)
#define NUM_TO_DIVIDEY (1024.0*17)

@implementation BodyPartGeometry

@synthesize pointCount = _pointCount, bezierPath = _bezierPath;
@synthesize painLocDetails = painLocDetails;



- (id) init {
   self = [super init];
   if (self) {
       
       self.painLocDetails = [[PainLocation painLocations]copy];
       self.painShapes = [NSMutableDictionary dictionary];
       _points = NULL;
       
       
       for (int i=0; i<[self.painLocDetails count]; i++) {
           
           NSDictionary *obj = [self.painLocDetails objectAtIndex:i];
           NSData *vertices = [obj valueForKey:@"shape"];
          
           int count = ([vertices length])/sizeof(CGPoint);

//set Point Count to calloc enough memory
           [self setPointCount:count];
// copy bytes to buffer _points
           [vertices getBytes:(CGPoint *)_points length:[vertices length]];
           
           NSString *pName = [obj valueForKey:@"name"];
    
           [self.painShapes setValue:[self bezierPath] forKey:pName];
    
       }
    }
   return self;
}

- (UIBezierPath *) bezierPath {
    
   if (!_bezierPath) {

       _bezierPath = [UIBezierPath bezierPath];

       if (_pointCount > 2) {
         
           [_bezierPath moveToPoint: CGPointMake(_points[0].x*NUM_TO_DIVIDEX,_points[0].y*NUM_TO_DIVIDEY ) ];

          for (int i=1; i<_pointCount; i++) {
             
//              NSLog(@"Point is x:%f y:%f",_points[i].x, _points[i].y);
            
              [_bezierPath addLineToPoint:CGPointMake(_points[i].x*NUM_TO_DIVIDEX,_points[i].y*NUM_TO_DIVIDEY )];
         }
         [_bezierPath closePath];
     }
   }
   return _bezierPath;
}

- (void) setPointCount: (NSInteger) newPoints {
   
    if (_points) {free(_points);}
   _points = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
   _pointCount = newPoints;
   self.bezierPath = nil;
    
}

- (void) dealloc {
   if (_points) free(_points);
}

- (NSDictionary *) containsPoint: (CGPoint) point withZoomLVL:(int)zmLVL {
   // TODO:  Find an algorithm for quickly determining whether a polygon contains a point
        
    NSDictionary * toRet = nil;
    
    NSArray *painShapeArr = [self.painShapes allValues];

    for (NSObject *obj in painShapeArr) {

        if ([(UIBezierPath *)obj containsPoint:CGPointMake(point.x*NUM_TO_DIVIDEX, point.y*NUM_TO_DIVIDEY)]) {
            
            NSArray *tmp = [self.painShapes allKeysForObject:obj];
            NSString *key = [tmp objectAtIndex:0];
            int keyVlue = 0;
            
            for (NSDictionary *diction in self.painLocDetails) {
                
                if ([[diction valueForKey:@"name"] isEqualToString:key]) {
                    
                    keyVlue = [[diction valueForKey:@"zoomLevel"]intValue];
                    break;
                }
            }
            
            if (keyVlue == zmLVL) {
                toRet = [NSDictionary dictionaryWithObject:[obj copy] forKey:[key copy]];
            }
            break;
        }
    }
    return toRet;
}

-(UIBezierPath *)dictFrBodyLocation:(NSString *)locName{

    if (locName) {
        
       return [ [self.painShapes valueForKey:locName]copy];
    }
    return nil;
}

-(CGPoint *)getPoints{
    return _points;   
}

@end
