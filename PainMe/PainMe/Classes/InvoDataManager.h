//
//  InvoDataManager.h
//  PainMe
//
//  Created by Dhaval Karwa on 7/19/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSV.h"
#import "CHCSVParser.h"
#import "PainLocation.h"
#import "PainEntry.h"

@interface InvoDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain) NSMutableArray *parsedComponents;
@property (nonatomic, retain) NSMutableArray *vertRange;
@property (nonatomic, retain) NSArray *nwArrVert;

@property (nonatomic, retain) NSFetchedResultsController *fetCtrl;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(InvoDataManager *)sharedDataManager;

+(void)painEntryForLocation:(NSDictionary *)locDetails LevelPain:(int)painLvl notes:(NSString *)nots;

-(void)listCoordinates;
-(void)checkPainLocationDataBase;

-(NSArray *)totalPainEntriesForPart:(NSString *)pName;

-(id)lastPainEntryToRender;

-(NSArray *)namesOfBodyParts;

-(NSDictionary *)entriesPerDayList;

@end
