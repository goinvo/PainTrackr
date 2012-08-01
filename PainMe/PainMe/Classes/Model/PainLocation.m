//
//  PainLocation.m
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//


#import "PainLocation.h"
#import "PainEntry.h"


@implementation PainLocation

@dynamic name;
@dynamic shape;
@dynamic zoomLevel;
@dynamic painEntries;


+(void)enterPainEntryForLocation:(NSDictionary *)locdict LevelPain:(int)painLvl notes:(NSString *)notes{

    
    PainLocation *locFound  = nil;
    
    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *moc = [dtaMgr managedObjectContext];
    NSEntityDescription *entyDescrip = [NSEntityDescription  entityForName:@"PainLocation" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc] init];
    [fetchreq setEntity:entyDescrip];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name == %@",[[locdict allKeys] objectAtIndex:0]];
    [fetchreq setPredicate:pred];
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:fetchreq error:&error];
    
    if (result && [result count]>0) {

        locFound = (PainLocation *)[result objectAtIndex:0];
        NSLog(@"PainLocation found is %@", locFound.name);
    }
    
    NSDate *now = [[NSDate alloc] init];
    
    [PainEntry painEntryWithTime:now PainLevel:painLvl ExtraNotes:[notes copy] Location:locFound];

    
}


+(void)LocationEntryWithName:(NSString *)locName Shape:(NSData *)shape ZoomLevel:(int16_t)levZoom {

    PainLocation *locFound;
   
    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *moc = [dtaMgr managedObjectContext];
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
    [dtaMgr saveContext];
}
 

+(NSArray *)painLocations{

    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *moc = [dtaMgr managedObjectContext];
    NSEntityDescription *entyDescrip = [NSEntityDescription  entityForName:@"PainLocation" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc] init];
    [fetchreq setEntity:entyDescrip];
    [fetchreq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *CrDta = [dtaMgr.managedObjectContext executeFetchRequest:fetchreq error:&error];
//    NSLog(@"value in PainLocation is %@", CrDta);
    
    return CrDta;
}
 
 
@end
