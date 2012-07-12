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

+(PainEntry *)painEntryWithTime:(NSDate *)time Location:(NSData *)location PainLevel:(int16_t)level ExtraNotes:(NSString *)extraNotes{

    PainEntry *entryFound;
   
    InvoAppDelegate *appDel = (InvoAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *mangObjContext = [appDel managedObjectContext];
    
    NSEntityDescription *entDesc = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:mangObjContext];
    
    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:entDesc];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"location == %@", location];
//    
//    [req setPredicate:pred];
    
    NSError *error = nil;
    NSArray *resultArray = [mangObjContext executeFetchRequest:req error:&error];
    
    if (error) {
        NSLog(@"Fetch req had an error :%@",[error localizedDescription]);
    }
    if (resultArray && [resultArray count]>0) {
        entryFound = [resultArray objectAtIndex:0];
    }
    else {
        entryFound = (PainEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"PainEntry" inManagedObjectContext:mangObjContext];
        
        //entryFound.location = location;
        //entryFound.timestamp = time;
        entryFound.painLevel = level;
        entryFound.notes = extraNotes;
        [appDel saveContext];
    }
    
    return entryFound;
}
@end
