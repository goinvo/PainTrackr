//
//  BodyPartGeometry.h
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BodyPartGeometry : NSObject

- (void) setPointCount: (NSInteger) newPoints;

- (NSDictionary *) containsPoint: (CGPoint) point withZoomLVL:(int)zmLVL withOrientation:(int16_t)orientation;

- (CGPoint *)getPoints;
- (UIBezierPath *) bezierPath;

-(UIBezierPath *)shapeForLocationName:(NSString *)locName;



@end
