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

@interface BodyView() {
   NSCache *_imageCache;
}
@property (nonatomic, retain) UIBezierPath *pathShape;
@property (nonatomic, retain) UIColor *shapeFillColor;

@property (nonatomic, retain) UIColor *bodyStrokeColor;
@property (nonatomic, readwrite) BOOL isMask;
@property (nonatomic, readwrite ) BOOL isNewStroke;

@property (nonatomic, retain) NSMutableArray *shapesArray;

//+(CGColorSpaceRef)genericRGBSpace;
//+(CGColorRef)redColor;
//+(CGColorRef)blueColor;

+ (UIImage *)imageToMask:(UIImage *)image Withcolor:(UIColor *)color;

@end

@implementation BodyView

@synthesize pathShape = _pathShape;
@synthesize shapeFillColor = _shapeFillColor;

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
    
//    [self setBackgroundColor:[UIColor blueColor]];
    
   //CGFloat scale = [UIScreen mainScreen].scale;
    
    self.contentScaleFactor = 1.0;
    
//    [self setUserInteractionEnabled:YES];
    
    tiledLayer.tileSize = CGSizeMake(BODY_TILE_SIZE, BODY_TILE_SIZE);
   
    tiledLayer.levelsOfDetail = 5;
    tiledLayer.masksToBounds = YES;

    
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


-(void)renderPainForBodyPartPath:(UIBezierPath *)path WithColor:(UIColor *)fillColor detailLevel:(int)level{

    //self.pathShape = [path copy];
    
    for (InvoBodyPartDetails *partDetail in self.shapesArray) {
        
        if ([path isEqual:partDetail.partShapePoints]) {
            
            if (![fillColor isEqual:partDetail.shapeColor]) {
                
                partDetail.shapeColor = fillColor;
                [self setNeedsDisplayInRect:[path bounds]];
            }
            return;
        }
    }
    
    InvoBodyPartDetails *partDetail = [InvoBodyPartDetails InvoBodyPartWithShape:[path copy] COlor:fillColor ZoomLevel:level];
    
    [self.shapesArray addObject:partDetail];
    
//    self.pathShape.lineJoinStyle = kCGLineJoinRound;
//    
//    self.shapeFillColor = fillColor;
   
    [self setNeedsDisplayInRect:[self.pathShape bounds]];
    
//    NSLog(@"path bounds are %@", NSStringFromCGRect([self.pathShape bounds]));
}

int drawNum = 0;

- (void)drawRect:(CGRect)rect {
        
    drawNum ++;
    
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
  
    /*
    if (self.pathShape && CGRectIntersectsRect([self.pathShape bounds], rect)) {
        
        CGContextSetStrokeColorWithColor(context, [BodyView redColor]);
        CGContextSetFillColorWithColor(context, [self.shapeFillColor CGColor]);
        
//        [[UIColor blackColor] setStroke];
//        [self.shapeFillColor setFill];
        
        [self.pathShape fill];
        [self.pathShape stroke];
    }
     
     */
    int zoom = (scale <0.0625)?1:2;
    
    for (InvoBodyPartDetails *part in self.shapesArray) {
        
        if (part.partShapePoints && CGRectIntersectsRect(rect, [part.partShapePoints bounds]) && zoom == part.zoomLevel) {
            
            CGContextSetStrokeColorWithColor(context,[BodyView blueColor]);
            CGContextSetFillColorWithColor(context, [part.shapeColor CGColor]);
            
            [part.partShapePoints fill];
            [part.partShapePoints stroke];
        }
    }
    
    NSLog(@"draw was called %d",drawNum);
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

//           filename = [NSString stringWithFormat:@"body_large_%02d_%d.png", (col+1) + (row) * BODY_TILE_COLUMNS,numFrmScale];
            filename = [NSString stringWithFormat:@"body_slices_%02d_%d.png", (col+1) + (row) * BODY_TILE_COLUMNS,numFrmScale];           
       }
       else {
           
//           filename = [NSString stringWithFormat:@"body_slices_%02d.png", (col+1) + (row) * BODY_TILE_COLUMNS];
            filename = [NSString stringWithFormat:@"untitled-1_%02d.png", (col+1) + (row) * BODY_TILE_COLUMNS];
       }
    
//       NSLog(@"Body Image name is %@",filename );
       
      NSString *path = [[NSBundle mainBundle] pathForResource: filename ofType: nil];
      UIImage *image = [_imageCache objectForKey: path];
      if (!image) {
         //image = [UIImage imageNamed: filename];  
         image = [UIImage imageWithContentsOfFile:path];  
         [_imageCache setObject: image forKey: path];
      }
      return image;
   } else {
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
-(void)removePainAtLocation:(CGPoint)touch{

    for (InvoBodyPartDetails *part in self.shapesArray) {
        
        if ([part.partShapePoints containsPoint:touch]) {
            
            CGRect shapeRemoveRect = [part.partShapePoints bounds];
            [self.shapesArray removeObject:part];
            [self setNeedsDisplayInRect:shapeRemoveRect];
            break;
        }
    }
}

#pragma mark TOuchDelegate methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"touches began inside body view");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"Touches ended inside body View");
}
#pragma mark -

@end
