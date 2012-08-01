//
//  PainEntry.m
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "PainEntry.h"
#import "PainLocation.h"
#import "InvoDataManager.h"

@implementation PainEntry

@dynamic notes;
@dynamic painLevel;
@dynamic timestamp;
@dynamic location;

+(void )painEntryWithTime:(NSDate *)time PainLevel:(int16_t)level ExtraNotes:(NSString *)extraNotes Location:(PainLocation *)painLoc{

    PainEntry *newEntry;
   
    InvoDataManager *dataManager = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *mangObjContext = [dataManager managedObjectContext];
            
    newEntry = (PainEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"PainEntry" inManagedObjectContext:mangObjContext];
    
    newEntry.painLevel = level;
    newEntry.notes = extraNotes;

    NSLog(@"Time stamp is %lf",[time timeIntervalSinceNow]) ;
    newEntry.timestamp = [time timeIntervalSinceReferenceDate];
    
    newEntry.location = painLoc ;
        
    [dataManager saveContext];
    
}
@end
