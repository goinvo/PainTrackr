//
//  InvoHistoryView.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/30/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoHistoryView.h"
#import "QuartzCore/QuartzCore.h"
#import "PainEntry.h"
#import "PainLocation.h"

@interface InvoHistoryView ()
@property (nonatomic, retain) NSMutableArray *locationArray;
@property (nonatomic, retain) NSString *dateSring;
@property (nonatomic, readwrite)BOOL moreEntries;
@end



@implementation InvoHistoryView

- (id)initWithFrame:(CGRect)frame locations:(NSArray *)shapesDict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        NSLog(@"history view init");
//        NSLog(@"Received dict is %@",shapesDict);
        NSArray *locatArr = [NSArray arrayWithArray:shapesDict];
        self.moreEntries = NO;
        
        int i=0;
        for (PainEntry *obj in locatArr) {
            PainLocation *pLoc = (PainLocation *)[obj valueForKey:@"location"];
            NSLog(@"%@",pLoc.name);
            i++;
        }
        
        if (i>1) {
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
    NSLog(@"Drawing in History view");
    UIImage *img = [UIImage imageNamed:@"historyBodyImage.png"];
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    if (!self.moreEntries) {
        [img drawInRect:rect];
        [[UIColor blackColor]setStroke];
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), rect);
    }
    else{
    
        [img drawInRect:CGRectMake(0, 0, rect.size.width -10, rect.size.height)];
        [[UIColor blackColor]setStroke];
        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, rect.size.width -10, rect.size.height));

        CGContextStrokeRect(UIGraphicsGetCurrentContext(), CGRectMake(rect.size.width -10, 5,10, rect.size.height-10));
    }

}
 
@end
