//
//  InvoPartNamelabel.h
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/20/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoPartNamelabel : UIView

- (id)initWithFrame:(CGRect)frame name:(NSString *)partName;

@property (nonatomic, strong)NSString *name;

@end
