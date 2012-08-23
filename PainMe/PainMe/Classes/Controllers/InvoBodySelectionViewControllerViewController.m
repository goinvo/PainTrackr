//
//  InvoBodySelectionViewControllerViewController.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "InvoBodySelectionViewControllerViewController.h"
#import "BodyView.h"
#import "InvoDataManager.h"
#import "BodyPartGeometry.h"
#import "PainEntry.h"
#import "PainLocation.h"

@interface InvoBodySelectionViewControllerViewController () {
   
    CGPoint bodyOffset;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet BodyView *bodyView;
@property (nonatomic, retain) UITapGestureRecognizer *tapGesture;

@property (nonatomic, retain) BodyPartGeometry *bodyGeometry;
@property (nonatomic, retain) PainFaceView *painFace;

@property (nonatomic, retain) UITapGestureRecognizer *doubleTap;

-(void)initTapGesture;
-(int)tileAtTouchLocation:(CGPoint)touchPt;
-(UIColor *)colorfromPain:(int)painLvl;
-(void)checkAndAddLastEntryToView;

-(IBAction)sendPresed:(id)sender;
-(NSString *)timeForReport;

@end

@implementation InvoBodySelectionViewControllerViewController

@synthesize scrollView = _scrollView, bodyView = _bodyView;
@synthesize tapGesture = _tapGesture;
//@synthesize bodyPartView = _bodyPartView;
@synthesize bodyGeometry = _bodyGeometry;
@synthesize painFace = _painFace;

@synthesize partNameLabel = _partNameLabel;

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



-(void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setToolbarHidden:NO];
    
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    bodyOffset = CGPointZero;
    
    self.scrollView.contentSize = CGSizeMake(BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT );
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    self.bodyView.frame = CGRectMake(70,0,BODY_VIEW_WIDTH *1.17, BODY_VIEW_HEIGHT);
    
//    NSLog(@"bodyview frame is %@", NSStringFromCGRect(self.bodyView.frame));
    self.scrollView.minimumZoomScale = 0.045;
    self.scrollView.zoomScale = 0.045;
    self.scrollView.maximumZoomScale = 1.0;
    
// Add the Face button View
    
    self.painFace = [[PainFaceView alloc] init];
    self.painFace.delegate = self;
    [self.view insertSubview:self.painFace atIndex:10];
   
//Init TapGesture Recognizer    
    [self initTapGesture];
    
    self.bodyGeometry = [[BodyPartGeometry alloc] init];
    
    [self checkAndAddLastEntryToView];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.doubleTap.numberOfTapsRequired = 2;
    self.doubleTap.numberOfTouchesRequired = 1;
    self.doubleTap.delegate = self;
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
    [self.tapGesture requireGestureRecognizerToFail:self.doubleTap];
}


#pragma mark Draw last entry if it exists
-(void)checkAndAddLastEntryToView{

    id entryToRender =   [[InvoDataManager sharedDataManager] lastPainEntryToRender];
        
    if (entryToRender) {
        //    NSLog(@"entry to render is %@",entryToRender);
        
        UIColor *fillColor = [self colorfromPain:[[(PainEntry *)entryToRender valueForKey:@"painLevel"] integerValue]];
        
        if (fillColor) {
            PainLocation *loc = (PainLocation *)[entryToRender valueForKey:@"location"];
            int zoom = [[loc valueForKey:@"zoomLevel"] intValue];
            
            UIBezierPath *locpath = [self.bodyGeometry dictFrBodyLocation:[ [loc valueForKey:@"name"] copy]];
            
            [self.bodyView addObjToSHapesArrayWithShape:locpath color:fillColor detail:zoom name:[[loc valueForKey:@"name"] copy]];
            
            [self.partNameLabel setText:[loc valueForKey:@"name"]];
            [self.partNameLabel setTextColor:fillColor];
        }
    }
}

#pragma mark Init tap Gesture
-(void)initTapGesture{

    self.tapGesture   =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGesture.delegate = self;
    self.tapGesture.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:self.tapGesture];
    [self.tapGesture setCancelsTouchesInView:NO];
//    [self.tapGesture requireGestureRecognizerToFail:self.doubleTap];
}

// button handler:
// set new pain level
// [bodyView setNeedsDisplayInRect: ...]

#pragma mark Handle Tap Gesture

-(void)handleTapGesture:(UITapGestureRecognizer *)gestureReco{

    CGPoint touchLocation = [gestureReco locationInView:self.scrollView];
    NSLog(@"Tapped inside scrollView at x:%f y:%f",touchLocation.x, touchLocation.y);
  
    CGPoint newPt = [self.bodyView convertPoint:touchLocation fromView:self.scrollView];
    NSLog(@"New Point is %@", NSStringFromCGPoint(newPt));

//Creating a zero Pain Entry
    NSDictionary *locDict = nil;
    
    int zmLvl = (self.scrollView.zoomScale <0.06)?1:2;
    
    locDict = [self.bodyGeometry containsPoint:CGPointMake(newPt.x/BODY_VIEW_WIDTH, newPt.y/BODY_VIEW_HEIGHT) withZoomLVL:zmLvl];
       
    if (locDict) {

        if([self.bodyView doesEntryExist:[[[locDict allKeys]objectAtIndex:0]copy]]){
            [InvoDataManager painEntryForLocation:[locDict copy] LevelPain:0 notes:nil];
        }
    }

//Making changes to the text label
    NSString *name =  [self.bodyView removePainAtLocation:newPt];
    
    if (name) {
        if ([name isEqualToString:self.partNameLabel.text]) {
            [self.partNameLabel setText:@"NONE"];
            [self.partNameLabel setTextColor:[UIColor blackColor]];
        }
    }
    /*
    int tileNum = [self tileAtTouchLocation:touchLocation];
    NSLog(@"Tile which was tapped was %d",tileNum);

    bodyOffset = CGPointMake(touchLocation.x/(BODY_VIEW_WIDTH*self.scrollView.zoomScale),touchLocation.y/( BODY_VIEW_HEIGHT*self.scrollView.zoomScale));
    
    NSLog(@"The point with Respect to Global body Coordinates is x:%f y:%f",bodyOffset.x,bodyOffset.y);
*/
}

-(void)handleDoubleTap:(UIGestureRecognizer*)gestReco{

    NSLog(@"double tap happened");
    
    if (self.scrollView.zoomScale >=0.12) {
    
        //self.scrollView.zoomScale = 0.0623;
        [self.scrollView zoomToRect:CGRectMake(0, 0,BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT) animated:YES];

    }
    else{
        [self.scrollView zoomToRect:CGRectMake(0, 0,BODY_VIEW_WIDTH-1024*3, BODY_VIEW_HEIGHT-1024*3) animated:YES];
//        self.scrollView.zoomScale=0.0125;
//        [self.bodyView setNeedsDisplay];
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
    
    int numtoRet = (column <= 3 && row >=2)? (4*(row-1) + column): (row * column) ;
    
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
 
    [self.painFace increaseVisibility];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
   
    NSLog(@"Scale is %f",scale);
    
    [self.painFace increaseVisibility];

}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
   
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
   return YES;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
   
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   
    [self.painFace reduceVisibility];
    
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
   
     NSLog(@"Scale while beginning zooming is %f",scrollView.zoomScale);
    
    [self.painFace reduceVisibility];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
   
//    NSLog(@"ScrollView zoom scale is %f", scrollView.zoomScale);
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
//    NSLog(@"bodyview frame is %@", NSStringFromCGRect(self.bodyView.frame));
//    NSLog(@"returned bodyView");
    return self.bodyView;
}

#pragma mark -

#pragma mark PainFaceDel Method

-(void)checkForBodyIntersectionWithLocalPoint:(CGPoint)locPoint AndPainLvl:(int)painLvl {

    CGPoint convPoint = CGPointZero;
    
    convPoint = [self.view convertPoint:locPoint toView:self.scrollView];

//    NSLog(@"conv point is %@", NSStringFromCGPoint(convPoint));

    convPoint = CGPointMake((convPoint.x -70)/(BODY_VIEW_WIDTH*self.scrollView.zoomScale),convPoint.y/( BODY_VIEW_HEIGHT*self.scrollView.zoomScale));
    
    int zoomLVL = (self.scrollView.zoomScale >=0.062) ? 2 :1;

// Point is inside the Belly circle  

    NSDictionary *pathContainingPoint = nil;
    pathContainingPoint = [self.bodyGeometry containsPoint:convPoint withZoomLVL:zoomLVL];
    
    if (pathContainingPoint) {
        
        if(painLvl ==0){
        
            if([self.bodyView doesEntryExist:[[[pathContainingPoint allKeys]objectAtIndex:0]copy]]){
                [InvoDataManager painEntryForLocation:[pathContainingPoint copy] LevelPain:0 notes:nil];
            }
            
            //Making changes to the text label
            NSString *name =  [self.bodyView removePainAtLocation:CGPointMake(convPoint.x*BODY_VIEW_WIDTH, convPoint.y*BODY_VIEW_HEIGHT)];
            
            if (name) {
                if ([name isEqualToString:self.partNameLabel.text]) {
                    [self.partNameLabel setText:@"NONE"];
                    [self.partNameLabel setTextColor:[UIColor blackColor]];
                }
            }
        }
        else{
            UIColor *fillcolor = [self colorfromPain:painLvl];
            
            [self.bodyView renderPainForBodyPartPath:[[pathContainingPoint allValues] objectAtIndex:0] WithColor:fillcolor detailLevel:zoomLVL name:[[pathContainingPoint allKeys] objectAtIndex:0]];
            
            [self.partNameLabel setText:[[pathContainingPoint allKeys] objectAtIndex:0]];
            [self.partNameLabel setTextColor:fillcolor];
            
            [InvoDataManager painEntryForLocation:[pathContainingPoint copy] LevelPain:painLvl notes:nil];
            
            fillcolor = nil;
        }
    }
}

-(void)changeStrokeWithPoint:(CGPoint)dragPoint painLvl:(int)painLvl{

    if(painLvl!= 0){
        CGPoint convPoint = CGPointZero;
        
        convPoint = [self.view convertPoint:dragPoint toView:self.scrollView];
        
        //    NSLog(@"conv point is %@", NSStringFromCGPoint(convPoint));
        
        convPoint = CGPointMake((convPoint.x -70)/(BODY_VIEW_WIDTH*self.scrollView.zoomScale),convPoint.y/( BODY_VIEW_HEIGHT*self.scrollView.zoomScale));
        
        int zoomLVL = (self.scrollView.zoomScale >=0.062) ? 2 :1;
        
        if ( [self.bodyGeometry containsPoint:convPoint withZoomLVL:zoomLVL]) {
            
            UIColor *fillcolor = [self colorfromPain:painLvl];
            
            [self.bodyView maskWithColor:fillcolor];
            
        }
        else{
            
            [self.bodyView resetStroke];
        }
    }
}

-(void)blackStrokeForBody{

    [self.bodyView resetStroke];
}

#pragma mark -

#pragma mark color From pain Level

-(UIColor *)colorfromPain:(int)painLvl{

    UIColor *colorToFill = nil;
    
    switch (painLvl) {
        case 0:
            //colorToFill = [UIColor colorWithRed:0.00f green:0.00f blue:0.00f alpha:1.0f];
            break;
        case 1:
            colorToFill = [UIColor colorWithRed:0.99f green:0.71f blue:0.51f alpha:0.9f];               
            break;
        case 2:
            colorToFill = [UIColor colorWithRed:0.98f green:0.57f blue:0.26f alpha:0.9f];
            break;
        case 3:
            colorToFill = [UIColor colorWithRed:0.92 green:0.41 blue:0.42 alpha:0.9f];
            break;
        case 4:
            colorToFill = [UIColor colorWithRed:0.95 green:0.15 blue:0.21 alpha:0.9f];
            break;
        case 5:
            colorToFill = [UIColor colorWithRed:0.8 green:0.15 blue:0.24 alpha:0.9f];
            break;
            
        default:
            break;
    }

    return colorToFill;
}

#pragma mark -

#pragma mark Send Pressed

-(IBAction)sendPresed:(id)sender{

    NSLog(@"Send was pressed");
        
    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:NSLocalizedString(@"Your device is not able to send mail.", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
       
        return;
    }

//Image data of body
    
    NSData *img = [self.bodyView imageToAttachToReportWithZoomLevel:self.scrollView.zoomScale];
    
  //  NSArray *entries = [PainEntry last50PainEntries];
    NSArray *entries = [PainEntry last50PainEntr:^(NSError *error){
    
        NSLog(@"error was %@",[error localizedDescription]);
    }];
    
    NSString *str = @"";
    int num=1;
    for(NSDictionary *dict in entries){
    
        PainLocation *loc = [dict valueForKey:@"location"];
        NSDate *dte= [dict valueForKey:@"timestamp"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];

        NSString *newStr = [NSString stringWithFormat:@"%@ %@ PainLevel %d",[formatter stringFromDate:dte],[loc valueForKey:@"name"],[[dict valueForKey:@"painLevel"] integerValue]];
        
        str = [str stringByAppendingString:[NSString stringWithFormat:@"\n%d) %@",num,newStr]];
        num++;
    }
    num=0;

    MFMailComposeViewController *mailComp = [[MFMailComposeViewController alloc] init];
    
    [mailComp setSubject:[[self timeForReport] copy]];
    [mailComp setToRecipients:[NSArray arrayWithObject:@"dhaval@goinvo.com"]];
    [mailComp addAttachmentData:img mimeType:@"image/png" fileName:@"BodyReport"];
  
    [mailComp setMessageBody:str isHTML:NO];
    
    mailComp.mailComposeDelegate = self;
    
    [self presentModalViewController:mailComp animated:YES];
    
}

#pragma mark -
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark -

#pragma mark Time For Report

-(NSString *)timeForReport{

    NSDate *date = [NSDate date];
    NSString *title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];

    title = [NSString stringWithFormat:@"PainTrackr Report on %@",[formatter stringFromDate:date]];

    return [title copy];
}

#pragma mark -

@end
