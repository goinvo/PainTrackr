//
//  InvoPainGraphViewController.m
//  PainMe
//
//  Created by Dhaval Karwa on 8/1/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "InvoPainGraphViewController.h"
#import "InvoDataManager.h"

@interface InvoPainGraphViewController ()

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) CPTTheme *selectedTheme;

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
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
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

    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.selectedTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    [graph applyTheme:self.selectedTheme];
    self.hostView.hostedGraph = graph;
    
    NSString *grphTitle = @"Pain-Time Graph";
    graph.title = grphTitle;

    CPTMutableTextStyle *txtStyle = [CPTMutableTextStyle textStyle];
    txtStyle.color = [CPTColor whiteColor];
    txtStyle.fontName = @"Helvetica";
    txtStyle.fontSize = 16.0f;
    
    graph.titleTextStyle = txtStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 10.0f);
    
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];

    CPTXYPlotSpace *plotSpc = (CPTXYPlotSpace *)graph.defaultPlotSpace;
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
    
    CGFloat timeCount = [[InvoDataManager sharedDataManager] totalPainEntries];
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

    int painEntries = [[InvoDataManager sharedDataManager] totalPainEntries];
    NSLog(@"Total Pain Entries are %d", painEntries);
    return painEntries;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{

 //	   int painEntries = [[InvoDataManager sharedDataManager] totalPainEntries];
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
        {
            NSDate *dte = [[[InvoDataManager sharedDataManager] timeStampsForPainEntries] objectAtIndex:index];
            
            NSCalendar *cal = [NSCalendar currentCalendar];
            
            NSDateComponents *comp = [cal components:(NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:dte];
            NSInteger hour = [comp hour];
            NSLog(@"hour is %d", hour);
            return [NSNumber numberWithInteger:hour];
        }
            break;
            
        case CPTScatterPlotFieldY:
            
            return [[[InvoDataManager sharedDataManager] painLevelsForAllEntries] objectAtIndex:index];
            break;
    }

    return [NSDecimalNumber zero];
}
#pragma mark -
@end
