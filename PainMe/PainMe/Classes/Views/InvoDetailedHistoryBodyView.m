//
//  InvoDetailedHistoryBodyView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/25/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoDetailedHistoryBodyView.h"

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
        
        if (self.orient ==1) {
            [self createUIBezierWithOffset:CGPointMake(0, 0.0)];
        }else{
            [self createUIBezierWithOffset:CGPointZero];
        }
        
        partName = [obj valueForKey:@"name"];
    
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    UIImage *img = (self.orient ==0)? [UIImage imageNamed:@"Body_Detail.png"] :[UIImage imageNamed:@"zoomout-back-image.png"] ;
    [img drawInRect:rect];
    
    [[UIColor blackColor]setStroke];
    [self.partColor setFill];

    [self.bezierPath fill];
    
    CGPoint midpt = [self midPoinfOfBezierPath:self.bezierPath];
    
    [[UIColor darkGrayColor] setFill];
    CGContextSetAlpha(UIGraphicsGetCurrentContext(), 0.6f);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(midpt.x-30, midpt.y-8, 70, 16));
    CGContextSetAlpha(UIGraphicsGetCurrentContext(), 1.0f);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
    [partName drawInRect: CGRectMake(midpt.x-30, midpt.y-8, 70, 16) withFont:[UIFont fontWithName:@"Helvetica" size:10.0]lineBreakMode:NSLineBreakByTruncatingHead alignment:NSTextAlignmentCenter];
}

- (void) setPointCount: (NSInteger) newPoints {
    
    if (_points) {free(_points);}
    _points = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
    _pointCount = newPoints;
    self.bezierPath = nil;
}

-(void)createUIBezierWithOffset:(CGPoint)offsetPoint{
    
    CGFloat viewWidth = self.bounds.size.width -offsetPoint.x;
    CGFloat viewHeight = self.bounds.size.height - offsetPoint.y;
    
    (self.orient ==1)? (viewHeight = 364) : (viewHeight = viewHeight);
    
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
