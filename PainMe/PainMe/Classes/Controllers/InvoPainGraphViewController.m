//
//  InvoPainGraphViewController.m
//  PainMe
//
//  Created by Dhaval Karwa on 8/1/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "InvoPainGraphViewController.h"
#import "InvoDataManager.h"

@interface InvoPainGraphViewController ()

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;
@property (nonatomic, strong) CPTGraph *graph;

@property (nonatomic, retain) NSMutableArray *PainEntriesArr;
@property (nonatomic, retain) NSString * painEntryName;
@property (nonatomic, retain) NSArray *bodyPartsNames;

-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configurePlot;
-(void)configureAxis;


@end

@implementation InvoPainGraphViewController

@synthesize hostView = _hostView, selectedTheme = _selectedTheme;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//    [self.view setUserInteractionEnabled:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
    
    self.painEntryName = @"Face";
    
    self.PainEntriesArr =[NSMutableArray arrayWithArray:[[InvoDataManager sharedDataManager] totalPainEntriesForPart:self.painEntryName]];

    self.bodyPartsNames = [[InvoDataManager sharedDataManager]namesOfBodyParts];
    
    newBtn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newBtn setFrame:CGRectMake(220, 150, 80, 40)];
    [newBtn addTarget:self action:@selector(pickerBttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [newBtn setTitle:@"New Part" forState:UIControlStateNormal];

    UIBarButtonItem *newBtnItm = [[UIBarButtonItem alloc]initWithCustomView:newBtn];
      [self.navigationItem setRightBarButtonItem:newBtnItm];
    
    done = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [done setFrame:CGRectMake(220, 150, 80, 40)];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];    
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self initPlot];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark Private Methods For Core Plot

-(void)initPlot{

    [self configureHost];
    [self configureGraph];
    [self configurePlot];
    [self configureAxis];

}
-(void)configureHost{

    self.hostView = [(CPTGraphHostingView *)[CPTGraphHostingView alloc] initWithFrame:self.view.bounds];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];

}
-(void)configureGraph{

    self.graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.selectedTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [self.graph applyTheme:self.selectedTheme];
    self.hostView.hostedGraph = self.graph;
    
    NSString *grphTitle = [NSString stringWithFormat:@"%@-Time graph",self.painEntryName];
    self.graph.title = grphTitle;

    CPTMutableTextStyle *txtStyle = [CPTMutableTextStyle textStyle];
    txtStyle.color = [CPTColor whiteColor];
    txtStyle.fontName = @"Helvetica";
    txtStyle.fontSize = 16.0f;
    
    self.graph.titleTextStyle = txtStyle;
    self.graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    self.graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
    [self.graph.plotAreaFrame setPaddingLeft:30.0f];
    [self.graph.plotAreaFrame setPaddingBottom:30.0f];

    CPTXYPlotSpace *plotSpc = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpc.allowsUserInteraction = YES;
}

-(void)configurePlot{

    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpc = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    CPTScatterPlot *painPlot = [[CPTScatterPlot alloc]init];
    painPlot.dataSource = self;
    painPlot.identifier = @"Pain";
    
    CPTColor *painColor = [CPTColor redColor];
    [graph addPlot:painPlot toPlotSpace:plotSpc];
        
    CGFloat xmin = 0.0;
    CGFloat xmax = 24.0;
    
    plotSpc.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(xmin) length:CPTDecimalFromCGFloat(xmax)];
    
    CGFloat ymin = 0.0;
    CGFloat ymax = 7.0;
    
    plotSpc.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(ymin) length:CPTDecimalFromCGFloat(ymax)];
    
    NSLog(@"plot x range is %@",plotSpc.xRange);
    NSLog(@"plot x range is %@",plotSpc.yRange);
    
    [plotSpc scaleToFitPlots:[NSArray arrayWithObjects:painPlot,nil]];
    
    NSLog(@"plot x range is %@",plotSpc.xRange);
    NSLog(@"plot x range is %@",plotSpc.yRange);

    
    CPTMutableLineStyle *painLineStyle = [painPlot.dataLineStyle mutableCopy];
    painLineStyle.lineWidth = 2.0f;
    painLineStyle.lineColor = painColor;
    painPlot.dataLineStyle = painLineStyle;
    
    CPTMutableLineStyle *painSymbolLineStly = [CPTMutableLineStyle lineStyle];
    painSymbolLineStly.lineColor = painColor;
    CPTPlotSymbol *painPlotSymbol = [CPTPlotSymbol starPlotSymbol];
    painPlotSymbol.fill = [CPTFill fillWithColor:[CPTColor yellowColor]];
    painPlotSymbol.lineStyle = painSymbolLineStly;
    painPlotSymbol.size = CGSizeMake(6.0, 6.0);
    painPlot.plotSymbol = painPlotSymbol;
    
    
}

-(void)configureAxis{

//Setting up axis styles
    
    CPTMutableTextStyle *axisTitlStyle = [CPTMutableTextStyle textStyle];
    axisTitlStyle.color = [CPTColor whiteColor];
    axisTitlStyle.fontName = @"Helvetica";
    axisTitlStyle.fontSize = 14.0f;

    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineColor =[CPTColor whiteColor];
    axisLineStyle.lineWidth = 2.0f;

    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc]init];
    axisTextStyle.color = [CPTColor blueColor];
    axisTextStyle.fontName = @"Helvetica";
    axisTextStyle.fontSize = 12.0f;
    
    CPTMutableLineStyle *tickLineStyl = [CPTMutableLineStyle lineStyle];
    tickLineStyl.lineColor = [CPTColor redColor];
    tickLineStyl.lineWidth = 2.0f;
    
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor blackColor];
    gridLineStyle.lineWidth = 1.0f;
    
//Axis setup
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)self.hostView.hostedGraph.axisSet;
    
    CPTXYAxis *xAxis = axisSet.xAxis;
    xAxis.title = @" Hour of the day ";
    xAxis.titleTextStyle = axisTitlStyle;
    xAxis.timeOffset = 10.0F;
    xAxis.axisLineStyle = axisLineStyle;
    xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    xAxis.labelTextStyle = axisTextStyle;
    xAxis.majorTickLineStyle = axisLineStyle;
    xAxis.majorTickLength = 5.0f;
    xAxis.minorTickLength = 2.0f;
    xAxis.tickDirection = CPTSignNegative;
    
    CGFloat timeCount = [self.PainEntriesArr count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:timeCount];
    NSMutableSet *xLocations =[NSMutableSet setWithCapacity:timeCount];
    

    for (int i=1; i<=24; i++) {
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d",i] textStyle:xAxis.labelTextStyle];
        
       // CGFloat location = i;
        label.tickLocation = CPTDecimalFromInt(i);
        label.offset = xAxis.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithInt:i]];
        }
    }
    xAxis.axisLabels = xLabels;
    xAxis.majorTickLocations = xLocations;

// YAxis setup
    
    CPTXYAxis *yAxis = axisSet.yAxis;
    yAxis.title = @" Pain Level ";
    yAxis.titleTextStyle = axisTitlStyle;
    yAxis.titleOffset = -40.0F;
    yAxis.axisLineStyle = axisLineStyle;
    yAxis.majorGridLineStyle = gridLineStyle;

    yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    yAxis.labelTextStyle = axisTextStyle;
    yAxis.labelOffset = 10.0f;
    xAxis.majorTickLineStyle = axisLineStyle;
    yAxis.minorTickLength = 2.0f;
    yAxis.majorTickLength = 5.0f;
    yAxis.tickDirection = CPTSignPositive;
    
    
    
    NSMutableSet *yLabels = [NSMutableSet setWithCapacity:timeCount];
    NSMutableSet *yLocations =[NSMutableSet setWithCapacity:timeCount];
    
    for (int i=1; i<=7; i++) {
        
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d",i] textStyle:yAxis.labelTextStyle];
        
        // CGFloat location = i;
        label.tickLocation = CPTDecimalFromInt(i);
        label.offset = -yAxis.majorTickLength - yAxis.labelOffset;
        if (label) {
            [yLabels addObject:label];
            [yLocations addObject:[NSNumber numberWithInt:i]];
        }
    }
    yAxis.axisLabels = yLabels;
    yAxis.majorTickLocations = yLocations;
    
}


#pragma mark Coreplot DataSource delegate methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{

    int painEntries = [self.PainEntriesArr count];
    NSLog(@"Total Pain Entries are %d", painEntries);
    if (painEntries ==0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pain Entries" message:@"No entries were found for the selected body part" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    return painEntries;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
        {
            
            NSDate *dte = [self dateFromEntriesAtIndex:index];
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            
            NSDateComponents *comp = [cal components:(NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:dte];
            NSInteger hour = [comp hour];
            NSLog(@"hour is %d", hour);
            return [NSNumber numberWithInteger:hour];
        }
            break;
            
        case CPTScatterPlotFieldY:
            
            return [self painLevelFromENtriesAtIndex:index];
            
            break;
    }

    return [NSDecimalNumber zero];
}

-(NSDate *)dateFromEntriesAtIndex:(int)index{

    NSDate *date =nil;
        
    NSDictionary *dict = [self.PainEntriesArr objectAtIndex:index];
      date = [dict valueForKey:@"timestamp"];

    return date;
}

-(NSNumber*) painLevelFromENtriesAtIndex:(int)index{

    NSNumber *levelToReturn = [NSNumber numberWithInt:0];

    NSDictionary *dict = [self.PainEntriesArr objectAtIndex:index];
    levelToReturn = [dict valueForKey:@"painLevel"];
    return levelToReturn;
}

-(void)pickerBttonTapped:(id)sender{

    NSLog(@"Tapped");
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
    
    pickerView.delegate = self;
    
    pickerView.showsSelectionIndicator = YES;
        
    pickerView.tag = 1;
    
    [self.view addSubview:pickerView];

}
#pragma mark -

#pragma mark PickerView Del Methods

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    self.painEntryName = [self.bodyPartsNames objectAtIndex:row];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:done]];
//    UIPickerView *pick =nil;
//    for (UIView *view in self.view.subviews) {
//        
//        if (view.tag ==1) {
//            
//            pick = (UIPickerView *)view;
//            NSString *name = [self.bodyPartsNames objectAtIndex:row];
//            self.PainEntriesArr = [NSMutableArray array];
//            self.PainEntriesArr =[NSMutableArray arrayWithArray:[[InvoDataManager sharedDataManager] totalPainEntriesForPart:[name copy]]];
//            [self.graph reloadData];
            
//            [pick removeFromSuperview];
//            break;
//        }
//    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    NSUInteger numROws = [self.bodyPartsNames count];
    return numROws;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title = [NSString stringWithFormat:@" %@ ",[self.bodyPartsNames objectAtIndex:row] ];
    return [title copy];
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{

    return 200;
}

-(void)donePressed:(id)sender{

    self.PainEntriesArr = [NSMutableArray array];
    UIPickerView *pick =nil;
    
    for (UIView *view in self.view.subviews) {

        if (view.tag ==1) {
    
            pick = (UIPickerView *)view;
            self.graph.title = [NSString stringWithFormat:@"%@-Time graph",self.painEntryName];
            self.PainEntriesArr = [NSMutableArray array];
            self.PainEntriesArr =[NSMutableArray arrayWithArray:[[InvoDataManager sharedDataManager] totalPainEntriesForPart:[self.painEntryName copy]]];

            [pick removeFromSuperview];
            [self.graph reloadData];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:newBtn]];
            
            break;
        }
    }
}
#pragma mark -
@end
