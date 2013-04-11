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

extern NSString *const FrontView;
extern NSString *const RearView;

typedef enum{

    kTagPartNameBubble = 10
}kTags;


@interface InvoBodySelectionViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate,PainFaceDelegate,MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *flipButton;

- (IBAction)flipTapped:(id)sender;
- (IBAction)clearButtonTapped:(id)sender;

@end
