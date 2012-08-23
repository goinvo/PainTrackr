//
//  InvoAppDelegate.h
//  PainMe
//
//  Created by Garrett Christopher on 6/18/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PrintThis)(NSString *);

@interface InvoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)IamPrint:(PrintThis)printing;

@end
