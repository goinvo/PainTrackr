//
//  InvoHistoryView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/30/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoHistoryView.h"
#import "QuartzCore/QuartzCore.h"
#import "InvoPainColorHelper.h"
#import "PainEntry.h"
#import "PainLocation.h"


@interface InvoHistoryView ()
{
    CGPoint *_points;
    int zoomLevel1;
    int zoomLevel2;

}
//@property (nonatomic, retain) NSMutableArray *locationArray;
@property (nonatomic, retain) NSString *dateSring;
@property (nonatomic, readwrite)BOOL moreEntries;
@property (nonatomic, retain) UIBezierPath *bezierPath;
@property (nonatomic, retain) UIBezierPath *bezierPath2;
@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, readonly) NSInteger pointCount2;
@property (nonatomic, retain) UIColor *partColor;
@property (nonatomic, retain) UIColor *partColor2;
@property (nonatomic, readwrite)BOOL isBack;

-(void)createUIBezierWithOffset:(CGPoint)offsetPoint viewSize:(CGSize)viewSize;
-(void)createUIBezier2WithOffset:(CGPoint)offsetPoint viewSize:(CGSize)viewSize;
-(CGPoint)midPoinfOfBezierPath:(UIBezierPath *)bezier;
-(void)setThinsForSecondEntryWith:(id)secondEntry;

@end



@implementation InvoHistoryView

@synthesize del = _del;

- (void) setPointCount: (NSInteger) newPoints {
    
    if (_points) {free(_points);}
    _points = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
    _pointCount = newPoints;
    self.bezierPath = nil;
}

- (void) setPointCount2: (NSInteger) newPoints {
    
    if (_points) {free(_points);}
    _points = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
    _pointCount2 = newPoints;
    self.bezierPath2 = nil;
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
        self.isBack = NO;
// Getting data from the shapesdict
        
        id obj = [[locatArr objectAtIndex:0] valueForKey:@"location"];
        
        self.orientation1 = [[obj valueForKey:@"orientation"] intValue];
        zoomLevel1 = [[obj valueForKey:@"zoomLevel"] integerValue];
        
        NSLog(@"pain level is %d",[[[locatArr objectAtIndex:0] valueForKey:@"painLevel"] integerValue]);
        self.partColor = [InvoPainColorHelper colorfromPain:[[[locatArr objectAtIndex:0] valueForKey:@"painLevel"] integerValue]];
        
        NSData *vertices = [obj valueForKey:@"shape"];
        int count = ([vertices length])/sizeof(CGPoint);
        
        //set Point Count to calloc enough memory
        [self setPointCount:count];
        // copy bytes to buffer _points
        [vertices getBytes:(CGPoint *)_points length:[vertices length]];

        [self createUIBezierWithOffset:CGPointMake(frame.size.width*0.25, 0) viewSize:CGSizeMake(frame.size.width*0.75,frame.size.height)];
        
        if ([locatArr count] > 1) {
                        
            for (int i=0; i<[locatArr count]; i++) {
                
                PainEntry* obj = [locatArr objectAtIndex:i];
                PainLocation *entryLoc = [obj valueForKey:@"location"];
                
                if (self.orientation1 == 0) {
                    if (entryLoc.orientation == 1 ) {
                        self.isBack = YES;
                        [self setThinsForSecondEntryWith:obj];
                        break;
                    }
                }
                else if (self.orientation1 ==1){
                    if (entryLoc.orientation == 0 ) {
                        //self.isBack = YES;
                        [self setThinsForSecondEntryWith:obj];
                        break;
                    }
                }
            }
            if (!self.bezierPath2) {
                [self setThinsForSecondEntryWith:[locatArr objectAtIndex:1]];
            }
            
            self.moreEntries = YES;
            [self setNeedsDisplay];
        }
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    NSLog(@"Drawing in History view");
    
     UIImage *img1 = (self.orientation1 ==0)? [UIImage imageNamed:@"historyBodyImage.png"]:[UIImage imageNamed:@"zoomout-back-image.png"];
    UIImage *img2 = (self.orientation2 ==0)? [UIImage imageNamed:@"historyBodyImage.png"]:[UIImage imageNamed:@"zoomout-back-image.png"];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    [[UIColor blackColor]setStroke];
    [[UIColor whiteColor]setFill];
    
    if (!self.moreEntries) {
   
//        [img1 drawInRect:CGRectMake(5, 5, rect.size.width-10, rect.size.height-10)];
        [img1 drawInRect:CGRectMake(rect.size.width*0.25, 0,rect.size.width*0.75,rect.size.height) ];
        [self.partColor setFill];
        [self.bezierPath fill];
//       CGContextStrokeRect(UIGraphicsGetCurrentContext(), rect);
    }
    else{
        
//         CGContextSetShadow(UIGraphicsGetCurrentContext(), CGSizeMake(2.0, 2.0), 1.0);
        
//        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(20, 20,rect.size.width-21,rect.size.height-21 ));
//        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(20, 20,rect.size.width-21,rect.size.height-21 ));

//        [img drawInRect:CGRectMake(20, 20,rect.size.width-20,rect.size.height-20 )];
        
//        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(10, 10,rect.size.width-20,rect.size.height-20 ));
//        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(10, 10,rect.size.width-20,rect.size.height-20 ));
       
//        [img drawInRect:CGRectMake(10, 10,rect.size.width-20,rect.size.height-20 )];
        
//        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0,rect.size.width-20,rect.size.height-20 ));
//        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(1, 1,rect.size.width-21,rect.size.height-21 ));
       
   
        [img1 drawInRect:CGRectMake(rect.size.width*0.25, 0,rect.size.width*0.75,rect.size.height)];
        
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeZero, 0.0, NULL);
        [[UIColor blackColor]setStroke];
        [self.partColor setFill];
        
        if (zoomLevel1 ==1) {
            [self.bezierPath fill];
        }
        else{
            
            CGPoint midPt = [self midPoinfOfBezierPath:_bezierPath];
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextSetLineWidth(ctx, 1.0f);
            CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
            CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
            CGContextSetAlpha(ctx, 0.5f);
           // CGContextSetBlendMode(ctx, kCGBlendModeSourceAtop);
            CGContextFillEllipseInRect(ctx, CGRectMake(midPt.x-2 , midPt.y-2 , 4, 4));
            CGContextSetAlpha(ctx, 1.0f);
            CGContextFillEllipseInRect(ctx, CGRectMake(midPt.x-1, midPt.y-1, 2, 2));
        }

       [[UIColor whiteColor] setFill];
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0,rect.size.width*0.5,rect.size.height ));
  
        [img2 drawInRect:CGRectMake(0, 0,rect.size.width*0.75,rect.size.height )];
        
   
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeZero, 0.0, NULL);
        [[UIColor blackColor]setStroke];
        [self.partColor2 setFill];
        
        if (zoomLevel2 ==1) {
            [self.bezierPath2 fill];
        }
        else{
            
            CGPoint midPt = [self midPoinfOfBezierPath:_bezierPath2];
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

-(void)createUIBezierWithOffset:(CGPoint)offsetPoint viewSize:(CGSize)viewSize{

    CGFloat viewWidth = self.bounds.size.width -offsetPoint.x;
    CGFloat viewHeight = self.bounds.size.height - offsetPoint.y;
    
    if (!_bezierPath) {
        
        _bezierPath = [UIBezierPath bezierPath];
        
        if (_pointCount > 2) {
            
            [_bezierPath moveToPoint: CGPointMake(offsetPoint.x + _points[0].x*viewWidth,_points[0].y*viewHeight) ];
            
            for (int i=1; i<_pointCount; i++) {
                
                [_bezierPath addLineToPoint:CGPointMake(offsetPoint.x +_points[i].x*viewWidth ,_points[i].y*viewHeight)];
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

-(void)setThinsForSecondEntryWith:(id)secondEntry{
    //id obj = [secondEntry  valueForKey:@"location"];
    
    id loca = (PainLocation *)[secondEntry valueForKey:@"location"];
    
    self.orientation2 = [[loca valueForKey:@"orientation"] intValue];
    zoomLevel2 = [[loca valueForKey:@"zoomLevel"] integerValue];
    
    self.partColor2 = [InvoPainColorHelper colorfromPain:[[secondEntry valueForKey:@"painLevel"] integerValue]];
    
    NSData *vertices = [loca valueForKey:@"shape"];
    int count = ([vertices length])/sizeof(CGPoint);
    
    //set Point Count to calloc enough memory
    [self setPointCount2:count];
    // copy bytes to buffer _points
    [vertices getBytes:(CGPoint *)_points length:[vertices length]];
    
    CGRect selfBounds = [self bounds];
    [self createUIBezier2WithOffset:CGPointMake(0, 0) viewSize:CGSizeMake(selfBounds.size.width*0.75, selfBounds.size.height)];
}

-(void)createUIBezier2WithOffset:(CGPoint)offsetPoint viewSize:(CGSize)viewSize{
    
    CGFloat viewWidth = self.bounds.size.width -offsetPoint.x;
    CGFloat viewHeight = self.bounds.size.height - offsetPoint.y;
    
    if (!_bezierPath2) {
        
        _bezierPath2 = [UIBezierPath bezierPath];
        
        if (_pointCount2 > 2) {
            
            [_bezierPath2 moveToPoint: CGPointMake(offsetPoint.x +_points[0].x*viewSize.width,_points[0].y*viewHeight) ];
            
            for (int i=1; i<_pointCount2; i++) {
                
                [_bezierPath2 addLineToPoint:CGPointMake(offsetPoint.x +_points[i].x*viewSize.width ,_points[i].y*viewHeight)];
            }
            [_bezierPath2 closePath];
        }
    }
}

@end
