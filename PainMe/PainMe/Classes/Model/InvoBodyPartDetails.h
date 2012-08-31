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


+(InvoBodyPartDetails *)invoBodyPartWithShape:(UIBezierPath *)shape color:(UIColor *)color zoomLevel:(int)zmLevel name:(NSString *)name;

+(InvoBodyPartDetails *)invoBodyPartWithShape:(UIBezierPath *)shape name:(NSString *)nme zoomLevel:(int)zmLevel;
@end
