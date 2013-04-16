//
//  InvoDetailedHistoryViewController.h
//  PainTrackr
//
//  Created by Dhaval Karwa on 9/24/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoDetailedHistoryViewController : UIViewController <UIScrollViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil date:(NSString *)dateString painEntriesByDate:(NSDictionary *)sortedDict;
@end
