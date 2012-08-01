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
    
    [plotSpc scaleToFitPlots:[NSArray arrayWithObject:painPlot]];
    CPTMutablePlotRange *xRange = [plotSpc.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromInt(1.1)];
    plotSpc.xRange = xRange;
    
    CPTMutablePlotRange *yRange = [plotSpc.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromInt(1.1)];
    plotSpc.yRange = yRange;
    
    
    
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

    
}


#pragma mark Coreplot DataSource delegate methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{

    int painEntries = [[InvoDataManager sharedDataManager] totalPainEntries];
    NSLog(@"Total Pain Entries are %d", painEntries);
    return painEntries;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{

    int painEntries = [[InvoDataManager sharedDataManager] totalPainEntries];
    
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            
            if (index < painEntries) {
                return [NSNumber numberWithUnsignedInteger:index];
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
