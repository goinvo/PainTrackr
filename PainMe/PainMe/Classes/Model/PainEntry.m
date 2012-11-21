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

@interface PainEntry ()


@end

@implementation PainEntry

@dynamic notes;
@dynamic painLevel;
@dynamic timestamp;
@dynamic location;

+(void )painEntryWithTime:(NSDate *)time painLevel:(int16_t)level extraNotes:(NSString *)extraNotes location:(PainLocation *)painLoc{

    PainEntry *newEntry;
   
    InvoDataManager *dataManager = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *mangObjContext = [dataManager managedObjectContext];
            
    newEntry = (PainEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"PainEntry" inManagedObjectContext:mangObjContext];
    
    newEntry.painLevel = level;
    newEntry.notes = extraNotes;

//    NSLog(@"Time stamp is %lf",[time timeIntervalSinceNow]) ;
    newEntry.timestamp = [time timeIntervalSinceReferenceDate];
//    NSTimeInterval newInterval = 24*3*60*60;
//    NSDate *newDate = [time dateByAddingTimeInterval:newInterval];
//    newEntry.timestamp = [newDate timeIntervalSinceReferenceDate];
    
    newEntry.location = painLoc ;
    
    [dataManager saveContext];
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

+(NSArray *)arrayofEntiresSorted:(ErrorHandler)handler{

    InvoDataManager *dataManager = [InvoDataManager sharedDataManager];
    NSManagedObjectContext *mangObjContext = [dataManager managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:mangObjContext];
    
    NSFetchRequest *fetchReq =[[NSFetchRequest alloc] init];
    [fetchReq setEntity:entityDesc];
//    [fetchReq setPropertiesToFetch:[NSArray arrayWithObjects:@"location",@"notes",@"painLevel",@"timestamp", nil]];
    
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
