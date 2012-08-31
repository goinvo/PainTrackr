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

@property (nonatomic, retain)UIView *f1;
@property (nonatomic, retain)UIView *f2;
@property (nonatomic, retain)UIView *f3;
@property (nonatomic, retain)UIView *f4;
@property (nonatomic, retain)UIView *f5;
@property (nonatomic, retain)UIView *f6;

@property (nonatomic, readwrite)BOOL shouldGetTouch;

-(void)handleFaceDrag:(UIPanGestureRecognizer *) gestReco;
-(UIView*)getViewToDragAtTouchLoc:(CGPoint)touchPt;

-(void)putBackPainFace:(UIView *)face;

-(void)addLabels;

@property (nonatomic, retain)UIPanGestureRecognizer *dragGesture;
@end

@implementation PainFaceView

@synthesize f1 =_f1, f2 =_f2, f3 =_f3, f4 =_f4, f5 =_f5, f6 =_f6;

@synthesize viewToDrag;

@synthesize dragGesture = _dragGesture;

@synthesize delegate;

-(id)init{

    if (self = [super initWithFrame:CGRectMake(0, 0, 55, 480)]) {
        
        [self setUserInteractionEnabled:YES];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        //add gesture
        [self adPanGesture];
        
        // Adding face views
        self.f1= [[UIView alloc]init];
        UIImage *img = [UIImage imageNamed:@"F1.png"];
        [self.f1 setBackgroundColor:[UIColor colorWithPatternImage:img]];
        [self.f1 setFrame:CGRectMake(10, 5, img.size.width, img.size.height)];
        self.f1.tag = kTagFace1;
        [self addSubview:self.f1];
                
        self.f2= [[UIView alloc]init];
        img = [UIImage imageNamed:@"F2.png"];
        [self.f2 setBackgroundColor:[UIColor colorWithPatternImage:img]];
        [self.f2 setFrame:CGRectMake(10, ((4*2)+img.size.height), img.size.width, img.size.height)];
        self.f2.tag = kTagFace2;
        [self addSubview:self.f2];
        
        self.f3= [[UIView alloc]init];
        img = [UIImage imageNamed:@"F3.png"];
        [self.f3 setBackgroundColor:[UIColor colorWithPatternImage:img]];
        [self.f3 setFrame:CGRectMake(10, ((4*3)+img.size.height*2), img.size.width, img.size.height)];
        self.f3.tag = kTagFace3;
        [self addSubview:self.f3];

        self.f4= [[UIView alloc]init];
        img = [UIImage imageNamed:@"F4.png"];
        [self.f4 setBackgroundColor:[UIColor colorWithPatternImage:img]];
        [self.f4 setFrame:CGRectMake(10, ((4*4)+img.size.height*3), img.size.width, img.size.height)];
        self.f4.tag = kTagFace4;
        [self addSubview:self.f4];
        
        self.f5= [[UIView alloc]init];
        img = [UIImage imageNamed:@"F5.png"];
        [self.f5 setBackgroundColor:[UIColor colorWithPatternImage:img]];
        [self.f5 setFrame:CGRectMake(10, ((4*5)+img.size.height*4), img.size.width, img.size.height)];
        self.f5.tag = kTagFace5;
        [self addSubview:self.f5];
        
        self.f6= [[UIView alloc]init];
        img = [UIImage imageNamed:@"F6.png"];
        [self.f6 setBackgroundColor:[UIColor colorWithPatternImage:img]];
        [self.f6 setFrame:CGRectMake(10, ((4*6)+img.size.height*5), img.size.width, img.size.height)];
        self.f6.tag = kTagFace6;
        [self addSubview:self.f6];
        
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
            
            NSLog(@"sragging strted");
            
            CGPoint strtTouchLoc = [gestReco locationInView:self];
//            NSLog(@"Strt drag loc is %@", NSStringFromCGPoint(strtTouchLoc));
            
            self.viewToDrag = [self getViewToDragAtTouchLoc:strtTouchLoc];
        }
        
        if (gestReco.state== UIGestureRecognizerStateChanged) {
            
//            NSLog(@"view State changed");
            
            if (self.viewToDrag) {
                newPoint = [gestReco translationInView:self];
  //              NSLog(@"new Point is %@", NSStringFromCGPoint(newPoint));
                
//                NSLog(@"view to drag curr frame origin is %@",NSStringFromCGPoint(self.viewToDrag.frame.origin));
                
                CGPoint newFacePt = CGPointMake(self.viewToDrag.frame.origin.x + newPoint.x, self.viewToDrag.frame.origin.y +newPoint.y);
  
//                NSLog(@"newFacePt is %@", NSStringFromCGPoint(newFacePt));
                
                [self.viewToDrag setFrame:CGRectMake(newFacePt.x, newFacePt.y, self.viewToDrag.frame.size.width, self.viewToDrag.frame.size.height)];
            
                [gestReco setTranslation:CGPointZero inView:self];
                newFacePt = CGPointZero;
                
                [delegate changeStrokeWithPoint:[gestReco locationInView:[gestReco view]] painLvl:self.viewToDrag.tag];
            }
        }
        
        if(gestReco.state == UIGestureRecognizerStateEnded){
            
            CGPoint endTouchLoc = [gestReco locationInView:[gestReco view]];

            NSLog(@"dragging ended");
            
            if (self.viewToDrag) {
            
                [delegate checkForBodyIntersectionWithLocalPoint:endTouchLoc andPainLvl:self.viewToDrag.tag];

                [self putBackPainFace:self.viewToDrag];
                self.viewToDrag = nil;

                [delegate blackStrokeForBody];
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

    NSLog(@"Touch Pt is %@", NSStringFromCGPoint(touchPt));
    
    for (UIView *view in self.subviews) {

//        NSLog(@"view frame is %@", NSStringFromCGRect(view.frame));

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
