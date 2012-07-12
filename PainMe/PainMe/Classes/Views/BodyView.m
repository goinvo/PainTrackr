//
//  BodyView.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "BodyView.h"
#import <QuartzCore/QuartzCore.h>


@interface BodyView() {
   NSCache *_imageCache;
}
@property (nonatomic, retain) UIBezierPath *pathShape;

@end

@implementation BodyView

@synthesize pathShape = _pathShape;


+(Class)layerClass
{
   return [CATiledLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
+(CFTimeInterval)fadeDuration{

    return 0.0;
}
*/

- (void) awakeFromNib {
    
    
   [super awakeFromNib];
   CATiledLayer *tiledLayer = (CATiledLayer *) self.layer;
   
   //CGFloat scale = [UIScreen mainScreen].scale;
   tiledLayer.tileSize = CGSizeMake(BODY_TILE_SIZE, BODY_TILE_SIZE);
   
      
    tiledLayer.levelsOfDetail = 4;
//    tiledLayer.levelsOfDetailBias = 1;
    
   self.contentScaleFactor = 1.0;
    
   _imageCache = [[NSCache alloc] init];
   [_imageCache setCountLimit: 5 * 7];
    
}

// handle delegate method
// body pain level changed
// [self setNeedsDisplayInRect: ...]


-(void)renderPainForBodyPartPath:(UIBezierPath *)path{

    self.pathShape = [path copy];
    self.pathShape.lineJoinStyle = kCGLineJoinRound;
    
//    [self.pathShape applyTransform:CGAffineTransformMakeScale(1024, 1024)];
   
    [self setNeedsDisplayInRect:[self.pathShape bounds]];
   
}

- (void)drawRect:(CGRect)rect {
        
 	CGContextRef context = UIGraphicsGetCurrentContext();
   
   CGSize tileSize = (CGSize){BODY_TILE_SIZE, BODY_TILE_SIZE};
   
    CGFloat scale = CGContextGetCTM(context).a;
    NSLog(@"Scale in draw is %f",scale);
    
//    if (scale <0.25) {
//        
//        UIImage *img = [UIImage imageNamed:@"zoomed_out_body.png"];
//        CGRect imgRect = CGRectMake(0, 0, BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT);
//        [img drawInRect:imgRect];
//        
//    }else{
    
        int firstCol = floorf(CGRectGetMinX(rect) / tileSize.width);
        int lastCol = floorf((CGRectGetMaxX(rect)-1) / tileSize.width);
        int firstRow = floorf(CGRectGetMinY(rect) / tileSize.height);
        int lastRow = floorf((CGRectGetMaxY(rect)-1) / tileSize.height);
        
        for (int row = firstRow; row <= lastRow; row++) {
            for (int col = firstCol; col <= lastCol; col++) {
                UIImage *tile = [self tileAtCol:col row:row withScale:scale];
                
                if (tile) {
                    CGRect tileRect = CGRectMake(tileSize.width * col, 
                                                 tileSize.height * row,
                                                 tileSize.width, tileSize.height);
                    
                    tileRect = CGRectIntersection(self.bounds, tileRect);
                    
                    [tile drawInRect:tileRect];
                    
                    // Draw a white line around the tile border so 
                    // we can see it
                    [[UIColor redColor] set];
                    CGContextSetLineWidth(context, 6.0);
                    CGContextStrokeRect(context, tileRect);
                    
                    //             CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
                    //             CGContextFillEllipseInRect(context, CGRectMake(0, 0, rect.size.width*0.25*scale, rect.size.height*0.25*scale));
                }
            }
//        }
    }
    // iterate over pain entries
    // if pain entry's body part is inside rect, draw it
    if (self.pathShape) {
        
        [[UIColor blueColor] setStroke];
        [[UIColor colorWithRed:0.9 green:0.0 blue:0.0 alpha:1.0] setFill];
        
        [self.pathShape fill];
        [self.pathShape stroke];
    }

    
}

- (UIImage*)tileAtCol:(int)col row:(int)row withScale:(CGFloat)scale
{
    int numFrmScale = 256;
    if (scale == 1.0) {
        numFrmScale = 1024;
    }
    else if (scale == 0.5) {
        numFrmScale = 512;
    }
    else if(scale ==0.25) {
        numFrmScale = 256;
    }
    else {
        numFrmScale =0;
    }
    
   if (col>= 0 && col < BODY_TILE_COLUMNS && row >= 0 && row < BODY_TILE_ROWS) {
       
       NSString *filename;
       
       if (numFrmScale !=0) {

           filename = [NSString stringWithFormat:@"body_large_%02d_%d.png", (col+1) + (row) * BODY_TILE_COLUMNS,numFrmScale];           
       }
       else {
           
           filename = [NSString stringWithFormat:@"body_out_%02d.png", (col+1) + (row) * BODY_TILE_COLUMNS];
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

@end
