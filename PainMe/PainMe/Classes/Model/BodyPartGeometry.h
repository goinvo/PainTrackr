//
//  BodyPartGeometry.h
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BodyPartGeometry : NSObject

- (void) setPointCount: (NSInteger) newPoints;

- (BOOL) containsPoint: (CGPoint) point;
- (CGPoint *)getPoints;
- (UIBezierPath *) bezierPath;
@end
