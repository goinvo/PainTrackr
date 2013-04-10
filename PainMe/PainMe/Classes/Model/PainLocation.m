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

+(BOOL)enterPainEntryForLocation:(NSDictionary *)locdict levelPain:(int)painLvl notes:(NSString *)notes{


    PainLocation *locFound  = nil;
    BOOL toRet = NO;
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
        NSLog(@"PainLocation found is %@", locFound.name);
    }
    
    NSSet *entriesForLocation = locFound.painEntries;
    NSArray *sortedEntries = [entriesForLocation sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    //NSLog(@"sortedEntries are %@",sortedEntries);
    
    if(sortedEntries.count >0){
        int levelOfFoundEntry = [[[sortedEntries objectAtIndex:0] valueForKey:@"painLevel"] integerValue];
        NSDate *timeStamp = [[sortedEntries objectAtIndex:0] valueForKey:@"timestamp"] ;
        NSDate *now = [[NSDate alloc] init];
        if(levelOfFoundEntry != painLvl){
            toRet = YES;
            [PainEntry painEntryWithTime:now painLevel:painLvl extraNotes:[notes copy] location:locFound];
        }
        else{
            
            NSLog(@"gotta handle this Else of founfEntry and painLevel");
            NSCalendar *cal = [NSCalendar currentCalendar];
            unsigned int unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit ;
            NSDateComponents *foundComps = [cal components:unitFlags fromDate:timeStamp];
            NSDateComponents *currComps = [cal components:unitFlags fromDate:now];
            
            if ([foundComps month] != [currComps month] || [foundComps day] != [currComps day] || [foundComps year] != [currComps year]) {
                toRet = YES;
                [PainEntry painEntryWithTime:now painLevel:painLvl extraNotes:[notes copy] location:locFound];
            }
            
//            NSLog(@"foundComps %@ currComps:%@",foundComps, currComps); 
//            NSLog(@"time stamp is %@", timeStamp);
//            NSLog(@"time now is %@",now);
        }
    }
    else{
        NSDate *now = [[NSDate alloc] init];
        toRet = YES;
        [PainEntry painEntryWithTime:now painLevel:painLvl extraNotes:[notes copy] location:locFound];
    }
    return toRet;
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

+(NSArray *)painEntriesForOrientation:(int)orient zoomLevel:(int)zoom{
    
    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    
    NSManagedObjectContext *moc = [dtaMgr objContext];
    NSEntityDescription *entyDescrip = [NSEntityDescription  entityForName:@"PainLocation" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc] init];
    [fetchreq setEntity:entyDescrip];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orientation == %d && zoomLevel == %d",orient, zoom];
    
    [fetchreq setPredicate:predicate];
    //[fetchreq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *allLocations = [[dtaMgr objContext] executeFetchRequest:fetchreq error:&error];
    
    if (!error && [allLocations count]) {
        return allLocations;
    }
    return nil;
}

+(id)painEntryToRenderWithOrient:(int)orient Zoom:(int)zoomLvl {

    NSMutableArray *arrToReturn = [NSMutableArray array];
    
    InvoDataManager *dataManager = [InvoDataManager sharedDataManager];
    NSManagedObjectContext *moc = [dataManager objContext];
    NSEntityDescription *entyDescrip = [NSEntityDescription  entityForName:@"PainLocation" inManagedObjectContext:moc];
    
    NSFetchRequest *fetchreq = [[NSFetchRequest alloc] init];
    [fetchreq setEntity:entyDescrip];

//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
//    [fetchreq setSortDescriptors:[NSArray arrayWithObject:sort]];
    
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"orientation == %d&& zoomLevel == %d",orient, zoomLvl];
    [fetchreq setPredicate:predicate];
    //[fetchreq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *allLocations = [[dataManager objContext] executeFetchRequest:fetchreq error:&error];
    
    if (!error && [allLocations count]) {
        
        for (PainLocation *loc in allLocations) {
            
            NSLog(@"painEntries for loc:%@ ",loc.name);
            int count = 0;
            count = [[loc painEntries] count];
            if (count) {
                
                NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]];
                
                NSArray *sortedRecipes = [[[loc painEntries] allObjects] sortedArrayUsingDescriptors:sortDescriptors];
                
                PainEntry *latestObj = [sortedRecipes objectAtIndex:0];
//                PainEntry *latestObj = [[[loc painEntries]allObjects] objectAtIndex:count-1];
                NSCalendar *cal = [NSCalendar currentCalendar];
                unsigned int unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit| NSYearCalendarUnit ;
                //todays date components
                NSDateComponents *currComps = [cal components:unitFlags fromDate:[NSDate date]];
                
                NSDateComponents *fetchedComp = [cal components:unitFlags
                                                       fromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:latestObj.timestamp]];
                
                 if( fetchedComp.day == currComps.day && fetchedComp.month == currComps.month && fetchedComp.year == currComps.year){
        
                    NSLog(@"entry created on %@",[NSDate dateWithTimeIntervalSinceReferenceDate:latestObj.timestamp]);
                     [arrToReturn addObject:latestObj];
                 }
            }
         }
        return arrToReturn;
    }
    return nil;
}




@end
