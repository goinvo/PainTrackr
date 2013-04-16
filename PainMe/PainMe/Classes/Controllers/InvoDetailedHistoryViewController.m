//
//  InvoDetailedHistoryViewController.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/24/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoDetailedHistoryViewController.h"
#import "InvoDetailedHistoryBodyView.h"

//2 FRONT, 2 BACK AND ONE CURRENT
#define MAXLOADEDVIEWS 5

@interface InvoDetailedHistoryViewController (){

     IBOutlet UILabel *dateLabel;
    
    __weak IBOutlet UIButton *leftButton;
    __weak IBOutlet UIButton *rightButton;
    
    int minCurrTag ;
    int maxCurrTag ;
}

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *dateLabelText;

@property (nonatomic, assign, readonly) int totalCount;
@property (nonatomic, readwrite) int currDateIndex;

@property (nonatomic, weak) UIScrollView *entriesScrollView;

@property (nonatomic, strong) NSDictionary *sortedByDateEntries;
@property (nonatomic, strong) NSArray *datesArray;

-(void)addFacesToView;
-(IBAction)leftTapped:(id)sender;
-(IBAction)rightTapped:(id)sender;

@end

@implementation InvoDetailedHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil date:(NSString *)dateString painEntriesByDate:(NSDictionary *)sortedDict
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        if (dateString) {
            
            NSDateFormatter *frmtr = [[NSDateFormatter alloc]init];
            [frmtr setDateStyle:NSDateFormatterShortStyle];
            [frmtr setLocale:[NSLocale currentLocale]];
            NSDate *dateFrmStr = [frmtr dateFromString:dateString];
            [frmtr setDateFormat:@"EEEE d"];
            
            self.dateLabelText = [frmtr stringFromDate:dateFrmStr];
        }
        if (sortedDict) {
            self.sortedByDateEntries = [sortedDict copy];
            
            [self sortDates];
            self.currDateIndex = [ self indexOfDate:dateString];
//            NSLog(@"dates are %@",self.datesArray);
            [self addBodyViewsForDate:[dateString copy]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Flurry logEvent:@"InDetailedHistoryView" timed:YES];
    
    // Do any additional setup after loading the view from its nib.
    if (![self.dateLabelText isEqualToString:@""]) {
        [dateLabel setText:self.dateLabelText];
    }
    [self checkButtonsToDisplayWithIndex:self.currDateIndex];
    
    _entriesScrollView.pagingEnabled = YES;
    _entriesScrollView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated{

    [Flurry endTimedEvent:@"InDetailedHistoryView" withParameters:nil];
    [super viewWillDisappear:animated];
}
#pragma mark Sort Dates

-(void)sortDates{
    
    NSMutableArray *unSortedDates = [NSMutableArray array];
    NSDateFormatter *frmtr = [[NSDateFormatter alloc]init];
    [frmtr setLocale:[NSLocale currentLocale]];
    [frmtr setDateStyle:NSDateFormatterShortStyle];
    
    for (id objDate in [self.sortedByDateEntries allKeys]) {
        
        [unSortedDates addObject:[frmtr dateFromString:objDate]];
    }
    
    self.datesArray = [unSortedDates sortedArrayUsingComparator:^(NSDate *d1, NSDate *d2) {
        
        return [d1 compare:d2];
    }];
    
}
#pragma mark -

#pragma mark get IndexOfDate

-(int)indexOfDate:(id)date{

    if ([date isKindOfClass:[NSString class]]) {
        
        NSDateFormatter *frmtr = [[NSDateFormatter alloc]init];
        [frmtr setDateStyle:NSDateFormatterShortStyle];
        [frmtr setLocale:[NSLocale currentLocale]];
        
        NSDate *dteFromString = [frmtr dateFromString:date];
        
        return ([self.datesArray indexOfObject:dteFromString]);
    }

    return ([self.datesArray indexOfObject:date]);
}
#pragma mark -

#pragma mark Check for which utton to display based on selected index

-(void)checkButtonsToDisplayWithIndex:(int)num {
    
    
    if (num ==0){
        
        [leftButton setUserInteractionEnabled:NO];
        [leftButton setHidden:YES];
        
        if ([self.datesArray count]>1) {
            [rightButton setUserInteractionEnabled:YES];
            [rightButton setHidden:NO];
            return;
        }
        [rightButton setUserInteractionEnabled:NO];
        [rightButton setHidden:YES];
    }
    else{
    
        int count = [self.datesArray count];
        if (num == (count -1)) {
            [leftButton setUserInteractionEnabled:YES];
            [leftButton setHidden:NO];
            
            [rightButton setUserInteractionEnabled:NO];
            [rightButton setHidden:YES];
            return;
        }
        
        [leftButton setUserInteractionEnabled:YES];
        [leftButton setHidden:NO];
        
        [rightButton setUserInteractionEnabled:YES];
        [rightButton setHidden:NO];
    }
}
#pragma mark -



#pragma mark Add PainFaces

-(void)addFacesToView{
    
    for (int i=0; i<7; i++) {
        
        UIView *f1 = [[UIView alloc]init];
        [f1 setUserInteractionEnabled:NO];

        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"F%d.png",i+1]];
        [f1 setBackgroundColor:[UIColor colorWithPatternImage:img]];
        [f1 setFrame:CGRectMake(2, 10+ i*img.size.height, img.size.width, img.size.height)];
        
        UILabel *lbl = [[UILabel alloc]init];
        [lbl setFont:[UIFont fontWithName:@"Helvetica" size:10]];
        [lbl setFrame:CGRectMake(img.size.width*0.5 -15, img.size.height-14, 30, 10)];
        [lbl setTextAlignment:UITextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.4f]];
        NSString *tmp = (i==0)? @"0":[NSString stringWithFormat:@"%d-%d",(i*2 -1),i*2];
        [lbl setText:tmp];
        
        [f1 addSubview:lbl];
        [self.view insertSubview:f1 atIndex:0];
        
    }
}
#pragma mark -

#pragma mark Handling Date buttons

-(IBAction)leftTapped:(id)sender{

//    NSLog(@"Left was Pressed");
    self.currDateIndex = (self.currDateIndex > 0)? self.currDateIndex-=1 : 0;
    [self checkButtonsToDisplayWithIndex:self.currDateIndex];
    [self changeDateLabelWithIndex:self.currDateIndex];
}
-(IBAction)rightTapped:(id)sender{

//    NSLog(@"Right was Pressed");
    self.currDateIndex = (self.currDateIndex < [self.datesArray count]-1 )? self.currDateIndex+=1 : [self.datesArray count]-1;
    [self checkButtonsToDisplayWithIndex:self.currDateIndex];
    [self changeDateLabelWithIndex:self.currDateIndex];
}

#pragma mark -

-(void)addBodyViewsForDate:(id)date{
    
    //    NSLog(@"date is %@",date);
    
    if (_entriesScrollView) {
        [_entriesScrollView removeFromSuperview];
    }
    
    //42 is for the NavBar
    float dateHeight = dateLabel.frame.size.height;
    float padding = 12.0f;
    float height = [[UIScreen mainScreen] applicationFrame].size.height - 42.0f -dateHeight - padding*4;
    float imgAspect = 4.0/9;
    float width = imgAspect*height;
    
//    NSLog(@"new height:%f width:%f", height,width);
    
    //160, 360
    UIScrollView *scrollview;
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 32, [[UIScreen mainScreen] applicationFrame].size.width, height)];
    [scrollview setBackgroundColor:[UIColor colorWithWhite:0.94 alpha:0.8f]];
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
//    scrollview.showsHorizontalScrollIndicator = NO;
    [self.view insertSubview:scrollview atIndex:100];
    _entriesScrollView = scrollview;
    
   // NSString *dString;
    if([date isKindOfClass:[NSString class]]){
    
        _dateString = [date copy];
    }
    else{
        NSDateFormatter *frmtr = [[NSDateFormatter alloc] init];
        [frmtr setDateStyle:NSDateFormatterShortStyle];
        _dateString = [frmtr stringFromDate:date];
    }
    
    NSArray *entriesValue = [self.sortedByDateEntries valueForKey:_dateString];
//    NSLog(@"value count is %d",[entriesValue count]);

    float oldWidth = _entriesScrollView.bounds.size.width;
    float offsetX = (oldWidth - width)*0.5;
    
    float newWidth = oldWidth * [entriesValue count];
    
    _totalCount = [entriesValue count];
    
    int countToUse = (_totalCount < MAXLOADEDVIEWS)? _totalCount : MAXLOADEDVIEWS;
    
    minCurrTag = 0;
    maxCurrTag = countToUse-1;
    for (int i=0; i< countToUse; i++) {
        
        InvoDetailedHistoryBodyView *detailView = [InvoDetailedHistoryBodyView detailedBodyViewWithFrame:CGRectMake(offsetX + oldWidth*i, 0, width, height) PainDetails:[entriesValue objectAtIndex:i]];
        detailView.tag = i;
        [_entriesScrollView addSubview:detailView];
    }
    
//    NSLog(@"entries view subviews are %@", [_entriesScrollView subviews]);
    
    [_entriesScrollView setContentSize:CGSizeMake(newWidth, _entriesScrollView.bounds.size.height)];
    
}

#pragma mark -

#pragma mark manage images in memory
-(void)manageViewsWithOffSet:(CGPoint)contOffset{
    
    int calcPageIndex =  (int) ((contOffset.x +self.entriesScrollView.frame.size.width) /self.entriesScrollView.frame.size.width);
    calcPageIndex = (calcPageIndex == _totalCount)? calcPageIndex-1 : calcPageIndex;
    
    int numToAddSub = MAXLOADEDVIEWS/2 ;
    
    int maxCacheIndex = (calcPageIndex + numToAddSub) +2;
    maxCacheIndex = (maxCacheIndex > _totalCount)? _totalCount : maxCacheIndex;
    
    int minCacheIndex = (maxCacheIndex - MAXLOADEDVIEWS);
    minCacheIndex = (minCacheIndex <0)?0:minCacheIndex;


//    NSLog(@"page based on offset is %d",calcPageIndex);
//    NSLog(@"MaxCache = %d MinCache = %d ",maxCacheIndex, minCacheIndex);

            
    //42 is for the NavBar
    float dateHeight = dateLabel.frame.size.height;
    float padding = 12.0f;
    float height = [[UIScreen mainScreen] applicationFrame].size.height - 42.0f -dateHeight - padding*2;
    float imgAspect = 4.0/9;
    float width = imgAspect*height;
    
     NSArray *entriesValue = [self.sortedByDateEntries valueForKey:_dateString];
    
    //adding missing lowerBound views
    int minDiff = minCurrTag - minCacheIndex;

    if (minDiff>0) {
        float oldWidth = _entriesScrollView.bounds.size.width;
        float offsetX = (oldWidth - width)*0.5;
                
        for (int i = minDiff ; i >0; i--) {

            minCurrTag--;
            maxCurrTag--;
//            NSLog(@"adding object at index %d", minCurrTag);
            InvoDetailedHistoryBodyView *detailView = [InvoDetailedHistoryBodyView detailedBodyViewWithFrame:CGRectMake(offsetX + oldWidth*minCurrTag, 0, width, height) PainDetails:[entriesValue objectAtIndex:minCurrTag]];
            detailView.tag = minCurrTag;
            [_entriesScrollView addSubview:detailView];
        }
    }
//adding missing UpperBound views
    int maxDiff = maxCurrTag - maxCacheIndex;
    
    if (maxDiff <0) {
        float oldWidth = _entriesScrollView.bounds.size.width;
        float offsetX = (oldWidth - width)*0.5;

        for (int i= maxCurrTag; i< maxCacheIndex ; i++) {
            
            InvoDetailedHistoryBodyView *detailView = [InvoDetailedHistoryBodyView detailedBodyViewWithFrame:CGRectMake(offsetX + oldWidth*i, 0, width, height) PainDetails:[entriesValue objectAtIndex:i]];
            detailView.tag = i;
            [_entriesScrollView addSubview:detailView];
           // maxCurrTag = i;
            minCurrTag ++;
            maxCurrTag ++;
        }
    }
    
    NSArray *subArray = [NSArray arrayWithArray:[self.entriesScrollView subviews]] ;
    
//removing views not needed from scrollView
    [subArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
    
        int objTag = [(UIView *)obj tag];
        if (objTag< minCacheIndex || objTag > maxCacheIndex) {
            
//            NSLog(@"removing object with tag %d", objTag);
            [(UIView *)obj removeFromSuperview];
        }
    }];
    
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
    if (decelerate) {
        [self manageViewsWithOffSet:scrollView.contentOffset];
    }
}

#pragma mark change date label based on selection

-(void)changeDateLabelWithIndex:(int)dateIndex{
    
    if(dateIndex>=0 && dateIndex <= [self.datesArray count]){
        
        NSDateFormatter *form1 = [[NSDateFormatter alloc] init];
        
        [form1 setDateFormat:@"EEEE  dd"];
        
        NSString *dLabel = [form1 stringFromDate:[self.datesArray objectAtIndex:dateIndex]];
        
        [self addBodyViewsForDate:[self.datesArray objectAtIndex:dateIndex]];
        
        [dateLabel setText:dLabel];
    }
}
 
#pragma mark -

@end
