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

    NSArray *sortedDates = [[histroyViews allKeys] sortedArrayUsingComparator:^(NSDate *d1, NSDate *d2) {
        return [d1 compare:d2];
    }];
    
    int maxCOunt = [sortedDates count];
    
    NSString *prevDateString = [sortedDates objectAtIndex:0];
    
    NSDateFormatter *form1 = [[NSDateFormatter alloc] init];
    
    [form1 setDateStyle:NSDateFormatterShortStyle];
    NSDate *date = [form1 dateFromString:prevDateString];
    [form1 setDateFormat:@"MMMM YYY"];
    UILabel *l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 20)];
    [l1 setBackgroundColor:[UIColor grayColor]];
    [l1 setText:[NSString stringWithFormat:@"%@",[form1 stringFromDate:date]]];
    [l1 setTextAlignment:UITextAlignmentCenter];
    [self.scrollView addSubview:l1];
 
    
    int mounthCount = 0;    
    float xIndex = 10.0;
    float yIndex = 45.0;
    int column = 0;
    
    for (int i=0; i<maxCOunt; i++) {
 
//Checking for dates and adding labels accordingly to the scroll view        
        NSString *currDateString = [[sortedDates objectAtIndex:i] copy];
        
        [form1 setDateStyle:NSDateFormatterShortStyle];
        
        NSDate *currDate = [form1 dateFromString:currDateString];
        NSDate *prevDate = [form1 dateFromString:prevDateString];
               
        [form1 setDateFormat:@"MM"];
        
        if(![[form1 stringFromDate:currDate] isEqualToString:[form1 stringFromDate:prevDate]]){
            
            mounthCount ++;
            
            [form1 setDateFormat:@"MMMM YYY"];
            yIndex += 118;
            UILabel *l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, yIndex, 320, 20)];
            [l1 setBackgroundColor:[UIColor grayColor]];
            [l1 setText:[NSString stringWithFormat:@"%@",[form1 stringFromDate:currDate]]];
            [l1 setTextAlignment:UITextAlignmentCenter];
            [self.scrollView addSubview:l1];
          
            
            yIndex += 35;
            column = 0;
        }
    
        prevDateString = currDateString;

// Doing the drawing for Body and adding it to scrollView
       
        InvoHistoryView *hisView =[[InvoHistoryView alloc]initWithFrame:CGRectMake(0, 0, 60, 108) locations:[[histroyViews valueForKey:currDateString]copy]];

        xIndex = 10 +70*column;
     
        [hisView setFrame:CGRectMake(xIndex,yIndex, 60, 108)];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        
        NSDate *dateee = [formatter dateFromString:[currDateString copy]];
        
        [formatter setDateFormat:@"E d"];
        NSLog(@"day is %@",[formatter stringFromDate:dateee]);
                
        UILabel *lbl  = [[UILabel alloc]init];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [lbl setFont:[UIFont fontWithName:@"Helvetica" size:9]];
        [lbl setTextAlignment:UITextAlignmentCenter];
        [lbl setText:[[formatter stringFromDate:dateee] copy]];
        [lbl setFrame:CGRectMake(0 ,108, 60, 10)];
        
        [hisView addSubview:lbl];
                
        [self.scrollView addSubview:hisView];

        column ++;
        
        if(column ==4){
            column = 0;
            yIndex +=118;
        }
    }
    
    
    self.scrollView.contentSize = (yIndex+108 <480 )?CGSizeMake( 320, 480+108) : CGSizeMake(320, yIndex+108*2);

    
}
#pragma mark -

-(IBAction)backPressed:(id)sender{

    NSLog(@"Back Pressed");
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // NSLog(@"did scroll");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
   // NSLog(@"Scale is %f",scale);
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

   // NSLog(@"ha ha");
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
   // NSLog(@"Scale while beginning zooming is %f",scrollView.zoomScale);
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
 
    return self.scrollView;
}

#pragma mark -


@end
