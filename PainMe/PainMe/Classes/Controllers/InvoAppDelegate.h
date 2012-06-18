//
//  InvoAppDelegate.h
//  PainMe
//
//  Created by Garrett Christopher on 6/18/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
