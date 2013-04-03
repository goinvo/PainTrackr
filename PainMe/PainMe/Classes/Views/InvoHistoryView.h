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

//@property (nonatomic, strong)UIImage *imgRet;
@property (nonatomic, strong)id <HistoryViewDelegate> del;
@property (nonatomic, assign)int orientation1;
@property (nonatomic, assign)int orientation2;

- (id)initWithFrame:(CGRect)frame locations:(NSArray *)shapesDict date:(NSString *)stringDate ;

@end
