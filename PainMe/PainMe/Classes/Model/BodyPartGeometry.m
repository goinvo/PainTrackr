//
//  BodyPartGeometry.m
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "BodyPartGeometry.h"
#import "PainLocation.h"
#import "InvoBodyPartDetails.h"


@interface BodyPartGeometry() {
   CGPoint *_points;
}

@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, retain) UIBezierPath *bezierPath;

@property (nonatomic, retain) NSArray *painLocDetails;

@property (nonatomic, retain)NSMutableArray *painShapeDetailsArr;


@end

#define NUM_TO_DIVIDEX (1024.0*4)
#define NUM_TO_DIVIDEY (1024.0*9)

@implementation BodyPartGeometry

@synthesize pointCount = _pointCount, bezierPath = _bezierPath;
@synthesize painLocDetails = painLocDetails;


- (id) init {
   self = [super init];
   if (self) {
       
       self.painLocDetails = [[PainLocation painLocations]copy];
       self.painShapeDetailsArr = [NSMutableArray array];
      
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
           NSInteger zmLvl = [[obj valueForKey:@"zoomLevel"]integerValue];
           
           InvoBodyPartDetails *part = [InvoBodyPartDetails invoBodyPartWithShape:[self bezierPath] name:[pName copy] zoomLevel:zmLvl orientation:[[obj valueForKey:@"orientation"] intValue]];
           
           [self.painShapeDetailsArr addObject:part];
       }
       
       for (InvoBodyPartDetails *part in self.painShapeDetailsArr) {
           if (part.zoomLevel ==1) {
             NSLog(@"part names to check are %@",part.partName);  
           }
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

- (NSDictionary *) containsPoint: (CGPoint) point withZoomLVL:(int)zmLVL withOrientation:(int16_t)orientation{
   // TODO:  Find an algorithm for quickly determining whether a polygon contains a point
        
    NSDictionary * toRet = nil;
    CGPoint pointToCheck = CGPointMake(point.x*NUM_TO_DIVIDEX, point.y*NUM_TO_DIVIDEY);
    
    NSMutableArray *arrToIter = [NSMutableArray array];
    
    for (InvoBodyPartDetails *part in self.painShapeDetailsArr) {
        
        if (part.orientation == orientation && part.zoomLevel == zmLVL ) {
            [arrToIter addObject:part];
        }
    }
    
    for(InvoBodyPartDetails *part in arrToIter){
    
//        NSLog(@"part names to check are %@",part.partName);
    }
    
    for (InvoBodyPartDetails *part in arrToIter) {
        
        if ([part.partShapePoints containsPoint:pointToCheck]) {
            
//            toRet = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:part.partShapePoints] forKeys:[NSArray arrayWithObject:part.partName]];
            toRet = [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:part.partShapePoints,[NSNumber numberWithInt:part.zoomLevel],nil] forKey:part.partName];
            break;
        }
    }
    arrToIter = nil;
    
//    for (InvoBodyPartDetails *part in self.painShapeDetailsArr) {
//        
//        if (part.zoomLevel == zmLVL && part.orientation == orientation) {
//            
//            if ([part.partShapePoints containsPoint:pointToCheck]) {
//                
//                toRet = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObject:part.partShapePoints] forKeys:[NSArray arrayWithObject:part.partName]];
//                break;
//            }
//        }
//    }
    
    return toRet;
}


-(UIBezierPath *)dictFrBodyLocation:(NSString *)locName{

    UIBezierPath *path;
    if (locName) {
        for (InvoBodyPartDetails *part in self.painShapeDetailsArr) {
            
            if ([part.partName isEqualToString:locName]) {
                path = [part.partShapePoints copy];
            }
        }
        
       return path;
    }
    return nil;
}

 
-(CGPoint *)getPoints{
    return _points;   
}

@end
