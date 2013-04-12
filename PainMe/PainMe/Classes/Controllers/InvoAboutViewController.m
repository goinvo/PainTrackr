//
//  InvoAboutViewController.m
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/26/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import "InvoAboutViewController.h"

@interface InvoAboutViewController ()

-(IBAction)painTrackrLogoPressed:(id)sender;
-(IBAction)feedbackPressed:(id)sender;
@end

@implementation InvoAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)painTrackrLogoPressed:(id)sender{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.paintrackr.com"]];
}

-(IBAction)feedbackPressed:(id)sender{

    if (![MFMailComposeViewController canSendMail]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:NSLocalizedString(@"Your device is not able to send mail.", @"") delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    MFMailComposeViewController *mailComp = [[MFMailComposeViewController alloc] init];
    [mailComp setSubject:@"Feedback for PainTrackr App"];
    [mailComp setToRecipients:[NSArray arrayWithObject:@"paintrackr-feedback@goinvo.com"]];
    mailComp.mailComposeDelegate = self;
    [self presentModalViewController:mailComp animated:YES ];

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{

    [controller dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
   
    [super viewDidUnload];
}

- (IBAction)linkTapped:(id)sender {

     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.paintrackr.com"]];
}
@end
