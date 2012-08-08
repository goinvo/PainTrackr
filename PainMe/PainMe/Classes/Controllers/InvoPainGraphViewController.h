//
//  InvoPainGraphViewController.h
//  PainMe
//
//  Created by Dhaval Karwa on 8/1/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface InvoPainGraphViewController : UIViewController<CPTPlotDataSource,UIPickerViewDelegate>

-(IBAction)pickerBttonTapped:(id)sender;

@end
