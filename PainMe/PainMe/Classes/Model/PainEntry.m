//
//  PainEntry.m
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "PainEntry.h"
#import "PainLocation.h"
#import "InvoAppDelegate.h"

@implementation PainEntry

@dynamic notes;
@dynamic painLevel;
@dynamic timestamp;
@dynamic location;

+(void)painEntryWithTime:(NSDate *)time Location:(UIBezierPath *)location PainLevel:(int16_t)level ExtraNotes:(NSString *)extraNotes{

    PainEntry *newEntry;
   
    InvoAppDelegate *appDel = (InvoAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *mangObjContext = [appDel managedObjectContext];
            
    newEntry = (PainEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"PainEntry" inManagedObjectContext:mangObjContext];
    
    newEntry.painLevel = level;
    newEntry.notes = extraNotes;
    newEntry.timestamp = [time timeIntervalSinceNow];
    
    PainLocation *newPainLoc = (PainLocation *)[NSEntityDescription insertNewObjectForEntityForName:@"PainLocation" inManagedObjectContext:mangObjContext];
   
    newPainLoc.zoomLevel = 1;
    newPainLoc.name = @"Belly Button";
    newPainLoc.shape = location;
                                    
        
    [appDel saveContext];
//    }
    
 //   return entryFound;
}
@end
