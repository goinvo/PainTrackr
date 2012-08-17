//
//  InvoBodyPartDetails.h
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/10/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoBodyPartDetails : NSObject

@property (nonatomic, retain) UIBezierPath *partShapePoints;
@property (nonatomic, retain) UIColor *shapeColor;
@property (nonatomic, readwrite) int zoomLevel;
@property (nonatomic, retain) NSString *partName;


+(InvoBodyPartDetails *)InvoBodyPartWithShape:(UIBezierPath *)shape COlor:(UIColor *)color ZoomLevel:(int)zmLevel Name:(NSString *)name;

+(InvoBodyPartDetails *)InvoBodyPartWithShape:(UIBezierPath *)shape Name:(NSString *)name ZoomLevel:(int)zmLevel;
@end
