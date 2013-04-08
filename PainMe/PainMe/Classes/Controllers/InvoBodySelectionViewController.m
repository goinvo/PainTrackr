//
//  InvoBodySelectionViewControllerViewController.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InvoBodySelectionViewController.h"
#import "BodyView.h"
#import "InvoDataManager.h"
#import "BodyPartGeometry.h"
#import "PainEntry.h"
#import "PainLocation.h"
#import "InvoPartNameLabel.h"
#import "InvoHistoryViewController.h"
#import "InvoAboutViewController.h"
#import "InvoFlipButtonView.h"
#import "InvoPainColorHelper.h"
#import "InvoTextForEmail.h"

#import "UIDevice+deviceInfo.h"
#import "UIFont+PainTrackrFonts.h"

@interface InvoBodySelectionViewController () {
   
    CGPoint bodyOffset;
    UIActivityIndicatorView *indicator;
    UIView *grayOverLayView;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet BodyView *bodyView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) BodyPartGeometry *bodyGeometry;
@property (nonatomic, strong) PainFaceView *painFace;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIImageView *overLayView;

-(void)initTapGesture;
-(int)tileAtTouchLocation:(CGPoint)touchPt;

-(void)checkAndAddLastEntryToView;

-(IBAction)sendPresed:(id)sender;
-(IBAction)aboutPressed:(id)sender;

-(NSString *)timeForReport;
-(void)showMailToBeSent;

-(int)currentOrientation;
-(void)configFlipButtonImage;
-(void)removeBodyNamePopUp;

@end

@implementation InvoBodySelectionViewController

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
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    self.bodyView.frame = CGRectMake(70,0,BODY_VIEW_WIDTH *1.17, BODY_VIEW_HEIGHT);

    //40 for the BottomBar
    float appHeight =[[UIScreen mainScreen] applicationFrame].size.height -42;
    
    //helps define the zoomScale
    //to fit the view within the height of view
    float minZoomScale = appHeight/BODY_VIEW_HEIGHT;

    self.scrollView.minimumZoomScale = minZoomScale;
    self.scrollView.zoomScale = minZoomScale;
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
   
//Activity indicator
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setColor:[UIColor grayColor]];
    [indicator setCenter:CGPointMake(160, 240)];
    [self.view insertSubview:indicator aboveSubview:self.scrollView];
    
//Configuring image for flipButton
    [self configFlipButtonImage];
    
//Add a transparent overlay
    [self checkSaveNumberOfLaunches];
}

#pragma mark Check Number of AppLaunches
-(void)checkSaveNumberOfLaunches{
    
    NSArray *docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSLog(@"docDIrectory count is%d", [docDirectories count]);
    
    NSString *docDirectory = [docDirectories objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/LaunchNumber.txt",docDirectory];
    
    NSError *error2 ;
    NSString *launch = [[NSString alloc] initWithContentsOfFile:fileName
                                                   usedEncoding:nil
                                                          error:&error2];
    int timesLaunched = 0;
    timesLaunched = [launch intValue] ;
    
    if (timesLaunched ==0) {
        
        NSLog(@"Launching for first time");
        [self addCoachMarks];
    }
    
    timesLaunched +=1;
    NSString *numbr = [NSString stringWithFormat:@"%d",timesLaunched];
    NSError *error;
    [numbr writeToFile:fileName
            atomically:YES
              encoding:NSStringEncodingConversionAllowLossy
                 error:&error]; 
}

#pragma mark add/remove coachMarks
-(void)addCoachMarks{

    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    NSString *imgName = (frame.size.height > 480.0)? @"coachmarks_long.png":
    @"coachmarks.png";
    
    UIImageView *tmpView = [[UIImageView alloc]initWithFrame:frame];
    [tmpView setImage:[UIImage imageNamed:imgName]];
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:tmpView];
    _overLayView = tmpView;
    [_overLayView setExclusiveTouch:YES];
    [_overLayView becomeFirstResponder];
    
    [self makeViewsRecieveTouch:NO];
}

-(void)removeCoachMarks{

    if (_overLayView) {
        [_overLayView resignFirstResponder];
        [_overLayView removeFromSuperview];
        _overLayView = nil;
    }
    [self makeViewsRecieveTouch:YES];
}

#pragma mark  manage touches for Adding/Removing coachMarks
-(void)makeViewsRecieveTouch:(BOOL)isTouch{

    [self.painFace setUserInteractionEnabled:isTouch];
    [self.scrollView setUserInteractionEnabled:isTouch];
    [self.toolbarItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        [(UIBarButtonItem *)obj setEnabled:isTouch];
        //NSLog(@"Tool bar items are %@",self.toolbarItems);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (_overLayView) {
        [self removeCoachMarks];
    }
}



#pragma mark add the FlipButton
-(void)configFlipButtonImage{
    //0 = Front, 1 = Back
    int currentOrient = [self currentOrientation];
    
    CGRect flipRect = CGRectMake(253, 20, 40, 90);
    [self.flipButton setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8f]];
    [self.flipButton setFrame:flipRect];
    [self.flipButton setImage:[InvoFlipButtonView imageWithOrientation:currentOrient] forState:UIControlStateNormal];
}


#pragma mark Draw last entry if it exists
-(void)checkAndAddLastEntryToView{

    id entryToRender =   [[InvoDataManager sharedDataManager] lastPainEntryToRenderWithOrient:[self currentOrientation]];
        
    if (entryToRender) {
        //    NSLog(@"entry to render is %@",entryToRender);
        
        UIColor *fillColor = [InvoPainColorHelper colorfromPain:[[(PainEntry *)entryToRender valueForKey:@"painLevel"] integerValue]];
        
        if (fillColor) {
            PainLocation *loc = (PainLocation *)[entryToRender valueForKey:@"location"];
            int zoom = [[loc valueForKey:@"zoomLevel"] intValue];
            
            UIBezierPath *locpath = [self.bodyGeometry dictFrBodyLocation:[ [loc valueForKey:@"name"] copy]];
            
            [self.bodyView addObjToSHapesArrayWithShape:locpath color:fillColor detail:zoom name:[[loc valueForKey:@"name"] copy] orientation:[self currentOrientation]];
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

}

#pragma mark Handle Tap Gesture

-(void)removeBodyNamePopUp{

    InvoPartNamelabel *lbl = (InvoPartNamelabel *)[self.view viewWithTag:kTagPartNameBubble];
    if (lbl) {
        [lbl removeFromSuperview];
    }
}

-(void)handleTapGesture:(UITapGestureRecognizer *)gestureReco{

    if (_overLayView) {
        [_overLayView resignFirstResponder];
        [_overLayView removeFromSuperview];
        _overLayView = nil;
    }
    
    [self removeBodyNamePopUp];
        
    CGPoint touchLocation = [gestureReco locationInView:self.scrollView];
  
    CGPoint newPt = [self.bodyView convertPoint:touchLocation fromView:self.scrollView];
 
//Creating a zero Pain Entry
    NSDictionary *locDict = nil;
    
    int zmLvl = (self.scrollView.zoomScale <0.06)?1:2;
    
    locDict = [self.bodyGeometry containsPoint:CGPointMake(newPt.x/BODY_VIEW_WIDTH, newPt.y/BODY_VIEW_HEIGHT)
                                   withZoomLVL:zmLvl
                               withOrientation:[self currentOrientation]];
    
//Making changes to the text label
    NSString *name =  [self.bodyView partNameAtLocation:newPt withObj:[locDict copy] remove:NO];
    
    if (name) {
        
        CGPoint labelPt = [self.view convertPoint:touchLocation fromView:self.scrollView];
//        NSLog(@"label Pt should be %@", NSStringFromCGPoint(labelPt));
        CGSize labelSize = [name sizeWithFont:[UIFont bubbleFont]];
        
        float startX = [self xPosWithCurrentXPos:labelPt.x
                                      labelWidth:(labelSize.width+10)];
        
        float startY = [self yPosWithCurrentYPos:labelPt.y
                                     labelHeight:labelSize.height];
               
        InvoPartNamelabel *bble = [[InvoPartNamelabel alloc] initWithFrame:CGRectMake(startX, startY, labelSize.width+10, 20)
                                                                      name:[name copy]];
        [bble setTag:kTagPartNameBubble];
        [bble.layer setCornerRadius:5.0f];
        [bble.layer setMasksToBounds:YES];
        [self.view insertSubview:bble atIndex:100];
    }
}

-(float)xPosWithCurrentXPos:(float)currPos labelWidth:(float)currWidth{
    float frameWidth = [[UIScreen mainScreen] applicationFrame].size.width;
    float toReturn = currPos;
  
    if (toReturn< 0) {
        toReturn +=10.0f;
    }else if ((toReturn + currWidth)> frameWidth){
        toReturn = frameWidth - (currWidth +20);
    }
    return toReturn;
}

-(float)yPosWithCurrentYPos:(float)currPos labelHeight:(float)currHeight{
    
    float frameHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    float toReturn = currPos;
    
    if ((toReturn + currHeight)> (frameHeight - 50)){
        toReturn -= (currHeight+10);
    }
    return toReturn;
}

-(void)handleDoubleTap:(UIGestureRecognizer*)gestReco{

    [self removeBodyNamePopUp];
    
    if (self.scrollView.zoomScale >=0.065) {
    
        [self.scrollView zoomToRect:CGRectMake(0, 0,BODY_VIEW_WIDTH, BODY_VIEW_HEIGHT) animated:YES];
    }
    else{
        [self.scrollView zoomToRect:CGRectMake(0, 0,BODY_VIEW_WIDTH-1024*3, BODY_VIEW_HEIGHT-1024*3) animated:YES];
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

    column = floorf(ceilf(column));
    
    int numtoRet = (column <= 3 && row >=2)? (4*(row-1) + column): (row * column) ;
    
    return (numtoRet);
}
#pragma mark-

- (void)viewDidUnload
{
    [self setFlipButton:nil];
    [self setViewLabelButton:nil];
    [super viewDidUnload];
    // Release any stronged subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark UIScrollViewDelegate methods


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
 
    [self.painFace increaseVisibility];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
   
//    NSLog(@"Scale is %f",scale);
    
    [self.painFace increaseVisibility];

}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
   return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   
    [self.painFace reduceVisibility];
    [self removeBodyNamePopUp];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
   
//     NSLog(@"Scale while beginning zooming is %f",scrollView.zoomScale);
    
    [self.painFace reduceVisibility];
    [self removeBodyNamePopUp];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
//    NSLog(@"bodyview frame is %@", NSStringFromCGRect(self.bodyView.frame));
//    NSLog(@"returned bodyView");
    return self.bodyView;
}

#pragma mark -

#pragma mark PainFaceDel Method

-(void)checkForBodyIntersectionWithLocalPoint:(CGPoint)locPoint andPainLvl:(int)painLvl {

    CGPoint convPoint = CGPointZero;
    
    convPoint = [self.view convertPoint:locPoint toView:self.scrollView];

//    NSLog(@"conv point is %@", NSStringFromCGPoint(convPoint));

    convPoint = CGPointMake((convPoint.x -70)/(BODY_VIEW_WIDTH*self.scrollView.zoomScale),convPoint.y/( BODY_VIEW_HEIGHT*self.scrollView.zoomScale));
    
    int zoomLVL = (self.scrollView.zoomScale >=0.062) ? 2 :1;

// Point is inside the Belly circle  

    NSDictionary *pathContainingPoint = nil;
    pathContainingPoint = [self.bodyGeometry containsPoint:convPoint withZoomLVL:zoomLVL withOrientation:[self currentOrientation]];
    
    if (pathContainingPoint) {

        NSString *name = [[[pathContainingPoint allKeys]objectAtIndex:0]copy] ;
        int level;
        UIBezierPath *bezierShape = nil;
        id values = [pathContainingPoint valueForKey:name];
        for (id value in values) {
            if ([value isKindOfClass:[NSNumber class]]) {
                level = [(NSNumber *)value intValue];
            }
            else bezierShape = [value copy];
        }
        if(painLvl ==0){
        
            if ([self.bodyView doesEntryExist:name withZoomLevel:level]) {
                UIColor *fillcolor = [InvoPainColorHelper colorfromPain:painLvl];
                
                [self.bodyView renderPainForBodyPartPath:bezierShape WithColor:[UIColor clearColor] detailLevel:zoomLVL name:[[pathContainingPoint allKeys] objectAtIndex:0] orient:[self currentOrientation]];
                fillcolor = nil;

                [InvoDataManager painEntryForLocation:[pathContainingPoint copy] levelPain:0 notes:nil];
            }
            return;
        }
        else{
        
            UIColor *fillcolor = [InvoPainColorHelper colorfromPain:painLvl];
            
            [self.bodyView renderPainForBodyPartPath:bezierShape WithColor:fillcolor detailLevel:zoomLVL name:[[pathContainingPoint allKeys] objectAtIndex:0] orient:[self currentOrientation]];
            fillcolor = nil;
            
            [InvoDataManager painEntryForLocation:[pathContainingPoint copy] levelPain:painLvl notes:nil];
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
        
        if ( [self.bodyGeometry containsPoint:convPoint withZoomLVL:zoomLVL withOrientation:[self currentOrientation]]) {
            
            UIColor *fillcolor = [InvoPainColorHelper colorfromPain:painLvl];
            
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

#pragma mark Send Pressed

-(IBAction)sendPresed:(id)sender{

//    NSLog(@"Send was pressed");
    
    [indicator startAnimating];
    [self.sendButton setEnabled:NO];
    
    CGSize overLayeSize = [[UIScreen mainScreen]applicationFrame].size;
    
    grayOverLayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, overLayeSize.width, overLayeSize.height)];
    [grayOverLayView setBackgroundColor:[UIColor blackColor]];
    [grayOverLayView setAlpha:0.4f];
    [self.view addSubview:grayOverLayView];
   
    [self performSelector:@selector(showMailToBeSent) withObject:nil afterDelay:0.001];
}

-(void)showMailToBeSent{

    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:NSLocalizedString(@"Your device is not able to send mail.", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        [grayOverLayView removeFromSuperview];
        [indicator stopAnimating];
        [self.sendButton setEnabled:YES];
        
        return;
    }
    
    //Image data of body
    
    NSData *img = [self.bodyView imageToAttachToReportWithZoomLevel:self.scrollView.zoomScale];
  
    NSString *bodyText = [InvoTextForEmail bodyTextForEmailWithImage:[img copy]];
    
    MFMailComposeViewController *mailComp = [[MFMailComposeViewController alloc] init];
    
    [mailComp setSubject:[[self timeForReport] copy]];
    //    [mailComp setToRecipients:[NSArray arrayWithObject:@"dhaval@goinvo.com"]];
    [mailComp addAttachmentData:img mimeType:@"image/png" fileName:@"BodyReport"];
    
    [mailComp setMessageBody:bodyText isHTML:NO];
    
    mailComp.mailComposeDelegate = self;
    
    [self presentViewController:mailComp animated:YES completion:^(){

        [grayOverLayView removeFromSuperview];
        [indicator stopAnimating];

    } ];

}

#pragma mark -
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissModalViewControllerAnimated:YES];
    [self.sendButton setEnabled:YES];
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

#pragma mark About tapped

-(IBAction)aboutPressed:(id)sender{

    InvoAboutViewController *aboutCtrl = [[InvoAboutViewController alloc]initWithNibName:nil bundle:nil];
    
    [self.navigationController pushViewController:aboutCtrl animated:YES];
}
#pragma mark -

- (IBAction)flipTapped:(id)sender {

    [self.bodyView flipView];
    [self checkAndAddLastEntryToView];
    [self configFlipButtonImage];
    
    (0 ==[self currentOrientation])?[self.viewLabelButton setTitle:@"Front View"]:
    [self.viewLabelButton setTitle:@"Back View"];
}

-(int)currentOrientation{

    return (([self.bodyView.currentView isEqualToString:@"front"])?0:1);
}
@end
