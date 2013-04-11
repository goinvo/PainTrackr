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

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(InvoDataManager *)sharedDataManager;

-(NSArray *)totalPainEntriesForPart:(NSString *)pName;

-(NSDictionary *)entriesPerDayList;

-(NSManagedObjectContext *) objContext;

+(BOOL)painEntryForLocation:(NSDictionary *)locDetails levelPain:(int)painLvl notes:(NSString *)nots;

-(void)listCoordinates;
-(void)checkPainLocationDataBase;

@end
