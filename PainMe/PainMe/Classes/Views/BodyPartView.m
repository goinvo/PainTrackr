//
//  BodyPartView.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/2/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "BodyPartView.h"


@implementation BodyPartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithShape:(CGPoint *)pointsArray{

    self = [super init];
    
    if(self){
    
        NSLog(@"Size of points array is %lu",sizeof(pointsArray));
        
        for (int i=0; i<18; i++) {
 
            NSLog(@"value at %d is x:%f y:%f",i,pointsArray[i].x,pointsArray[i].y);
        }

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
