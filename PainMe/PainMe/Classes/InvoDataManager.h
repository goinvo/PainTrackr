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


@property (nonatomic,strong) NSMutableArray *parsedComponents;
@property (nonatomic, strong) NSMutableArray *vertRange;
@property (nonatomic, strong) NSArray *nwArrVert;

@property (nonatomic, strong) NSFetchedResultsController *fetCtrl;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(InvoDataManager *)sharedDataManager;

+(BOOL)painEntryForLocation:(NSDictionary *)locDetails levelPain:(int)painLvl notes:(NSString *)nots;

-(void)listCoordinates;
-(void)checkPainLocationDataBase;

-(NSArray *)totalPainEntriesForPart:(NSString *)pName;

//-(id)painEntryToRenderWithOrient:(int)orient justOne:(BOOL)isOnlyOne;

-(NSArray *)namesOfBodyParts;

-(NSDictionary *)entriesPerDayList;

-(NSManagedObjectContext *) objContext;
@end
