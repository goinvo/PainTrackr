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

//#import "PainFaceView.h"

#import "PainEntry.h"

@interface InvoBodySelectionViewControllerViewController () {
   
    CGPoint bodyOffset;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet BodyView *bodyView;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;


@property (nonatomic, retain) BodyPartGeometry *bodyGeometry;
@property (nonatomic, retain) PainFaceView *painFace;

-(void)initTapGesture;
-(int)tileAtTouchLocation:(CGPoint)touchPt;
-(UIColor *)colorfromPain:(int)painLvl;

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
    
    self.bodyView.frame = CGRectMake(70,0,BODY_VIEW_WIDTH *1.17, BODY_VIEW_HEIGHT);
    
//    NSLog(@"bodyview frame is %@", NSStringFromCGRect(self.bodyView.frame));
    self.scrollView.minimumZoomScale = 0.024;
    self.scrollView.zoomScale = 0.024;
    self.scrollView.maximumZoomScale = 1.0;
    
// Add the Face button View
    
    self.painFace = [[PainFaceView alloc] init];
    self.painFace.delegate = self;
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
    
    [self.painFace reduceVisibility];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   
    NSLog(@"ScrollView zoom scale is %f", scrollView.zoomScale);
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
//    NSLog(@"bodyview frame is %@", NSStringFromCGRect(self.bodyView.frame));
    
    return self.bodyView;
}

#pragma mark -

#pragma mark PainFaceDel Method

-(void)checkForBodyIntersectionWithLocalPoint:(CGPoint)locPoint AndPainLvl:(int)painLvl{

    CGPoint convPoint = CGPointZero;
    
    convPoint = [self.view convertPoint:locPoint toView:self.scrollView];

    NSLog(@"conv point is %@", NSStringFromCGPoint(convPoint));

    convPoint = CGPointMake((convPoint.x -70)/(BODY_VIEW_WIDTH*self.scrollView.zoomScale),convPoint.y/( BODY_VIEW_HEIGHT*self.scrollView.zoomScale));

// Point is inside the Belly circle  

    if (YES == [self.bodyGeometry containsPoint:convPoint]) {
                
        UIColor *fillcolor = [self colorfromPain:painLvl];
    
        [self.bodyView renderPainForBodyPartPath:self.bodyGeometry.bezierPath WithColor:fillcolor];
        
        NSDate *now = [[NSDate alloc] init];
        
        [PainEntry painEntryWithTime:now Location:self.bodyGeometry.bezierPath  PainLevel:painLvl ExtraNotes:@"NewEntry"];
        
        fillcolor = nil;
        now = nil;
    }
   
}

-(void)changeStrokeWithPoint:(CGPoint)dragPoint painLvl:(int)painLvl{

    CGPoint convPoint = CGPointZero;
    
    convPoint = [self.view convertPoint:dragPoint toView:self.scrollView];
    
    NSLog(@"conv point is %@", NSStringFromCGPoint(convPoint));
    
    convPoint = CGPointMake((convPoint.x -70)/(BODY_VIEW_WIDTH*self.scrollView.zoomScale),convPoint.y/( BODY_VIEW_HEIGHT*self.scrollView.zoomScale));
    
    if (YES == [self.bodyGeometry containsPoint:convPoint] ) {
    
         UIColor *fillcolor = [self colorfromPain:painLvl];
        
        [self.bodyView maskWithColor:fillcolor];
        
     }

}

-(void)blackStrokeForBody{

    [self.bodyView resetStroke];
}

#pragma mark -

#pragma mark color From pain Level

-(UIColor *)colorfromPain:(int)painLvl{

    UIColor *colorToFill;
    
    switch (painLvl) {
        case 1:
            colorToFill = [UIColor colorWithRed:1.00f green:0.89f blue:0.70f alpha:0.9f];
            break;
        case 2:
            colorToFill = [UIColor colorWithRed:0.99f green:0.71f blue:0.51f alpha:0.9f];               
            break;
        case 3:
            colorToFill = [UIColor colorWithRed:0.98f green:0.57f blue:0.26f alpha:0.9f];
            break;
        case 4:
            colorToFill = [UIColor colorWithRed:0.92 green:0.41 blue:0.42 alpha:0.9f];
            break;
        case 5:
            colorToFill = [UIColor colorWithRed:0.95 green:0.15 blue:0.21 alpha:0.9f];
            break;
        case 6:
            colorToFill = [UIColor colorWithRed:0.8 green:0.15 blue:0.24 alpha:0.9f];
            break;
            
        default:
            break;
    }

    return colorToFill;
}

#pragma mark -

@end
