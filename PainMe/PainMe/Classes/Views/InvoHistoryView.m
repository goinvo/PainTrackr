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
    CGPoint *_points1;
    CGPoint *_points2;
    int zoomLevel1;
    int zoomLevel2;
}

@property (nonatomic, copy) NSString *dateSring;
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, strong) UIBezierPath *bezierPath2;
@property (nonatomic, strong) UIColor *partColor;
@property (nonatomic, strong) UIColor *partColor2;

@property (nonatomic, readonly) NSInteger pointCount;
@property (nonatomic, readonly) NSInteger pointCount2;

@property (nonatomic, assign)int orientation1;
@property (nonatomic, assign)int orientation2;

@property (nonatomic, readwrite)BOOL isBack;
@property (nonatomic, readwrite)BOOL moreEntries;

-(CGPoint)midPoinfOfBezierPath:(UIBezierPath *)bezier;
-(void)setThinsForSecondEntryWith:(id)secondEntry;

@end



@implementation InvoHistoryView

- (void) setPointCount: (NSInteger) newPoints {
    
    if (_points1) {free(_points1);}
    _points1 = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
    _pointCount = newPoints;
    self.bezierPath = [UIBezierPath bezierPath];
}

- (void) setPointCount2: (NSInteger) newPoints {
    
    if (_points2) {free(_points2);}
    _points2 = (CGPoint *)calloc(sizeof(CGPoint), newPoints);
    _pointCount2 = newPoints;
    self.bezierPath2 = [UIBezierPath bezierPath];
}



- (id)initWithFrame:(CGRect)frame locations:(NSArray *)shapesDict date:(NSString *)stringDate 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setUserInteractionEnabled:YES];
        [self setExclusiveTouch:YES];
        
        NSArray *locatArr = [NSArray arrayWithArray:shapesDict];
        self.dateSring = [stringDate copy];
        self.moreEntries = NO;
        self.isBack = NO;
// Getting data from the shapesdict
        
        id obj = [[locatArr objectAtIndex:0] valueForKey:@"location"];
        
        self.orientation1 = [[obj valueForKey:@"orientation"] intValue];
        zoomLevel1 = [[obj valueForKey:@"zoomLevel"] integerValue];
        
//        NSLog(@"pain level is %d",[[[locatArr objectAtIndex:0] valueForKey:@"painLevel"] integerValue]);
        self.partColor = [InvoPainColorHelper colorfromPain:[[[locatArr objectAtIndex:0] valueForKey:@"painLevel"] integerValue]];
        
        NSData *vertices = [obj valueForKey:@"shape"];
        int count = ([vertices length])/sizeof(CGPoint);
        
        //set Point Count to calloc enough memory
        [self setPointCount:count];
        // copy bytes to buffer _points
        [vertices getBytes:(CGPoint *)_points1 length:[vertices length]];
        
        //creating the bezeier1
        [self createShape:1
                 atOffset:CGPointMake(frame.size.width*0.25, 0)
                 withSize:CGSizeMake(frame.size.width,frame.size.height)
              orientation:self.orientation1];
        
        //checking if more than one locations are present
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
    
    CGRect img1Rect = CGRectMake(rect.size.width*0.25, 0,rect.size.width*0.75,rect.size.height);
    CGRect img2Rect = CGRectMake(0, 0,rect.size.width*0.75,rect.size.height);
    UIImage *img1 = [UIImage imageNamed:@"historyBodyImage.png"];
    UIImage *img2 = [UIImage imageNamed:@"historyBodyImage.png"];
   
    if (self.orientation1 ==1) {
        img1 = [UIImage imageNamed:@"zoomout-back-image.png"];
        float newHeight = rect.size.width*0.75/(img1.size.width/img1.size.height);
        img1Rect = CGRectMake(rect.size.width*0.25, (rect.size.height - newHeight)*0.5, rect.size.width*0.75,newHeight);
     
    }
    
    if (self.orientation2 ==1) {
        img2 = [UIImage imageNamed:@"zoomout-back-image.png"];
        float newHeight = rect.size.width*0.75/(img2.size.width/img2.size.height);
        img2Rect = CGRectMake(0, (rect.size.height - newHeight)*0.5, rect.size.width*0.75,newHeight);
    }
        
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    [[UIColor blackColor]setStroke];
    [[UIColor whiteColor]setFill];
    
    if (!self.moreEntries) {
        [img1 drawInRect:img1Rect];
        [self.partColor setFill];
        [self.bezierPath fill];
    }
    else{
   
        [img1 drawInRect:img1Rect];
        
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
  
        [img2 drawInRect:img2Rect];
        
   
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

#pragma mark handling touches
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

#pragma mark midPoint of bezier
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

#pragma mark creating second entry 
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
    [vertices getBytes:(CGPoint *)_points2 length:[vertices length]];
    
    CGRect selfBounds = [self bounds];
    [self createShape:2
             atOffset:CGPointZero
             withSize:CGSizeMake(selfBounds.size.width*0.75, selfBounds.size.height)
          orientation:self.orientation2];
}

-(void)createShape:(int)shapeNum atOffset:(CGPoint)offsetPoint withSize:(CGSize)viewSize orientation:(int)orient{

    CGFloat viewWidth = viewSize.width - offsetPoint.x;
    CGFloat viewHeight = viewSize.height - offsetPoint.y;
 //default shape1
    UIBezierPath *toUse = nil;
    int bezierPoints = 0;
    
    CGPoint *points = _points1;
    toUse = _bezierPath;
    bezierPoints = _pointCount;
    
    if (shapeNum ==2){
        toUse = _bezierPath2;
        bezierPoints = _pointCount2;
        points = _points2;
    }
    
    if ([toUse isEmpty]) {
    
        if (bezierPoints > 2) {
            
            [toUse moveToPoint: CGPointMake(offsetPoint.x + points[0].x*viewWidth,
                                                  points[0].y*viewHeight) ];
            
            for (int i=1; i<bezierPoints; i++) {
                
                [toUse addLineToPoint:CGPointMake(offsetPoint.x +points[i].x*viewWidth ,
                                                        points[i].y*viewHeight)];
            }
            [toUse closePath];
        }
        if (points) {
            free(points);
        }
    }
}

@end
