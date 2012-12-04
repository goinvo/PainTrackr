//
//  BodyView.h
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BODY_TILE_COLUMNS 4
#define BODY_TILE_ROWS 9
#define BODY_TILE_SIZE 1024

#define BODY_VIEW_WIDTH (BODY_TILE_COLUMNS*BODY_TILE_SIZE)
#define BODY_VIEW_HEIGHT (BODY_TILE_ROWS*BODY_TILE_SIZE)

@interface BodyView : UIView{

}

@property (nonatomic, readwrite)BOOL strokeChanged;
@property (nonatomic, strong) NSString *currentView;

-(void)renderPainForBodyPartPath:(UIBezierPath *)path WithColor:(UIColor *)fillColor detailLevel:(int)level name:(NSString *)pName orient:(int)side;

-(void)maskWithColor:(UIColor *)maskFillColor;
-(void)resetStroke;

-(NSString *)partNameAtLocation:(CGPoint)touch remove:(BOOL)toRem;
-(void)addObjToSHapesArrayWithShape:(UIBezierPath *)shape color:(UIColor *)fillColor detail:(int)levDet name:(NSString *)partName orientation:(int)side;
//-(BOOL)doesEntryExist:(NSString *)name;
-(BOOL)doesEntryExist:(NSString *)name withZoomLevel:(int)level;

-(NSData *)imageToAttachToReportWithZoomLevel:(float)level;
-(void)colorBodyLocationsInRect:(CGRect)rect WithZoom:(int)zm InContext:(CGContextRef)ctx withOffset:(CGPoint)ofst;

-(void)flipView;
@end
