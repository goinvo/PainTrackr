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
       
       [self setPointCount: 40];
       
       _points[0] = CGPointMake(numToAddX +(1014/NUM_TO_DIVIDEX), numToAddY +(446/NUM_TO_DIVIDEY));
       _points[1] = CGPointMake(numToAddX +(920/NUM_TO_DIVIDEX), numToAddY +(464/NUM_TO_DIVIDEY));
       _points[2] = CGPointMake(numToAddX +(870/NUM_TO_DIVIDEX), numToAddY +(486/NUM_TO_DIVIDEY));
       _points[3] = CGPointMake(numToAddX +(819/NUM_TO_DIVIDEX), numToAddY +(517/NUM_TO_DIVIDEY));
       _points[4] = CGPointMake(numToAddX +(776/NUM_TO_DIVIDEX), numToAddY +(555/NUM_TO_DIVIDEY));
       _points[5] = CGPointMake(numToAddX +(739/NUM_TO_DIVIDEX), numToAddY +(601/NUM_TO_DIVIDEY));
       _points[6] = CGPointMake(numToAddX +(710/NUM_TO_DIVIDEX), numToAddY +(652/NUM_TO_DIVIDEY));
       _points[7] = CGPointMake(numToAddX +(692/NUM_TO_DIVIDEX), numToAddY +(707/NUM_TO_DIVIDEY));
       _points[8] = CGPointMake(numToAddX +(683/NUM_TO_DIVIDEX), numToAddY +(766/NUM_TO_DIVIDEY));
       _points[9] = CGPointMake(numToAddX +(684/NUM_TO_DIVIDEX), numToAddY +(822/NUM_TO_DIVIDEY));
       _points[10] = CGPointMake(numToAddX +(695/NUM_TO_DIVIDEX), numToAddY +(880/NUM_TO_DIVIDEY));
       
       _points[11] = CGPointMake(numToAddX +(714/NUM_TO_DIVIDEX), numToAddY +(935/NUM_TO_DIVIDEY));
       _points[12] = CGPointMake(numToAddX +(744/NUM_TO_DIVIDEX), numToAddY +(984/NUM_TO_DIVIDEY));
       _points[13] = CGPointMake(numToAddX +(778/NUM_TO_DIVIDEX), numToAddY +(1023/NUM_TO_DIVIDEY));
       
       
       numToAddY = 7.0/17;
       
       _points[14] = CGPointMake(numToAddX +(782/NUM_TO_DIVIDEX), numToAddY +(4/NUM_TO_DIVIDEY));
       _points[15] = CGPointMake(numToAddX +(825/NUM_TO_DIVIDEX), numToAddY +(42/NUM_TO_DIVIDEY));
       _points[16] = CGPointMake(numToAddX +(874/NUM_TO_DIVIDEX), numToAddY +(71/NUM_TO_DIVIDEY));
       _points[17] = CGPointMake(numToAddX +(928/NUM_TO_DIVIDEX), numToAddY +(92/NUM_TO_DIVIDEY));
       _points[18] = CGPointMake(numToAddX +(986/NUM_TO_DIVIDEX), numToAddY +(104/NUM_TO_DIVIDEY));
       _points[19] = CGPointMake(numToAddX +(1023/NUM_TO_DIVIDEX), numToAddY +(103/NUM_TO_DIVIDEY));
       
       
       numToAddX = 4.0/8;
       
       _points[20] = CGPointMake(numToAddX +(3/NUM_TO_DIVIDEX), numToAddY +(104/NUM_TO_DIVIDEY));
       _points[21] = CGPointMake(numToAddX +(40/NUM_TO_DIVIDEX), numToAddY +(102/NUM_TO_DIVIDEY));
       _points[22] = CGPointMake(numToAddX +(95/NUM_TO_DIVIDEX), numToAddY +(92/NUM_TO_DIVIDEY));
       _points[23] = CGPointMake(numToAddX +(150/NUM_TO_DIVIDEX), numToAddY +(71/NUM_TO_DIVIDEY));
       _points[24] = CGPointMake(numToAddX +(199/NUM_TO_DIVIDEX), numToAddY +(41/NUM_TO_DIVIDEY));
       _points[25] = CGPointMake(numToAddX +(244/NUM_TO_DIVIDEX), numToAddY +(2/NUM_TO_DIVIDEY));
       
       numToAddY = 6.0/17;
       
       _points[26] = CGPointMake(numToAddX +(267/NUM_TO_DIVIDEX), numToAddY +(1001/NUM_TO_DIVIDEY));
       _points[27] = CGPointMake(numToAddX +(299/NUM_TO_DIVIDEX), numToAddY +(953/NUM_TO_DIVIDEY));
       
       _points[28] = CGPointMake(numToAddX +(324/NUM_TO_DIVIDEX), numToAddY +(899/NUM_TO_DIVIDEY));
       _points[29] = CGPointMake(numToAddX +(337/NUM_TO_DIVIDEX), numToAddY +(843/NUM_TO_DIVIDEY));
       _points[30] = CGPointMake(numToAddX +(341/NUM_TO_DIVIDEX), numToAddY +(783/NUM_TO_DIVIDEY));
       _points[31] = CGPointMake(numToAddX +(336/NUM_TO_DIVIDEX), numToAddY +(726/NUM_TO_DIVIDEY));
       _points[32] = CGPointMake(numToAddX +(320/NUM_TO_DIVIDEX), numToAddY +(673/NUM_TO_DIVIDEY));
       _points[33] = CGPointMake(numToAddX +(295/NUM_TO_DIVIDEX), numToAddY +(621/NUM_TO_DIVIDEY));
       _points[34] = CGPointMake(numToAddX +(262/NUM_TO_DIVIDEX), numToAddY +(573/NUM_TO_DIVIDEY));
       
       _points[35] = CGPointMake(numToAddX +(222/NUM_TO_DIVIDEX), numToAddY +(531/NUM_TO_DIVIDEY));
       _points[36] = CGPointMake(numToAddX +(175/NUM_TO_DIVIDEX), numToAddY +(497/NUM_TO_DIVIDEY));
       _points[37] = CGPointMake(numToAddX +(123/NUM_TO_DIVIDEX), numToAddY +(471/NUM_TO_DIVIDEY));
       _points[38] = CGPointMake(numToAddX +(68/NUM_TO_DIVIDEX), numToAddY +(456/NUM_TO_DIVIDEY));
       _points[39] = CGPointMake(numToAddX +(10/NUM_TO_DIVIDEX), numToAddY +(448/NUM_TO_DIVIDEY));
       
       [self bezierPath];
       
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
