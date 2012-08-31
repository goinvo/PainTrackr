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

@interface InvoHistoryView ()
@property (nonatomic, retain) NSMutableArray *locationArray;
@property (nonatomic, retain) NSString *dateSring;
@end



@implementation InvoHistoryView

- (id)initWithFrame:(CGRect)frame locations:(NSArray *)shapesDict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"history view init");
        NSLog(@"Received dict is %@",shapesDict);
       // NSDictionary *locatDict = [NSDictionary dictionaryWithDictionary:shapesDict];
        
//        for (PainEntry *obj in [locatDict allValues]) {
//            
//            
//        }
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    NSLog(@"Drawing in History view");
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    UIImage *img = [UIImage imageNamed:@"historyBodyImage.png"];
    [img drawInRect:rect];    
}
 
@end
