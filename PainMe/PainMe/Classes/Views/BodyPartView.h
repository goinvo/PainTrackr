//
//  BodyPartView.h
//  PainMe
//
//  Created by Dhaval Karwa on 7/2/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyPartView : UIView

@property (nonatomic, strong) UIBezierPath *partPath;
-(id)initWithShape:(UIBezierPath *)shapePath;

@end
