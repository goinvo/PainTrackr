//
//  InvoHistoryViewController.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/30/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoHistoryViewController.h"
#import "InvoDataManager.h"
#import "InvoDetailedHistoryViewController.h"

@interface InvoHistoryViewController ()
{

    NSDateFormatter *form1;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) InvoHistoryView *historyView;

@property (nonatomic, strong)NSArray *sortedDates;
@property (nonatomic, strong)NSDictionary *painEntriesByDate;

-(IBAction)backPressed:(id)sender;

-(void)setUpView;
-(void)sortDates;
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
    
//        NSLog(@"History view did load");
    // Do any additional setup after loading the view from its nib.
    
    [self setUpView];
    [self.view setClipsToBounds:YES];
    
    if([self.sortedDates count]>0){
        
        int maxCOunt = [self.sortedDates count];
        
        NSDate *prevDateString = [self.sortedDates objectAtIndex:0];
        
//        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, 320, 1)];
//        [lineView setBackgroundColor:[UIColor lightGrayColor]];
//        [self.scrollView addSubview:lineView];
        
        [self addLabelFromDate:prevDateString
                   formatStyle:@"MMMM YYY"
                          rect:CGRectMake(0, 10, 320, 20)
                     backColor:[UIColor clearColor]
                      fontSize:15.0f
                        toView:self.scrollView];
        
        int mounthCount = 0;
        float xIndex = 10.0;
        float yIndex = 45.0;
        int column = 0;
        
        NSDate *prevDate = prevDateString;
        
        for (int i=0; i<maxCOunt; i++) {
            
            //Checking for dates and adding labels accordingly to the scroll view
            
            [form1 setDateStyle:NSDateFormatterShortStyle];
            
            NSDate *currDate = [[self.sortedDates objectAtIndex:i] copy];
            [form1 setDateFormat:@"MM"];
            
            //        NSLog(@" currDate %@",[form1 stringFromDate:currDate]);
            //        NSLog(@" PrevDate %@",[form1 stringFromDate:prevDate]);
            
            if(![[form1 stringFromDate:currDate] isEqualToString:[form1 stringFromDate:prevDate]]){
                
                mounthCount ++;
                yIndex += 130;
                
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, yIndex, 320, 1)];
                [lineView setBackgroundColor:[UIColor lightGrayColor]];
                [self.scrollView addSubview:lineView];

                [self addLabelFromDate:currDate
                           formatStyle:@"MMMM YYY"
                                  rect:CGRectMake(0, yIndex+5, 320, 20)
                             backColor:[UIColor clearColor]
                              fontSize:15.0f
                                toView:self.scrollView];
                
                yIndex += 35;
                column = 0;
            }
            
            prevDate = currDate;
            
            // Doing the drawing for Body and adding it to scrollView
            
            [form1 setDateFormat:@"M/d/YY"];
            NSString *stringFrmDate = [form1 stringFromDate:currDate];
            
            NSArray *locatArry = [[self.painEntriesByDate valueForKey:stringFrmDate] copy];
            
            if([locatArry count] >0){
                
                InvoHistoryView *hisView =[[InvoHistoryView alloc]initWithFrame:CGRectMake(0, 0, 60, 108) locations:locatArry date:[stringFrmDate copy]];
                hisView.del = self;
                xIndex = 10 +70*column;
                
                [hisView setFrame:CGRectMake(xIndex,yIndex, 60, 108)];
                
                [self addLabelFromDate:currDate formatStyle:@"E d" rect:CGRectMake(0 ,110, 60, 10) backColor:[UIColor clearColor] fontSize:9.0 toView:hisView];
                
                [self.scrollView addSubview:hisView];
                
                column ++;
                
                if(column ==4){
                    column = 0;
                    yIndex +=130;
                }
            }
        }
        
        self.scrollView.contentSize = (yIndex+108 <[UIScreen mainScreen].bounds.size.height -35)?CGSizeMake( 320, [UIScreen mainScreen].bounds.size.height -35) : CGSizeMake(320, yIndex+108*2);
        
        NSLog(@"scrollview content size is %@", NSStringFromCGSize(self.scrollView.contentSize));
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any stronged subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark SortDates
-(void)sortDates{

    NSMutableArray *unSortedDates = [NSMutableArray array];
    NSDateFormatter *frmtr = [[NSDateFormatter alloc]init];
    
    [frmtr setDateStyle:NSDateFormatterShortStyle];
    
    for (id objDate in [self.painEntriesByDate allKeys]) {
        
        [unSortedDates addObject:[frmtr dateFromString:objDate]];
    }
    
    self.sortedDates = [unSortedDates sortedArrayUsingComparator:^(NSDate *d1, NSDate *d2) {
        
        return [d1 compare:d2];
    }];
    
//    NSLog(@"sorted array is %@", self.sortedDates);

}

#pragma mark -

#pragma mark setUpview
-(void)setUpView{
    
  //  [self.view setUserInteractionEnabled:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 1.0f;
//    self.scrollView.pagingEnabled = YES;
    self.painEntriesByDate = [NSDictionary dictionaryWithDictionary:[[InvoDataManager sharedDataManager] entriesPerDayList]];
    
//    NSLog(@"Total entries to draw are %d",[[self.painEntriesByDate allKeys] count]);
    
    [self.scrollView setFrame:CGRectMake(0, 0, 320, 480)];
    
    form1 = [[NSDateFormatter alloc] init];

    [self sortDates];

}

#pragma mark -

#pragma mark add label from Date to the view
-(void)addLabelFromDate:(NSDate *)date formatStyle:(NSString *)frmtSyl rect:(CGRect)labelrect backColor:(UIColor*)color fontSize:(float)fntSize toView:(id)viewToAttach{

    [form1 setDateStyle:NSDateFormatterShortStyle];
    [form1 setDateFormat:frmtSyl];
    
    UILabel *l1 = [[UILabel alloc]initWithFrame:labelrect];
    [l1 setBackgroundColor:color];
    [l1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fntSize]];
    
    [l1 setText:[NSString stringWithFormat:@"%@",[form1 stringFromDate:date]]];
    [l1 setTextAlignment:UITextAlignmentCenter];
    [viewToAttach addSubview:l1];
    
}
#pragma mark -

#pragma mark view Will Appear


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:NO];
}

#pragma mark -

-(IBAction)backPressed:(id)sender{

//    NSLog(@"Back Pressed");
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   // NSLog(@"did scroll");
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    
   // NSLog(@"Scale is %f",scale);
    
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
 
    return self.view;
}

#pragma mark -

#pragma mark HistoryView Delegate Method

-(void)daySelectedWas:(NSString *)str{

//    NSLog(@"Selected day was %@", str);
    InvoDetailedHistoryViewController *detailedHistory = [[InvoDetailedHistoryViewController alloc]initWithNibName:@"InvoDetailedHistoryViewController" bundle:[NSBundle mainBundle] date:str painEntriesByDate:[self.painEntriesByDate copy]];
    [self.navigationController pushViewController:detailedHistory animated:YES];
    
}
#pragma mark -

@end
