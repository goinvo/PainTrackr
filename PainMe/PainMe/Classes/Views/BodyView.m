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


@property (nonatomic, strong) UIColor *bodyStrokeColor;
@property (nonatomic, readwrite) BOOL isMask;
@property (nonatomic, readwrite ) BOOL isNewStroke;

@property (nonatomic, strong) NSMutableArray *shapesArray;

+ (UIImage *)imageToMask:(UIImage *)image Withcolor:(UIColor *)color;

@end

@implementation BodyView

+(Class)layerClass
{
   return [CATiledLayer class];
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
    
   _imageCache = [[NSCache alloc] init];
   [_imageCache setCountLimit: 3 * 7];
    
    self.isMask = NO;
    self.isNewStroke = NO;
    self.strokeChanged = NO;
    
    self.currentView = @"front";
    
    self.shapesArray = [NSMutableArray array];

}

// handle delegate method
// body pain level changed
// [self setNeedsDisplayInRect: ...]

-(void)addObjToSHapesArrayWithShape:(UIBezierPath *)shape color:(UIColor *)fillColor detail:(int)levDet name:(NSString *)partName orientation:(int)side{

    InvoBodyPartDetails *partDetail = [InvoBodyPartDetails invoBodyPartWithShape:[shape copy] color:fillColor zoomLevel:levDet name:[partName copy] orientation:side];
    
    [self.shapesArray addObject:partDetail];

}

-(void)renderPainForBodyPartPath:(UIBezierPath *)path WithColor:(UIColor *)fillColor detailLevel:(int)level name:(NSString *)pName orient:(int)side{
    
    BOOL found = NO;
 
    InvoBodyPartDetails *newPart = nil;
    
    NSArray *arrayToIter = nil;
    
    //@synchronized(self.shapesArray){
        arrayToIter = [self.shapesArray copy];
//    }
        
    for (InvoBodyPartDetails *partDetail in arrayToIter) {
        
        if([pName isEqualToString:partDetail.partName]){
            
            if (![fillColor isEqual:partDetail.shapeColor]) {
//                NSLog(@"Found to change color");
                found = YES;
                newPart = partDetail;
                break;
            }
            else return;
        }
    }
    
    if(newPart){
//        NSLog(@"Was changing color");
        newPart.shapeColor = fillColor;
    }

    if (!found) {
        
        [self addObjToSHapesArrayWithShape:[path copy] color:fillColor detail:level name:[pName copy] orientation:side];
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


#pragma mark Custom-Drawing code

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGSize tileSize = (CGSize){BODY_TILE_SIZE, BODY_TILE_SIZE};
    
    CGFloat scale = CGContextGetCTM(context).a/self.contentScaleFactor;

    scale = (self.contentScaleFactor ==2)?scale/2:scale;
    
//    NSLog(@"Scale in draw is %f",scale);
    
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
             }
        }
    }
      
    int zoom = (scale <0.0625)?1:2;
    [self colorBodyLocationsInRect:rect WithZoom:zoom InContext:context withOffset:CGPointZero];
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

           filename = ([self.currentView isEqualToString:@"front"])? [NSString stringWithFormat:@"body_slices_%02d_%d.png", (col+1) + (row) * BODY_TILE_COLUMNS,numFrmScale] :
                                                                    [NSString stringWithFormat:@"back_zin_%02d_%d.png", (col+1) + (row) * BODY_TILE_COLUMNS,numFrmScale];
       }
       else {
           
           filename =([self.currentView isEqualToString:@"front"])? [NSString stringWithFormat:@"untitled-1_%02d.png", (col+1) + (row) * BODY_TILE_COLUMNS]:
                                                                    [NSString stringWithFormat:@"back_zout_%02d.png", (col+1) + (row) * BODY_TILE_COLUMNS];
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

#pragma mark color location in context

-(void)colorBodyLocationsInRect:(CGRect)rect WithZoom:(int)zm InContext:(CGContextRef)ctx withOffset:(CGPoint)ofst{
    
    NSArray *shapesArrayCopy = nil;

    int currSide = ([self.currentView isEqualToString:@"front"]?0:1);
    
    @synchronized(self.shapesArray){
        
        shapesArrayCopy = [self.shapesArray copy];
    }
    
    for (InvoBodyPartDetails *part in shapesArrayCopy) {
        
        if (part.partShapePoints && CGRectIntersectsRect(rect, [part.partShapePoints bounds]) && part.orientation == currSide) {
            
            if(zm == part.zoomLevel){
                
                CGContextSetStrokeColorWithColor(ctx,[UIColor clearColor].CGColor);
                CGContextSetFillColorWithColor(ctx, [part.shapeColor CGColor]);
                
                [part.partShapePoints applyTransform:CGAffineTransformMakeTranslation(ofst.x, ofst.y)];

                [part.partShapePoints fill];
                [part.partShapePoints stroke];
                [part.partShapePoints applyTransform:CGAffineTransformMakeTranslation(-ofst.x, -ofst.y)];
            }
            else{
                
                CGPoint centPoint = [self midPoinfOfBezierPath:part.partShapePoints];
                
                CGContextSetLineWidth(ctx, 4.0f);
                CGContextSetStrokeColorWithColor(ctx, part.shapeColor.CGColor);
                CGContextSetFillColorWithColor(ctx, part.shapeColor.CGColor);
                CGContextSetAlpha(ctx, 0.5f);
                //CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
                CGContextFillEllipseInRect(ctx, CGRectMake(centPoint.x-150 +ofst.x , centPoint.y-150+ofst.y , 300, 300));
                CGContextSetAlpha(ctx, 1.0f);
                CGContextFillEllipseInRect(ctx, CGRectMake(centPoint.x-50+ofst.x, centPoint.y-50+ofst.y, 100, 100));

            }
        }
    }
}

#pragma mark -

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
-(NSString *)partNameAtLocation:(CGPoint)touch withObj:(NSDictionary *)objDict remove:(BOOL)toRem{
    
    CGRect shapeRemoveRect = CGRectZero;
    InvoBodyPartDetails *PartToRem =nil;
    NSString *strToRet = nil;
    NSString *nameToCompare = [[objDict allKeys] objectAtIndex:0];
    [self.shapesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
    
        NSLog(@"shape in shaesArray is %@", [((InvoBodyPartDetails *)obj) partName]);
    }];
    
    for (InvoBodyPartDetails *part in self.shapesArray) {
        
        if ([part.partName isEqualToString:nameToCompare]) {
            
            shapeRemoveRect = [part.partShapePoints bounds];
            
            PartToRem = part ;
            
            strToRet =part.partName;
            break;
        }
    }
    
    if(PartToRem && toRem){
        
        [self.shapesArray removeObject:PartToRem];
        [self setNeedsDisplayInRect:shapeRemoveRect];
    }
    
    return strToRet;
}

-(BOOL)doesEntryExist:(NSString *)name withZoomLevel:(int)level {

    for (InvoBodyPartDetails *part in self.shapesArray) {
    
        if ([part.partName isEqualToString:name] && part.zoomLevel == level) {
            
            return YES;
        }
    }
    return NO;
}

#pragma mark Image to be returned for Report

-(NSData *)imageToAttachToReportWithZoomLevel:(float)level{

    CGFloat scale = (level<0.0623)?0.0623:0.123;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.bounds.size.width+1024,self.bounds.size.height+500), NO, 0.25);
//    NSLog(@"self bounds are %@", NSStringFromCGRect(self.bounds));

    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
        
    [@"Pain Trackr Report" drawInRect:CGRectMake(400, -50, self.bounds.size.width, 300)
                            withFont:[UIFont fontWithName:@"Helvetica" size:300]
                        lineBreakMode:UILineBreakModeWordWrap
                            alignment:UITextAlignmentCenter];
    
    for(int i=0 ;i<6;i++){
        
        NSString *name = [NSString stringWithFormat:@"F%d.png",i+1];
        NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
        UIImage *img = [UIImage imageWithContentsOfFile:path];
        [img drawInRect:CGRectMake(10, (40*(i+1) + img.size.height*i)*10, img.size.width*15, img.size.height*15)];
        
        CGContextSetFillColorWithColor(ctxRef, [UIColor whiteColor].CGColor);
        CGContextSetAlpha(ctxRef, 0.4f);
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(img.size.width*0.25*15 +50,(40*(i) + img.size.height*i)*10 + 15*img.size.height +200, 400, 140));
        
        CGContextSetAlpha(ctxRef, 1.0f);
        CGContextSetFillColorWithColor(ctxRef, [UIColor blackColor].CGColor);
        
        NSString *tmp = (i==0)? @"0":[NSString stringWithFormat:@"%d-%d",(i*2 -1),i*2];
        
        [tmp drawInRect:CGRectMake(img.size.width*0.25*15 +50,(40*(i) + img.size.height*i)*10 + 15*img.size.height +200, 400, 140)
               withFont:[UIFont fontWithName:@"Helvetica" size:150 ]
          lineBreakMode:UILineBreakModeCharacterWrap
              alignment:UITextAlignmentCenter];
    }
    
    CGSize tileSize = (CGSize){BODY_TILE_SIZE, BODY_TILE_SIZE};
    
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 4; col++) {
            
            UIImage *tile = [self tileAtCol:col row:row withScale:scale];
            
            if (tile) {
                
                CGRect tileRect;
                
                tileRect = CGRectMake(1024+tileSize.width * col,
                                      tileSize.height * row+500,
                                      tileSize.width, tileSize.height);
                
                [tile drawInRect:tileRect];
            }
        }
    }
    
    int zoom = (scale <0.0625)?1:2;
    [self colorBodyLocationsInRect:self.bounds
                          WithZoom:zoom
                         InContext:UIGraphicsGetCurrentContext()
                        withOffset:CGPointMake(1024, 500)];
    
    UIImage *imgTRet = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSData *data = UIImageJPEGRepresentation(imgTRet, 1);

    return data;
}

#pragma mark -

-(void)flipView{
 
    self.currentView = ([self.currentView isEqualToString:@"front"]? @"back" : @"front");
    [self setNeedsDisplay];
}

@end
