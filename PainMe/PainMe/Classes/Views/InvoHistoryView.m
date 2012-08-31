//
//  InvoHistoryView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/30/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoHistoryView.h"
#import "QuartzCore/QuartzCore.h"

@implementation InvoHistoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
           NSLog(@"history view init");
        [self bodyToReturn];
        [self.layer setBackgroundColor:[UIColor yellowColor].CGColor];
       
    }
    return self;
}

- (UIImage*)tileAtCol:(int)col row:(int)row withScale:(CGFloat)scale
{
    UIImage *image;
        
    if (col>= 0 && col < 4 && row >= 0 && row < 9) {
        
        NSString *filename;
            
        filename = [NSString stringWithFormat:@"untitled-1_%02d.png", (col+1) + (row) * 4];
        NSLog(@"file name is %@",filename);
        NSString *path = [[NSBundle mainBundle] pathForResource: filename ofType: nil];
                
        image = [UIImage imageWithContentsOfFile:path];
    
        return image;
    }
    else {
        return nil;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
*/
-(void )bodyToReturn{

    UIGraphicsBeginImageContext(CGSizeMake(60, 108));
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 4.0f);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor yellowColor].CGColor);
//    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
//    CGContextFillEllipseInRect(ctx, CGRectMake(0, 0, 40, 50));

    CGSize tileSize = (CGSize){15, 12};
    
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 4; col++) {
            
            UIImage *tile = [self tileAtCol:col row:row withScale:0.0624];
            
            if (tile) {
                
                CGRect tileRect;
                
                tileRect = CGRectMake(tileSize.width * col,
                                      tileSize.height * row,
                                      tileSize.width, tileSize.height);
                
                [tile drawInRect:tileRect];
            }
        }
    }
    
    [[UIColor blackColor] set];
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokeRect(ctx, CGRectMake(0, 0, 60, 108));
    
    self.imgRet = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"imgRet bounds are %f",self.imgRet.size.width);
    UIGraphicsEndImageContext();
}
@end
