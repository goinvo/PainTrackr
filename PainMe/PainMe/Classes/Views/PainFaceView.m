//
//  PainFaceView.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/11/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "PainFaceView.h"
#import <QuartzCore/QuartzCore.h>

@interface PainFaceView ()

@property (nonatomic, weak)UIView *f1;
@property (nonatomic, weak)UIView *f2;
@property (nonatomic, weak)UIView *f3;
@property (nonatomic, weak)UIView *f4;
@property (nonatomic, weak)UIView *f5;
@property (nonatomic, weak)UIView *f6;

@property (nonatomic, readwrite)BOOL shouldGetTouch;

-(void)handleFaceDrag:(UIPanGestureRecognizer *) gestReco;
-(UIView*)getViewToDragAtTouchLoc:(CGPoint)touchPt;
-(void)putBackPainFace:(UIView *)face;
-(void)addLabels;

@property (nonatomic, strong)UIPanGestureRecognizer *dragGesture;
@end

@implementation PainFaceView

-(id)init{

    if (self = [super initWithFrame:CGRectMake(0, 0, 55, 420)]) {
        
        [self setUserInteractionEnabled:YES];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        //add gesture
        [self adPanGesture];
        
        // Adding face views
        
        NSMutableString *name =nil;
        for (int i=1; i<=6; i++) {
            UIView *view = [[UIView alloc]init];
            name = [NSString stringWithFormat:@"F%d.png",i];
            UIImage *img = [UIImage imageNamed:name];
            name = nil;
            [view setBackgroundColor:[UIColor colorWithPatternImage:img]];
            [view setFrame:CGRectMake(10, 5+(4+img.size.height)*(i-1), img.size.width, img.size.height)];
            [self addSubview:view];
            
            switch (i) {
                case 1:
                    _f1 = view;
                    _f1.tag = kTagFace1;
                    break;
                case 2:
                    _f2 = view;
                    _f2.tag = kTagFace2;
                    break;
                case 3:
                    _f3 = view;
                    _f3.tag = kTagFace3;
                    break;
                case 4:
                    _f4 = view;
                    _f4.tag = kTagFace4;
                    break;
                case 5:
                    _f5 = view;
                    _f5.tag = kTagFace5;
                    break;
                case 6:
                    _f6 = view;
                    _f6.tag = kTagFace6;
                    break;
            }
        }
        
        self.viewToDrag = [[UIView alloc] init];
        self.shouldGetTouch = YES;

        [self addLabels];
    }
    return self;
}
#pragma mark addLabels

-(void)addLabels{

    float width = self.f1.frame.size.width;
    float height = self.f1.frame.size.height;
    
    for (int i=0; i<6; i++) {

        UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(width*0.5 -12 , height-12, 25, 10)];
        
        (i==0)?[l1 setText:@"0"]:[l1 setText:[NSString stringWithFormat:@"%d - %d",(i*2 -1),i*2]];
        
        [l1 setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
        
        [l1 setTextAlignment:UITextAlignmentCenter];
        [l1 setFont:[UIFont fontWithName:@"Helvetica" size:9]];
        
        for(UIView *view in self.subviews){
        
            if (view.tag == i) {
                [view addSubview:l1];
                break;
            }
        }
    }
}
#pragma mark -

#pragma mark touches

-(void)adPanGesture{

    self.dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleFaceDrag:)];
    self.dragGesture.minimumNumberOfTouches = 1;
    self.dragGesture.maximumNumberOfTouches = 1;
    self.dragGesture.delegate = self;
    
    [self addGestureRecognizer:self.dragGesture];
    
}

-(void)handleFaceDrag:(UIPanGestureRecognizer *) gestReco{

    if ([gestReco isKindOfClass:[UIPanGestureRecognizer class]]) {
            
        CGPoint newPoint = CGPointZero;
        
       if (gestReco.state == UIGestureRecognizerStateBegan) {
            
//            NSLog(@"sragging strted");
            
            CGPoint strtTouchLoc = [gestReco locationInView:self];
//            NSLog(@"Strt drag loc is %@", NSStringFromCGPoint(strtTouchLoc));
            
            self.viewToDrag = [self getViewToDragAtTouchLoc:strtTouchLoc];
        }
        
        if (gestReco.state== UIGestureRecognizerStateChanged) {
            
//            NSLog(@"view State changed");
            
            if (self.viewToDrag) {
                newPoint = [gestReco translationInView:self];
                
                CGPoint newFacePt = CGPointMake(self.viewToDrag.frame.origin.x + newPoint.x, self.viewToDrag.frame.origin.y +newPoint.y);
                
                [self.viewToDrag setFrame:CGRectMake(newFacePt.x, newFacePt.y, self.viewToDrag.frame.size.width, self.viewToDrag.frame.size.height)];
            
                if (newFacePt.x >55) {
                    [self.delegate changeStrokeWithPoint:[gestReco locationInView:[gestReco view]] painLvl:self.viewToDrag.tag];
                }
                
                [gestReco setTranslation:CGPointZero inView:self];
                newFacePt = CGPointZero;

            }
        }
        
        if(gestReco.state == UIGestureRecognizerStateEnded){
            
            CGPoint endTouchLoc = [gestReco locationInView:[gestReco view]];
            
            if (self.viewToDrag) {
            
                if(endTouchLoc.x >55){
                    [self.delegate checkForBodyIntersectionWithLocalPoint:endTouchLoc andPainLvl:self.viewToDrag.tag];
                }

                [self putBackPainFace:self.viewToDrag];
                self.viewToDrag = nil;

                [self.delegate blackStrokeForBody];
            }
        }  
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if (self.shouldGetTouch && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}
#pragma mark -

#pragma mark view to drag
-(UIView*)getViewToDragAtTouchLoc:(CGPoint)touchPt{

//    NSLog(@"Touch Pt is %@", NSStringFromCGPoint(touchPt));
    
    for (UIView *view in self.subviews) {

        if (CGRectContainsPoint(view.frame, touchPt)) {
            return view;
            break;
        }
    }
    
    return nil;
}
#pragma mark -

#pragma mark put face back

-(void)putBackPainFace:(UIView *)face{

    if (face) {
    
        CGPoint pointToMove = CGPointMake(10, 4*face.tag + face.bounds.size.height *(face.tag ));
        
        [face setFrame:CGRectMake(pointToMove.x, pointToMove.y, face.bounds.size.width, face.bounds.size.height)];
        face = nil;
    }
}
#pragma mark -


#pragma mark adjusting the visibility

-(void)reduceVisibility{

    [self.layer setOpacity:0.4];
    self.shouldGetTouch = NO;
}
-(void)increaseVisibility{
    [self.layer setOpacity:1.0];
    self.shouldGetTouch = YES;
}
#pragma mark -

@end
