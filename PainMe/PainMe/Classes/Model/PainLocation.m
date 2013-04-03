//
//  PainLocation.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//


#import "PainLocation.h"
#import "PainEntry.h"


@implementation PainLocation

@dynamic name;
@dynamic shape;
@dynamic zoomLevel;
@dynamic painEntries;
@dynamic orientation;

+(void)enterPainEntryForLocation:(NSDictionary *)locdict levelPain:(int)painLvl notes:(NSString *)notes{


    PainLocation *locFound  = nil;
    
    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *moc = [dtaMgr objContext];
    NSEntityDescription *entyDescrip = [NSEntityDescription  entityForName:@"PainLocation" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc] init];
    [fetchreq setEntity:entyDescrip];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@",[[locdict allKeys] objectAtIndex:0]];
    [fetchreq setPredicate:pred];
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:fetchreq error:&error];
    
    if (result && [result count]>0) {

        locFound = (PainLocation *)[result objectAtIndex:0];
//        NSLog(@"PainLocation found is %@", locFound.name);
    }
    
    NSSet *entriesForLocation = locFound.painEntries;
    NSArray *sortedEntries = [entriesForLocation sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    //NSLog(@"sortedEntries are %@",sortedEntries);
    
    if(sortedEntries.count >0){
        int levelOfFoundEntry = [[[sortedEntries objectAtIndex:0] valueForKey:@"painLevel"] integerValue];
        
        if(levelOfFoundEntry != painLvl){
            NSDate *now = [[NSDate alloc] init];
            
            [PainEntry painEntryWithTime:now painLevel:painLvl extraNotes:[notes copy] location:locFound];
        }
    }
    else{
        NSDate *now = [[NSDate alloc] init];
        
        [PainEntry painEntryWithTime:now painLevel:painLvl extraNotes:[notes copy] location:locFound];
    }
}


+(void)locationEntryWithName:(NSString *)locName shape:(NSData *)shape zoomLevel:(int16_t)levZoom orientation:(int16_t)orient{

    PainLocation *locFound;
   
    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *moc = [dtaMgr objContext];
    NSEntityDescription *entyDescrip = [NSEntityDescription  entityForName:@"PainLocation" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc] init];
    [fetchreq setEntity:entyDescrip];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@",locName];
    [fetchreq setPredicate:pred];
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:fetchreq error:&error];
    
    if (result && [result count]>0) {
        return;
    }
    
    locFound = [NSEntityDescription insertNewObjectForEntityForName:@"PainLocation" inManagedObjectContext:moc];
    locFound.name = [locName copy];
    locFound.zoomLevel = levZoom;
    locFound.shape = (NSData *)[shape copy];
    locFound.orientation = ((orient==0)?orientationFront : orientationBack);
//    [dtaMgr saveContext];
}
 

+(NSArray *)painLocations{

    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *moc = [dtaMgr objContext];
    NSEntityDescription *entyDescrip = [NSEntityDescription  entityForName:@"PainLocation" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc] init];
    [fetchreq setEntity:entyDescrip];
    [fetchreq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *CrDta = [[dtaMgr objContext] executeFetchRequest:fetchreq error:&error];
//    NSLog(@"value in PainLocation is %@", CrDta);
    
    return CrDta;
}

 
@end
