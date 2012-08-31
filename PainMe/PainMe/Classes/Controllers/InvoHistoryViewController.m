//
//  InvoHistoryViewController.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/30/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoHistoryViewController.h"
#import "InvoDataManager.h"

#import "InvoHistoryView.h"

@interface InvoHistoryViewController ()

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) InvoHistoryView *historyView;
-(IBAction)backPressed:(id)sender;
@end

@implementation InvoHistoryViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
       
    }
    return self;
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
        NSLog(@"History view did load");
    // Do any additional setup after loading the view from its nib.
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

#pragma mark view Will Appear

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:NO];

    self.view.backgroundColor = [UIColor whiteColor];
    //self.scrollView.contentSize = CGSizeMake(320, 480);
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
   // self.historyView.frame = CGRectMake(0,0,40, 40);
    
//    self.scrollView.minimumZoomScale = 1.0;
//    self.scrollView.zoomScale = 1.0;
    self.scrollView.maximumZoomScale = 2.0;
    
    NSDictionary *histroyViews = [NSDictionary dictionaryWithDictionary:[[InvoDataManager sharedDataManager] entriesPerDayList]];
    
    NSLog(@"Total entries to draw are %d",[[histroyViews allKeys] count]);
    int count = [[histroyViews allKeys] count];

    int width = count *60 +count*10;
    int height = count *108 +count*10;
    
//    self.scrollView.contentSize = CGSizeMake(width, height);
   [self.scrollView setFrame:CGRectMake(0, 0, 320, 480)];
    
    for (int i=0; i< count ;i ++) {

        InvoHistoryView *hisView =[[InvoHistoryView alloc]initWithFrame:CGRectZero];
        [hisView setFrame:CGRectMake(0, 0, 60, 108)];

        CGRect imgViewRect;

        imgViewRect = CGRectMake(10 +10*i + 60*i,10+ 10*((i+1)/4) + 108*((i+1)/4), 60, 108);

        UIImageView *vi = [[UIImageView alloc]initWithFrame:imgViewRect];
        [vi setBackgroundColor:[UIColor colorWithPatternImage:hisView.imgRet]];
        [self.scrollView addSubview:vi];
    }
}
#pragma mark -

-(IBAction)backPressed:(id)sender{

    NSLog(@"Back Pressed");
    [self.navigationController dismissModalViewControllerAnimated:YES];
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
    
    NSLog(@"Scale while beginning zooming is %f",scrollView.zoomScale);
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
}

#pragma mark -


@end
