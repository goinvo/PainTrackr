//
//  InvoHistoryView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/30/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoHistoryView.h"
#import "QuartzCore/QuartzCore.h"
//#import "PainEntry.h"
//#import "PainLocation.h"


@interface InvoHistoryView ()
{
    CGPoint *_points;
    int zoomLevel;

}
//@property (nonatomic, retain) NSMutableArray *locationArray;
@property (nonatomic, retain) NSString *dateSring;
@property (nonatomic, readwrite)BOOL moreEntries;
@property (nonatomic, retain) UIBezierPath *bezierPath;
@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, retain) UIColor *partColor;

//- (CGPoint *)getPoints;
//- (UIBezierPath *) bezierPath;
-(void)createUIBezierWithOffset:(CGPoint)offsetPoint;
-(CGPoint)midPoinfOfBezierPath:(UIBezierPath *)bezier;
-(UIColor *)colorfromPain:(int)painLvl;
@end



@implementation InvoHistoryView

@synthesize del = _del;

- (void) setPointCount: (NSInteger) newPoints {
    
    if (_points) {free(_points);}
    _points = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
    _pointCount = newPoints;
    self.bezierPath = nil;
}


- (id)initWithFrame:(CGRect)frame locations:(NSArray *)shapesDict date:(NSString *)stringDate 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        NSLog(@"history view init");
//        NSLog(@"Received dict is %@",shapesDict);
        
        [self setUserInteractionEnabled:YES];
        [self setExclusiveTouch:YES];
       // [self setClipsToBounds:YES];
        
        NSArray *locatArr = [NSArray arrayWithArray:shapesDict];
        self.dateSring = [stringDate copy];
        self.moreEntries = NO;
        
        id obj = [[locatArr objectAtIndex:0] valueForKey:@"location"];
        
        NSData *vertices = [obj valueForKey:@"shape"];
        zoomLevel = [[obj valueForKey:@"zoomLevel"] integerValue];
        self.partColor = [self colorfromPain:[[[locatArr objectAtIndex:0] valueForKey:@"painLevel"] integerValue]];
        
        
        int count = ([vertices length])/sizeof(CGPoint);
        
        //set Point Count to calloc enough memory
        [self setPointCount:count];
        // copy bytes to buffer _points
        [vertices getBytes:(CGPoint *)_points length:[vertices length]];

        
        if ([locatArr count] > 1) {
            self.moreEntries = YES;
            [self createUIBezierWithOffset:CGPointMake(20, 20)];
            [self setNeedsDisplay];
        }
        [self createUIBezierWithOffset:CGPointZero];
                
        //[self bezierPath];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    NSLog(@"Drawing in History view");
    
    
    UIImage *img = [UIImage imageNamed:@"historyBodyImage.png"];
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    [[UIColor blackColor]setStroke];
    [[UIColor whiteColor]setFill];
    
 //   CGContextStrokeRect(UIGraphicsGetCurrentContext(), rect);
    
    if (!self.moreEntries) {
        [img drawInRect:rect];
    //    [[UIColor blackColor]setStroke];
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rect);
    }
    else{
        

         CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(2.0, 2.0), 1.0);
        
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(20, 20,rect.size.width-21,rect.size.height-21 ));
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(20, 20,rect.size.width-21,rect.size.height-21 ));

//        [img drawInRect:CGRectMake(20, 20,rect.size.width-20,rect.size.height-20 )];
        
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(10, 10,rect.size.width-20,rect.size.height-20 ));
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(10, 10,rect.size.width-20,rect.size.height-20 ));
       
//        [img drawInRect:CGRectMake(10, 10,rect.size.width-20,rect.size.height-20 )];
        
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0,rect.size.width-20,rect.size.height-20 ));
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(1, 1,rect.size.width-21,rect.size.height-21 ));
        
        [img drawInRect:CGRectMake(0, 0,rect.size.width-20,rect.size.height-20 )];
    }
    
        
    CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeZero, 0.0, NULL);
    [[UIColor blackColor]setStroke];
    [self.partColor setFill];

    if (zoomLevel ==1) {
        [self.bezierPath fill];
    }
    else{
        
        CGPoint midPt = [self midPoinfOfBezierPath:_bezierPath];
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(ctx, 1.0f);
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetAlpha(ctx, 0.5f);
        //CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
        CGContextFillEllipseInRect(ctx, CGRectMake(midPt.x-2 , midPt.y-2 , 4, 4));
        CGContextSetAlpha(ctx, 1.0f);
        CGContextFillEllipseInRect(ctx, CGRectMake(midPt.x-1, midPt.y-1, 2, 2));
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[self.layer setOpacity:0.5];
    CALayer *maskLayer = [CALayer layer];
    [maskLayer setFrame:self.bounds];
    [maskLayer setBackgroundColor:[[UIColor grayColor]CGColor]];
    [maskLayer setOpacity:0.5f];
    
    [self.layer insertSublayer:maskLayer atIndex:2];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

    //[self.layer setOpacity:1.0];
    CALayer *lay = [self.layer.sublayers objectAtIndex:[self.layer.sublayers count]-1];
    [lay removeFromSuperlayer];
}

/*
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    NSLog(@"Moving");
    NSLog(@"event is %@",[event debugDescription]);
}
*/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

//    NSLog(@"touched me with date %@", self.dateSring);
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:[touch view]];
    
    CALayer *lay = [self.layer.sublayers objectAtIndex:[self.layer.sublayers count]-1];
    [lay removeFromSuperlayer];
    
    if (CGRectContainsPoint(self.bounds, touchLocation)) {
        [self.del daySelectedWas:self.dateSring];
    }
}

-(void)createUIBezierWithOffset:(CGPoint)offsetPoint{

    CGFloat viewWidth = self.bounds.size.width -offsetPoint.x;
    CGFloat viewHeight = self.bounds.size.height - offsetPoint.y;
    
    if (!_bezierPath) {
        
        _bezierPath = [UIBezierPath bezierPath];
        
        if (_pointCount > 2) {
            
            [_bezierPath moveToPoint: CGPointMake(_points[0].x*viewWidth,_points[0].y*viewHeight) ];
//            NSLog(@"moving to point %@", NSStringFromCGPoint(CGPointMake(_points[0].x*viewWidth,_points[0].y*viewHeight)));
            
            for (int i=1; i<_pointCount; i++) {
                
                [_bezierPath addLineToPoint:CGPointMake(_points[i].x*viewWidth ,_points[i].y*viewHeight)];
//                NSLog(@"addling line to point %@", NSStringFromCGPoint(CGPointMake(_points[i].x*viewWidth ,_points[i].y*viewHeight)));
            }
            [_bezierPath closePath];
        }
    }
  //  return _bezierPath;
 
}

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

-(UIColor *)colorfromPain:(int)painLvl{
    
    UIColor *colorToFill = nil;
    
    switch (painLvl) {
        case 0:
            //colorToFill = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.0f];
            break;
        case 1:
            colorToFill = [UIColor colorWithRed:0.99f green:0.71f blue:0.51f alpha:0.9f];
            break;
        case 2:
            colorToFill = [UIColor colorWithRed:0.98f green:0.57f blue:0.26f alpha:0.9f];
            break;
        case 3:
            colorToFill = [UIColor colorWithRed:0.92 green:0.41 blue:0.42 alpha:0.9f];
            break;
        case 4:
            colorToFill = [UIColor colorWithRed:0.95 green:0.15 blue:0.21 alpha:0.9f];
            break;
        case 5:
            colorToFill = [UIColor colorWithRed:0.8 green:0.15 blue:0.24 alpha:0.9f];
            break;
            
        default:
            break;
    }
    
    return colorToFill;
}

@end
