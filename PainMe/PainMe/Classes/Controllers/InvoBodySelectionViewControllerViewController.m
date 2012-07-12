//
//  InvoBodySelectionViewControllerViewController.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "InvoBodySelectionViewControllerViewController.h"
#import "BodyView.h"
//#import "BodyPartView.h"
#import "BodyPartGeometry.h"

#import "PainFaceView.h"

@interface InvoBodySelectionViewControllerViewController () {
   
    CGPoint bodyOffset;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet BodyView *bodyView;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
//@property (nonatomic, retain) BodyPartView *bodyPartView;
@property (nonatomic, retain) BodyPartGeometry *bodyGeometry;
@property (nonatomic, retain) PainFaceView *painFace;

-(void)initTapGesture;
-(int)tileAtTouchLocation:(CGPoint)touchPt;

@end

@implementation InvoBodySelectionViewControllerViewController

@synthesize scrollView = _scrollView, bodyView = _bodyView;
@synthesize tapGesture = _tapGesture;
//@synthesize bodyPartView = _bodyPartView;
@synthesize bodyGeometry = _bodyGeometry;
@synthesize painFace = _painFace;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bodyOffset = CGPointZero;

    self.scrollView.contentSize = CGSizeMake(BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT );
    self.scrollView.backgroundColor = [UIColor clearColor];
    
   self.bodyView.frame = CGRectMake(0,0,BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT);
    self.scrollView.minimumZoomScale = 0.0265;
//    self.scrollView.zoomScale = 0.25;
    self.scrollView.zoomScale = 0.0265;
    self.scrollView.maximumZoomScale = 1.0;
    
    if (self.scrollView.zoomScale < 0.4) {
        
        self.scrollView.frame = CGRectMake(50, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }


// Add the Face button View
    
    self.painFace = [[PainFaceView alloc] init];
    [self.view insertSubview:self.painFace atIndex:10];
   
//Init TapGesture Recognizer    
    [self initTapGesture];
    
    self.bodyGeometry = [[BodyPartGeometry alloc] init];
    
}

-(void)initTapGesture{

    self.tapGesture   =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:self.tapGesture];
    [self.tapGesture setCancelsTouchesInView:NO];
}

// button handler:
// set new pain level
// [bodyView setNeedsDisplayInRect: ...]

#pragma mark Handle Tap Gesture

-(void)handleTapGesture:(UITapGestureRecognizer *)gestureReco{

    CGPoint touchLocation = [gestureReco locationInView:self.scrollView];
    NSLog(@"Tapped inside scrollView at x:%f y:%f",touchLocation.x, touchLocation.y);
    
    int tileNum = [self tileAtTouchLocation:touchLocation];
    NSLog(@"Tile which was tapped was %d",tileNum);

    bodyOffset = CGPointMake(touchLocation.x/(BODY_VIEW_WIDTH*self.scrollView.zoomScale),touchLocation.y/( BODY_VIEW_HEIGHT*self.scrollView.zoomScale));
    
    NSLog(@"The point with Respect to Global body Coordinates is x:%f y:%f",bodyOffset.x,bodyOffset.y);

// Point is inside the Belly circle  

    if (YES == [self.bodyGeometry containsPoint:bodyOffset]) {
        
        [self.bodyView renderPainForBodyPartPath:self.bodyGeometry.bezierPath];
        
        // create new pain entry
        // bring up buttons for pain entry
        // set new pain entry to instance variable
        
        
/*
        if (self.bodyPartView) {
            [self.bodyPartView removeFromSuperview];    
            self.bodyPartView = nil;
            return;
        }
        
        self.bodyPartView = [[BodyPartView alloc] initWithShape:self.bodyGeometry.bezierPath];
        
//        [self.bodyPartView setFrame:self.bodyView.frame];
          [self.bodyPartView setFrame:CGRectMake(0, 0, 1024*8, 1024*8)];
        
        [self.bodyView insertSubview:self.bodyPartView atIndex:1];
 */
    }
    
}

-(int)tileAtTouchLocation:(CGPoint)touchPt{

    float scrollZoom = self.scrollView.zoomScale;
    
    int divideNum = 1024*scrollZoom;
    CGPoint location = touchPt;
    
    float row = (location.y/divideNum);
    
//    NSLog(@"touched image at y:%.1f",(row - (int)row));
    
//    NSLog(@"Row is :%f",floorf(ceilf(row)));
    row = floorf(ceilf(row));
    
    float column = (location.x/divideNum);
    
//    NSLog(@"touched image at x:%.1f",(column - (int)column));

//     NSLog(@"Column is :%f",floorf(ceilf(column)));
    column = floorf(ceilf(column));
    
    int numtoRet = (column <= 7 && row >=2)? (8*(row-1) + column): (row * column) ;
    
//    CGFloat bodyOffsetX = touchPt.x/(divideNum*BODY_TILE_COLUMNS);
//    CGFloat bodyOffsetY = touchPt.y/(divideNum*BODY_TILE_ROWS);
    
//    NSLog(@"Body Offset Location x:%0.2f",touchPt.x/(divideNum*BODY_TILE_COLUMNS));
//    NSLog(@"Body Offset Location y:%0.2f",touchPt.y/(divideNum*BODY_TILE_ROWS));

//Setting the offset of body based on the touch(Tap) onto the body    
//    bodyOffset = CGPointMake(bodyOffsetX, bodyOffsetY);
    
    return (numtoRet);
}
#pragma mark-

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
 
    [self.painFace increaseVisibility];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
   
    NSLog(@"Scale is %f",scale);
    
    if (self.scrollView.zoomScale < 0.4) {
        
        self.scrollView.frame = CGRectMake(50, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    else {
        self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
    
    [self.painFace increaseVisibility];

}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
   
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
   return YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   
    [self.painFace reduceVisibility];
    
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
   
     NSLog(@"Scale while beginning zooming is %f",scrollView.zoomScale);

    if (scrollView.zoomScale <=0.04  ) {
        scrollView.zoomScale = 0.04;
    }
   
    self.scrollView.frame = CGRectMake(0, self.scrollView.frame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    
    [self.painFace reduceVisibility];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   
    NSLog(@"ScrollView zoom scale is %f", scrollView.zoomScale);
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    

    return self.bodyView;
}


@end
