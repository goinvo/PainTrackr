//
//  InvoBodySelectionViewControllerViewController.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "InvoBodySelectionViewControllerViewController.h"
#import "BodyView.h"
#import "BodyPartView.h"
#import "BodyPartGeometry.h"

@interface InvoBodySelectionViewControllerViewController () {
   
    CGPoint bodyOffset;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet BodyView *bodyView;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;
@property (nonatomic, retain) BodyPartView *bodyPartView;
@property (nonatomic, retain) BodyPartGeometry *bodyGeometry;


-(void)initTapGesture;
-(int)tileAtTouchLocation:(CGPoint)touchPt;

@end

@implementation InvoBodySelectionViewControllerViewController

@synthesize scrollView = _scrollView, bodyView = _bodyView;
@synthesize tapGesture = _tapGesture;
@synthesize bodyPartView = _bodyPartView;
@synthesize bodyGeometry = _bodyGeometry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bodyOffset = CGPointZero;
    self.scrollView.zoomScale = 0.25;

    self.scrollView.contentSize = CGSizeMake(BODY_VIEW_WIDTH *self.scrollView.zoomScale, BODY_VIEW_HEIGHT *self.scrollView.zoomScale);
   
   self.bodyView.frame = CGRectMake(0,0,BODY_VIEW_WIDTH*self.scrollView.zoomScale, BODY_VIEW_HEIGHT*self.scrollView.zoomScale);
    
//Init TapGesture Recognizer    
    [self initTapGesture];
    
    self.bodyGeometry = [[BodyPartGeometry alloc] init];
    
}

-(void)initTapGesture{

    self.tapGesture   =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:self.tapGesture];
}

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
        
        self.bodyPartView = nil;
    
        self.bodyPartView = [[BodyPartView alloc] initWithShape:self.bodyGeometry.bezierPath];
        
        [self.bodyPartView setFrame:CGRectMake(0, 0, (BODY_VIEW_WIDTH * self.scrollView.zoomScale), (BODY_VIEW_HEIGHT * self.scrollView.zoomScale) )];
        
        [self.view insertSubview:self.bodyPartView atIndex:2];
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
   
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
   
    NSLog(@"Scale is %f",scale);
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
   
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
   return YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
   
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {

   return self.bodyView;
}


@end
