//
//  PainEntry.m
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
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

//    NSLog(@"Time stamp is %lf",[time timeIntervalSinceNow]) ;
    newEntry.timestamp = [time timeIntervalSinceReferenceDate];
    
    newEntry.location = painLoc ;
//    NSLog(@"was entering new pain Entry");
    
    [dataManager saveContext];
    
//     NSLog(@"Entered new pain Entry");
}


+(NSArray *)last50PainEntriesIfError:(ErrorHandler)handler{

    InvoDataManager *dataManager = [InvoDataManager sharedDataManager];
    NSManagedObjectContext *mangObjContext = [dataManager managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:mangObjContext];
    
    NSFetchRequest *fetchReq =[[NSFetchRequest alloc] init];
    [fetchReq setEntity:entityDesc];
    [fetchReq setFetchLimit:50];
    
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    [fetchReq setSortDescriptors:[NSArray arrayWithObject:desc]];
    
    NSError *error = nil;
    NSArray *result = [mangObjContext executeFetchRequest:fetchReq error:&error];
    
    if (!error) {
        
        if (result &&[result count]>0) {
            return result;
        }
    }
    else{
        handler(error);
    }
    
    return nil; 
}
@end
