//
//  PainFaceView.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/11/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
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


-(void)handleFaceDrag:(UIPanGestureRecognizer *) gestReco;
-(UIView*)getViewToDragAtTouchLoc:(CGPoint)touchPt;

-(void)putBackPainFace:(UIView *)face;

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

    }
    return self;
}

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
            }
        }
        
        if(gestReco.state == UIGestureRecognizerStateEnded){
            
            CGPoint endTouchLoc = [gestReco locationInView:[gestReco view]];
//            NSLog(@"end drag loc is %@", NSStringFromCGPoint(endTouchLoc));
            NSLog(@"sragging ended");
            
            if (self.viewToDrag) {
            
                [delegate checkForBodyIntersectionWithLocalPoint:endTouchLoc AndPainLvl:self.viewToDrag.tag];

                [self putBackPainFace:self.viewToDrag];
                self.viewToDrag = nil;

            }
        }  
    }
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
    
        CGPoint pointToMove = CGPointMake(10, 4*face.tag + face.bounds.size.height *(face.tag -1));
        
        [face setFrame:CGRectMake(pointToMove.x, pointToMove.y, face.bounds.size.width, face.bounds.size.height)];
        face = nil;
    }
}
#pragma mark -


#pragma mark adjusting the visibility

-(void)reduceVisibility{

    [self.layer setOpacity:0.4];
}
-(void)increaseVisibility{
    [self.layer setOpacity:1.0];
}
#pragma mark -

@end
