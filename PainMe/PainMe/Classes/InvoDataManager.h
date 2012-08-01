//
//  InvoDataManager.h
//  PainMe
//
//  Created by Dhaval Karwa on 7/19/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSV.h"
#import "CHCSVParser.h"

@interface InvoDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain) NSMutableArray *parsedComponents;
@property (nonatomic, retain) NSMutableArray *vertRange;
@property (nonatomic, retain) NSArray *nwArrVert;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(InvoDataManager *)sharedDataManager;
-(void)listCoordinates;
-(void)checkPainLocationDataBase;
+(void)painEntryForLocation:(NSDictionary *)locDetails LevelPain:(int)painLvl notes:(NSString *)nots;
@end
