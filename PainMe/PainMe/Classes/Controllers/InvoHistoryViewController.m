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
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    self.scrollView.maximumZoomScale = 2.0;
    
    NSDictionary *histroyViews = [NSDictionary dictionaryWithDictionary:[[InvoDataManager sharedDataManager] entriesPerDayList]];
    
    NSLog(@"Total entries to draw are %d",[[histroyViews allKeys] count]);


    [self.scrollView setFrame:CGRectMake(0, 0, 320, 480)];
    
    int i=0;
    for (NSString *key in histroyViews) {
        
        InvoHistoryView *hisView =[[InvoHistoryView alloc]initWithFrame:CGRectMake(0, 0, 60, 108) locations:[[histroyViews valueForKey:key]copy]];

        [hisView setFrame:CGRectMake(10 +10*i + 60*i,10+ 10*((i+1)/4) + 108*((i+1)/4), 60, 108)];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        
        NSDate *dateee = [formatter dateFromString:[key copy]];
        
        [formatter setDateFormat:@"E d"];
        NSLog(@"day is %@",[formatter stringFromDate:dateee]);
        
//        [formatter setDateFormat:@"MMM"];
//        NSLog(@"day is %@",[formatter stringFromDate:dateee]);
        
        UILabel *lbl  = [[UILabel alloc]init];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont fontWithName:@"Helvetica" size:9]];
        [lbl setTextAlignment:UITextAlignmentCenter];
        [lbl setText:[[formatter stringFromDate:dateee] copy]];
        [lbl setFrame:CGRectMake(0 ,108, 60, 10)];
        
        [hisView addSubview:lbl];
                
        [self.scrollView addSubview:hisView];
        
        i++;
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
 
    return nil;
}

#pragma mark -


@end
