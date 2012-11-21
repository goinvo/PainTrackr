//
//  InvoBodySelectionViewControllerViewController.h
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PainFaceView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUi/MFMailComposeViewController.h>

typedef enum{

    kTagPartNameBubble = 10
}kTags;


@interface InvoBodySelectionViewControllerViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate,PainFaceDelegate,MFMailComposeViewControllerDelegate>

- (IBAction)flipTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *flipButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewLabelButton;

@end
