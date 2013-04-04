//
//  InvoDetailedHistoryBodyView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/25/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoDetailedHistoryBodyView.h"
#import "UIFont+PainTrackrFonts.h"

@interface InvoDetailedHistoryBodyView (){

    CGPoint *_points;
    int zoomLevel;
    NSString *partName;
}

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, strong) UIColor *partColor;

- (id)initWithFrame:(CGRect)frame painDetail:(id)detail;
-(void)createUIBezierWithOffset:(CGPoint)offsetPoint;
-(CGPoint)midPoinfOfBezierPath:(UIBezierPath *)bezier;
-(UIColor *)colorfromPain:(int)painLvl;

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
        self.orient = [[obj valueForKey:@"orientation"] intValue];
        
        NSData *vertices = [obj valueForKey:@"shape"];
        zoomLevel = [[obj valueForKey:@"zoomLevel"] integerValue];
        self.partColor = [self colorfromPain:[[detail valueForKey:@"painLevel"] integerValue]];
        
        int count = ([vertices length])/sizeof(CGPoint);
        
        //set Point Count to calloc enough memory
        [self setPointCount:count];
        // copy bytes to buffer _points
        [vertices getBytes:(CGPoint *)_points length:[vertices length]];
        
        [self createUIBezierWithOffset:CGPointZero];
        
        partName = [obj valueForKey:@"name"];
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
    
    UIImage *img = (self.orient ==0)? [UIImage imageNamed:@"Body_Detail.png"]:
                                      [UIImage imageNamed:@"back_Zout.png"] ;
    
//    NSLog(@"rect is %@", NSStringFromCGRect(rect));
//    NSLog(@"size is %@ with aspect ratio%f", NSStringFromCGSize(img.size), img.size.width/img.size.height);
    
    if(img.size.width/img.size.height !=0.44) NSLog(@"NSLOG new height of img is :%f",img.size.width/0.44);
    if (self.orient == 0) {
        [img drawInRect:rect];
    }
    else{
        float newHeight = rect.size.width/(img.size.width/img.size.height);
        CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - newHeight)*0.5, rect.size.width,newHeight);
        [img drawInRect:newRect];
    }

    
    [[UIColor blackColor]setStroke];
    [self.partColor setFill];
    [self.bezierPath fill];
    
    CGPoint midpt = [self midPoinfOfBezierPath:self.bezierPath];
    
    //creating the rect based on label size
    CGSize labelSize = [partName sizeWithFont:[UIFont bubbleFont]];
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
    
    
    [partName drawInRect:textRect
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
