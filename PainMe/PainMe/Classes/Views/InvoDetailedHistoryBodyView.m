//
//  InvoDetailedHistoryBodyView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/25/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoDetailedHistoryBodyView.h"
#import "UIFont+PainTrackrFonts.h"
#import "UIColor+PainColor.h"
@interface InvoDetailedHistoryBodyView (){

    CGPoint *_points;
    int zoomLevel;
}

@property (nonatomic, copy) NSString *partName;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, strong) UIColor *partColor;

- (id)initWithFrame:(CGRect)frame painDetail:(id)detail;
-(void)createUIBezierWithOffset:(CGPoint)offsetPoint;
-(CGPoint)midPoinfOfBezierPath:(UIBezierPath *)bezier;

@end

@implementation InvoDetailedHistoryBodyView

+(InvoDetailedHistoryBodyView *)detailedBodyViewWithFrame :(CGRect)frame PainDetails:(id)details{

    return [[self alloc] initWithFrame:frame painDetail:details];
}


- (id)initWithFrame:(CGRect)frame painDetail:(id)detail
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:NO];
        
        id obj = [detail valueForKey:@"location"];
        _orient = [[obj valueForKey:@"orientation"] intValue];
        
        NSData *vertices = [obj valueForKey:@"shape"];
        zoomLevel = [[obj valueForKey:@"zoomLevel"] integerValue];
        self.partColor = [UIColor colorfromPain:[[detail valueForKey:@"painLevel"] integerValue]];
        
        int count = ([vertices length])/sizeof(CGPoint);
        
        //set Point Count to calloc enough memory
        [self setPointCount:count];
        // copy bytes to buffer _points
        [vertices getBytes:(CGPoint *)_points length:[vertices length]];
        
        [self createUIBezierWithOffset:CGPointZero];
        
        _partName = [obj valueForKey:@"name"];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctxRef = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    NSString *imgNameToUse = nil;
    CGRect drawingRect = CGRectZero;
   
    //choosing right image and rect to use for drawing
    switch (self.orient) {
        case 0:
            imgNameToUse = (zoomLevel ==1)?@"Body_Detail.png" : @"Front_Zin.png";
            drawingRect = rect;	
            break;
        case 1:
            imgNameToUse = (zoomLevel ==1)?@"back_Zout.png" : @"back_Zin.png";
            UIImage *tmpImg =  [UIImage imageNamed:imgNameToUse];
            float newHeight = rect.size.width/(tmpImg.size.width/tmpImg.size.height);
             drawingRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - newHeight)*0.5, rect.size.width,newHeight);
            break;
    }
    UIImage *img =  [UIImage imageNamed:imgNameToUse];
    
    [img drawInRect:drawingRect];
    
    [[UIColor blackColor]setStroke];
    [self.partColor setFill];
    [_bezierPath fill];
    
    CGPoint midpt = [self midPoinfOfBezierPath:self.bezierPath];
    
    //creating the rect based on label size
    CGSize labelSize = [_partName sizeWithFont:[UIFont bubbleFont]];
    CGRect textRect = CGRectMake(midpt.x-labelSize.width*0.5, midpt.y-labelSize.height*0.5, labelSize.width+10, labelSize.height);
  
    //positioning the label properly within the bounds of the view
    if ((textRect.origin.x + textRect.size.width) > rect.size.width) {
        textRect.origin.x -= ((textRect.origin.x + textRect.size.width) - rect.size.width);
    }else if (textRect.origin.x < 0){
        textRect.origin.x = 1.0;
    }
    
    if ((textRect.origin.y + textRect.size.height) > rect.size.height) {
        textRect.origin.y -= ((textRect.origin.y + textRect.size.height) - rect.size.height);
    }
    
    [[UIColor darkGrayColor] setFill];
    CGPathRef roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:textRect cornerRadius:4.0f].CGPath;
    CGContextSetAlpha(ctxRef, 0.6f);
    CGContextAddPath(ctxRef, roundedRectPath);
    CGContextFillPath(ctxRef);
    
    CGContextSetAlpha(ctxRef, 1.0f);
    CGContextSetFillColorWithColor(ctxRef, [UIColor whiteColor].CGColor);
    
    [_partName drawInRect:textRect
                withFont:[UIFont bubbleFont]
           lineBreakMode:NSLineBreakByTruncatingHead
               alignment:NSTextAlignmentCenter];
}

- (void) setPointCount: (NSInteger) newPoints {
    
    if (_points) {free(_points);}
    _points = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
    _pointCount = newPoints;
    self.bezierPath = nil;
}

-(void)createUIBezierWithOffset:(CGPoint)offsetPoint{
    
    CGFloat viewWidth = self.bounds.size.width -offsetPoint.x;
    CGFloat viewHeight = self.bounds.size.height ;
    
    if (!_bezierPath) {
        
        _bezierPath = [UIBezierPath bezierPath];
        
        if (_pointCount > 2) {
            
            [_bezierPath moveToPoint: CGPointMake(_points[0].x*viewWidth,_points[0].y*viewHeight) ];
                        
            for (int i=1; i<_pointCount; i++) {
                
                [_bezierPath addLineToPoint:CGPointMake(_points[i].x*viewWidth ,_points[i].y*viewHeight)];
            }
            [_bezierPath closePath];
        }
    }
    
    if (_points) {
        free(_points);
    }
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

@end
