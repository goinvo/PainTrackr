//
//  InvoBodySelectionViewControllerViewController.h
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PainFaceView.h"


@interface InvoBodySelectionViewControllerViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate,PainFaceDelegate>

@property (nonatomic, retain)IBOutlet UILabel *partNameLabel;

@end
