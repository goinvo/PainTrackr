//
//  InvoPartNamelabel.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/20/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoPartNamelabel.h"
#import "UIFont+PainTrackrFonts.h"

@interface NSString (BlankString)

+(BOOL)isStringEmpty:(NSString *)toCheck;

@end



@implementation NSString (BlankString)

+(BOOL)isStringEmpty:(NSString *)toCheck{
    
    if (toCheck){
        
        if([toCheck isEqualToString:@""]){
            
            return YES;
        }
        else return NO;
    }
    
    return YES;
}

@end


@implementation InvoPartNamelabel

- (id)initWithFrame:(CGRect)frame name:(NSString *)partName{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUserInteractionEnabled:YES];
        self.name = [partName copy];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{

    [[UIColor grayColor] setFill];
    UIRectFill(rect);
    
   // [[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] setFill];
    [[UIColor whiteColor]setFill];
    
//    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
    [self.name drawInRect: CGRectMake(0, 3, rect.size.width, rect.size.height)
                 withFont:[UIFont bubbleFont]
            lineBreakMode:NSLineBreakByTruncatingTail
                alignment:NSTextAlignmentCenter];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
}

@end
