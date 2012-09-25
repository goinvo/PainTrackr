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

}
@property (nonatomic, retain) NSMutableArray *locationArray;
@property (nonatomic, retain) NSString *dateSring;
@property (nonatomic, readwrite)BOOL moreEntries;

@end



@implementation InvoHistoryView

@synthesize del = _del;

- (id)initWithFrame:(CGRect)frame locations:(NSArray *)shapesDict date:(NSString *)stringDate 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        NSLog(@"history view init");
//        NSLog(@"Received dict is %@",shapesDict);
        
        [self setUserInteractionEnabled:YES];
        NSArray *locatArr = [NSArray arrayWithArray:shapesDict];
        
        
        self.dateSring = [stringDate copy];
        self.moreEntries = NO;
        
        if ([locatArr count] > 1) {
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
    UIImage *img = [UIImage imageNamed:@"historyBodyImage.png"];
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    if (!self.moreEntries) {
        [img drawInRect:rect];
        [[UIColor blackColor]setStroke];
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rect);
    }
    else{
        
        [[UIColor blackColor]setStroke];
        [[UIColor whiteColor]setFill];
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
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

//    NSLog(@"touched me with date %@", self.dateSring);
    [self.del daySelectedWas:self.dateSring];
}
 
@end
