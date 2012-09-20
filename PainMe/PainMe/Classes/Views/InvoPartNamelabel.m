//
//  InvoPartNamelabel.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/20/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoPartNamelabel.h"

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
        
        if(NO == [NSString isStringEmpty:partName]){
            
            NSString *labelString = [partName copy];
            [self setBackgroundColor:[UIColor yellowColor]];
            
            UILabel *label = [[UILabel alloc] init];
            [label setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [label setBackgroundColor:[UIColor clearColor]];
            [label setFont:[UIFont fontWithName:@"Helvetica" size:10]];
            [label setLineBreakMode:UILineBreakModeCharacterWrap];
            [label setTextAlignment:UITextAlignmentCenter];
            [label setText:labelString];
            [label setTextColor:[UIColor blackColor]];
            
            [self addSubview:label];
            
        }
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeFromSuperview];
}

@end
