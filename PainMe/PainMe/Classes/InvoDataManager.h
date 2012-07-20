//
//  InvoDataManager.h
//  PainMe
//
//  Created by Dhaval Karwa on 7/19/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(InvoDataManager *)sharedDataManager;
@end
