//
//  BodyView.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "BodyView.h"
#import <QuartzCore/QuartzCore.h>
#import "InvoBodyPartDetails.h"
#import "InvoDataManager.h"

@interface BodyView() {
   NSCache *_imageCache;
}


@property (nonatomic, retain) UIColor *bodyStrokeColor;
@property (nonatomic, readwrite) BOOL isMask;
@property (nonatomic, readwrite ) BOOL isNewStroke;

@property (nonatomic, retain) NSMutableArray *shapesArray;

+(CGColorSpaceRef)genericRGBSpace;
+(CGColorRef)redColor;
+(CGColorRef)blueColor;

+ (UIImage *)imageToMask:(UIImage *)image Withcolor:(UIColor *)color;

@end

@implementation BodyView


@synthesize bodyStrokeColor = _bodyStrokeColor;
@synthesize isMask = _isMask;
@synthesize isNewStroke = _isNewStroke;

@synthesize strokeChanged;

+(Class)layerClass
{
   return [CATiledLayer class];
}

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

 */

+(CGColorSpaceRef)genericRGBSpace;{

    static CGColorSpaceRef space = NULL;
    if (space == NULL) {
        space = CGColorSpaceCreateDeviceRGB();
    }
    return space;
}

+(CGColorRef)redColor;{

    static CGColorRef red = NULL;
    if (red == NULL) {
        CGFloat values[4] = {1.0,0.0,0.0,1.0};
        red = CGColorCreate([self genericRGBSpace], values);
    }
    return red;
}

+(CGColorRef)blueColor;{
    
    static CGColorRef blue = NULL;
    if (blue == NULL) {
        CGFloat values[4] = {0.0,0.0,1.0,1.0};
        blue = CGColorCreate([self genericRGBSpace], values);
    }
    return blue;
}


+(CFTimeInterval)fadeDuration{

    return 0.2;
}



- (void) awakeFromNib {
    
   [super awakeFromNib];
   
    CATiledLayer *tiledLayer = (CATiledLayer *) self.layer;
    
    self.contentScaleFactor = 1.0;
    
    tiledLayer.tileSize = CGSizeMake(BODY_TILE_SIZE, BODY_TILE_SIZE);
   
    tiledLayer.levelsOfDetail = 5;
//    tiledLayer.masksToBounds = YES;

    
   _imageCache = [[NSCache alloc] init];
   [_imageCache setCountLimit: 5 * 7];
    
    self.isMask = NO;
    self.isNewStroke = NO;
    self.strokeChanged = NO;
    
    self.shapesArray = [NSMutableArray array];

}

// handle delegate method
// body pain level changed
// [self setNeedsDisplayInRect: ...]

-(void)addObjToSHapesArrayWithShape:(UIBezierPath *)shape color:(UIColor *)fillColor detail:(int)levDet name:(NSString *)partName{

    InvoBodyPartDetails *partDetail = [InvoBodyPartDetails InvoBodyPartWithShape:[shape copy] COlor:fillColor ZoomLevel:levDet Name:[partName copy]];
    
    [self.shapesArray addObject:partDetail];

}

-(void)renderPainForBodyPartPath:(UIBezierPath *)path WithColor:(UIColor *)fillColor detailLevel:(int)level name:(NSString *)pName{
    
    BOOL found = NO;
 
    InvoBodyPartDetails *newPart = nil;
    
    for (InvoBodyPartDetails *partDetail in self.shapesArray) {
        
        //if (CGPathEqualToPath(path.CGPath, partDetail.partShapePoints.CGPath)) {
        if([pName isEqualToString:partDetail.partName]){
            
            if (![fillColor isEqual:partDetail.shapeColor]) {
                NSLog(@"Found to change color");
                found = YES;
                newPart = partDetail;
                break;
            }
        }
    }
    
    if(newPart){
        NSLog(@"Was changing color");
        newPart.shapeColor = fillColor;
    }

    if (!found) {
        
        [self addObjToSHapesArrayWithShape:[path copy] color:fillColor detail:level name:[pName copy]];
    }
        [self setNeedsDisplayInRect:[path bounds]];
    
}

#pragma mark Calculate center of a uiBezierPath

-(CGPoint)midPoinfOfBezierPath:(UIBezierPath *)bezier{

    if(bezier){
        CGRect bezierRect = [bezier bounds];
        float xPoint =bezierRect.origin.x + bezier.bounds.size.width *0.5;
        float yPoint =bezierRect.origin.y + bezier.bounds.size.height *0.5;
        CGPoint pointToReturn = CGPointMake(xPoint , yPoint);
        
        return pointToReturn;
    }
    return CGPointZero;
}

//int drawNum = 0;
#pragma makr Custom-Drawing code

- (void)drawRect:(CGRect)rect {
        
//    drawNum ++;
    
//    NSLog(@"the draw rect in BodyView draw is %@", NSStringFromCGRect(rect));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize tileSize = (CGSize){BODY_TILE_SIZE, BODY_TILE_SIZE};
    
    CGFloat scale = CGContextGetCTM(context).a/self.contentScaleFactor;

    scale = (self.contentScaleFactor ==2)?scale/2:scale;
    
//        NSLog(@"Scale in draw is %f",scale);
    
    int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);
        
    for (int row = firstRow; row <= lastRow; row++) {
        for (int col = firstCol; col <= lastCol; col++) {
            
            UIImage *tile = [self tileAtCol:col row:row withScale:scale];
            
            if (tile) {
                
                CGRect tileRect;
                
                tileRect = CGRectMake(tileSize.width * col,
                                      tileSize.height * row,
                                      tileSize.width, tileSize.height);
                
                tileRect = CGRectIntersection(self.bounds, tileRect);
                
                if(self.isMask){
                    
                    tile = [BodyView imageToMask:tile Withcolor:self.bodyStrokeColor];
                }
                
                [tile drawInRect:tileRect];
                
                // Draw a white line around the tile border so
                // we can see it
                //
                //                [[UIColor redColor] set];
                //                CGContextSetLineWidth(context, 6.0);
                //                CGContextStrokeRect(context, tileRect);
                
                //                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                //                CGContextFillEllipseInRect(context, CGRectMake(0, 0, rect.size.width*0.25*scale, rect.size.height*0.25*scale));
            }
        }
    }
    // iterate over pain entries
    // if pain entry's body part is inside rect, draw it
  
    int zoom = (scale <0.0625)?1:2;
    
    for (InvoBodyPartDetails *part in self.shapesArray) {
        
        if (part.partShapePoints && CGRectIntersectsRect(rect, [part.partShapePoints bounds])) {
            
            if(zoom == part.zoomLevel){
                CGContextSetStrokeColorWithColor(context,[BodyView blueColor]);
                CGContextSetFillColorWithColor(context, [part.shapeColor CGColor]);
                
                [part.partShapePoints fill];
                [part.partShapePoints stroke];
            }
            else{
                
                CGPoint centPoint = [self midPoinfOfBezierPath:part.partShapePoints];
  //              [part.shapeColor set];
                CGContextSetLineWidth(context, 4.0f);
                CGContextSetStrokeColorWithColor(context, part.shapeColor.CGColor);
                CGContextSetFillColorWithColor(context, part.shapeColor.CGColor);
                CGContextSetAlpha(context, 0.5f);
                CGContextFillEllipseInRect(context, CGRectMake(centPoint.x-150 , centPoint.y-150 , 300, 300));
                CGContextSetAlpha(context, 1.0f);
                CGContextFillEllipseInRect(context, CGRectMake(centPoint.x-50, centPoint.y-50, 100, 100));
                 
            }
        }
    }
//    NSLog(@"draw was called %d",drawNum);
}


- (UIImage*)tileAtCol:(int)col row:(int)row withScale:(CGFloat)scale
{
    int numFrmScale = 128;
    
    if (scale <0.0625) {
        numFrmScale = 0;
    }
    else if (scale >=0.0625 && scale <0.25) {
        numFrmScale = 128;
    }
    else if (scale >=0.25 && scale <0.5) {
        numFrmScale = 256;
    }
    else if (scale >= 0.5) {
        numFrmScale = 512;
    }
    
   if (col>= 0 && col < BODY_TILE_COLUMNS && row >= 0 && row < BODY_TILE_ROWS) {
       
       NSString *filename;
       
       if (numFrmScale !=0) {

            filename = [NSString stringWithFormat:@"body_slices_%02d_%d.png", (col+1) + (row) * BODY_TILE_COLUMNS,numFrmScale];           
       }
       else {
           
            filename = [NSString stringWithFormat:@"untitled-1_%02d.png", (col+1) + (row) * BODY_TILE_COLUMNS];
       }
           
      NSString *path = [[NSBundle mainBundle] pathForResource: filename ofType: nil];
      UIImage *image = [_imageCache objectForKey: path];

       if (!image) {
         image = [UIImage imageWithContentsOfFile:path];  
         [_imageCache setObject: image forKey: path];
      }
      return image;
   }
   else {
      return nil;
   }
}

#pragma mark mask WIth color for stroke of body

-(void)maskWithColor:(UIColor *)maskFillColor{

    if (self.isNewStroke == NO) {
     
        self.isMask = YES;
        self.isNewStroke = YES;
        self.bodyStrokeColor = maskFillColor;
        
        [self setNeedsDisplay];
    }
}

-(void)resetStroke{
    
    if (self.isNewStroke) {
        self.isMask = NO;
        self.isNewStroke = NO;
        
        [self setNeedsDisplay];
    }
}

#pragma mark -

+ (UIImage *)imageToMask:(UIImage *)image Withcolor:(UIColor *)color
{
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    
    [image drawInRect:rect];
    
    CGContextSetFillColorWithColor(ctxRef, [color CGColor]);
    CGContextSetBlendMode(ctxRef, kCGBlendModeSourceAtop);
    CGContextFillRect(ctxRef, rect);
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
    
}

#pragma mark removing Pain At given point
-(NSString *)removePainAtLocation:(CGPoint)touch{

    CGRect shapeRemoveRect = CGRectZero;
    InvoBodyPartDetails *PartToRem =nil;
    NSString *strToRet = nil;
    for (InvoBodyPartDetails *part in self.shapesArray) {
        
        if ([part.partShapePoints containsPoint:touch]) {
            
            shapeRemoveRect = [part.partShapePoints bounds];

            PartToRem = part ;
            
            strToRet =part.partName;
            break;
        }
    }
    
    if(PartToRem){
        [self.shapesArray removeObject:PartToRem];
        
    }
    
    [self setNeedsDisplayInRect:shapeRemoveRect];
    
    return strToRet;
}

-(BOOL)doesEntryExist:(NSString *)name{

    for (InvoBodyPartDetails *part in self.shapesArray) {
    
        if ([part.partName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark Image to be returned for Report

-(NSData *)imageToAttachToReport{


    UIGraphicsBeginImageContext(CGSizeMake(320, 480));
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    
    [self.window.layer renderInContext:ctxRef];
    
    UILabel *lbl =[[UILabel alloc]init ];
    [lbl setText:@"YAY Pain Trackr"];
    [lbl drawTextInRect:CGRectMake(100, 0, 220, 20)];

    UIImage *imgTRet = UIGraphicsGetImageFromCurrentImageContext();
    
       
    UIGraphicsEndImageContext();
    
//    UIImageWriteToSavedPhotosAlbum(imgTRet, nil, nil, nil);
    NSData *data = UIImagePNGRepresentation(imgTRet);

    return data;
}

-(void)saved{

    NSLog(@"Image was saved");
}
#pragma mark -

@end
