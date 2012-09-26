//
//  InvoHistoryView.h
//  PainTrackr
//
//  Created by Dhaval Karwa on 8/30/12.
//  Copyright (c) 2012 InvolutionStudios. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvoHistoryViewController;

@protocol HistoryViewDelegate <NSObject>

@optional

-(void)daySelectedWas:(NSString *)str;

@end

@interface InvoHistoryView : UIView

//@property (nonatomic, retain)UIImage *imgRet;
@property (nonatomic, retain)id <HistoryViewDelegate> del;

- (id)initWithFrame:(CGRect)frame locations:(NSArray *)shapesDict date:(NSString *)stringDate ;

@end
