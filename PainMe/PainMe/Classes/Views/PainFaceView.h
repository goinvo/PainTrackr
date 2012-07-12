//
//  PainFaceView.h
//  PainMe
//
//  Created by Dhaval Karwa on 7/11/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{

    kTagFace1=1,
    kTagFace2,
    kTagFace3,
    kTagFace4,
    kTagFace5,
    kTagFace6
}
kFaceTags;

@interface PainFaceView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, retain)UIView *viewToDrag;

-(void)reduceVisibility;
-(void)increaseVisibility;
-(void)adPanGesture;
@end
