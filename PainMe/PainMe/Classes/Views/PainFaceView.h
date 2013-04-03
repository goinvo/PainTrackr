//
//  PainFaceView.h
//  PainMe
//
//  Created by Dhaval Karwa on 7/11/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{

    kTagFace1=0,
    kTagFace2,
    kTagFace3,
    kTagFace4,
    kTagFace5,
    kTagFace6
}
kFaceTags;

@protocol PainFaceDelegate <NSObject>

-(void)checkForBodyIntersectionWithLocalPoint:(CGPoint)locPoint andPainLvl:(int)painLvl;

-(void)changeStrokeWithPoint:(CGPoint)dragPoint painLvl:(int)painLvl;

-(void)blackStrokeForBody;

@end

@interface PainFaceView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong)UIView *viewToDrag;
@property (nonatomic, assign)id <PainFaceDelegate> delegate;

-(void)reduceVisibility;
-(void)increaseVisibility;
-(void)adPanGesture;
@end
