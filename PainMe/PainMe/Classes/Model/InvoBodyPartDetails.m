//
//  InvoBodyPartDetails.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/10/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoBodyPartDetails.h"

@interface InvoBodyPartDetails ()

-(id)initWithShape:(UIBezierPath *)shapePts Color:(UIColor *)shpColor ZoomLevel:(int)level;

@end

@implementation InvoBodyPartDetails

+(InvoBodyPartDetails *)InvoBodyPartWithShape:(UIBezierPath *)shape COlor:(UIColor *)color ZoomLevel:(int)zmLevel{

    return [[self alloc] initWithShape:[shape copy] Color:color ZoomLevel:zmLevel];
}

-(id)initWithShape:(UIBezierPath *)shapePts Color:(UIColor *)shpColor ZoomLevel:(int)level{

    self = [super init];
    if (self) {
    
        self.partShapePoints = [shapePts copy];
        self.partShapePoints.lineJoinStyle = kCGLineJoinRound;
        
        self.shapeColor = shpColor;
        self.zoomLevel = level;
    }
    return self;
}

@end
