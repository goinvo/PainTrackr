//
//  InvoBodySelectionViewControllerViewController.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "InvoBodySelectionViewControllerViewController.h"
#import "BodyView.h"

@interface InvoBodySelectionViewControllerViewController () {
   
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet BodyView *bodyView;

@end

@implementation InvoBodySelectionViewControllerViewController

@synthesize scrollView = _scrollView, bodyView = _bodyView;

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
   self.scrollView.contentSize = CGSizeMake(BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT);
   self.scrollView.zoomScale = 0.25;
   
   self.bodyView.frame = CGRectMake(0,0,BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT);
}

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
