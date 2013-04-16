//
//  InvoDataManager.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/19/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

// CUrrent total number of locations is 245

#import "InvoDataManager.h"
//257
#define MAX_LOCATIONS 257

#define NUM_COLUMNS 4.0
#define NUM_ROWS 9.0
#define BODY_WIDTH (1024*NUM_COLUMNS)
#define BODY_HEIGHT (1024*NUM_ROWS)


@interface Delegate : NSObject <CHCSVParserDelegate>
@end


@implementation Delegate

- (void) parser:(CHCSVParser *)parser didStartDocument:(NSString *)csvFile {
    //	NSLog(@"parser started: %@", csvFile);
}
- (void) parser:(CHCSVParser *)parser didStartLine:(NSUInteger)lineNumber {
    //	NSLog(@"Starting line: %lu", lineNumber);
}
- (void) parser:(CHCSVParser *)parser didReadField:(NSString *)field {
    //	NSLog(@"   field: %@", field);
}
- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber {
    //	NSLog(@"Ending line: %lu", lineNumber);
}
- (void) parser:(CHCSVParser *)parser didEndDocument:(NSString *)csvFile {
    //	NSLog(@"parser ended: %@", csvFile);
}
- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
//	NSLog(@"ERROR: %@", error);
}
@end


@interface InvoDataManager (){

    CGPoint *_pts;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, readonly)NSInteger pointCount;
@property (nonatomic, strong)NSMutableDictionary *dict;
@property (nonatomic, strong)NSMutableArray *keysFromStoredLocData;

-(void)getDataFromCSVInDict;

-(int)painLocationsInDatabase;
-(void)setPointCount: (NSInteger) newPoints;
-(BOOL)painLocationExists:(NSString*)locName;
//-(int)totalLocations;
@end


@implementation InvoDataManager

-(void)dealloc{

    if (_pts) free(_pts);
}

 static InvoDataManager *instance = nil;


+(InvoDataManager *)sharedDataManager{

	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
	return instance;
}

/*
//useful for debugging purposes 
-(id)init{

    self = [super init];
    if (self) {
        
        NSLog(@"Beginning...");
        
        NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
        
        NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
        [fetReq setEntity:descript];

        NSError *error = nil;
        NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
        NSLog(@"Entries ");
    }
    return self;
}
*/
 
-(void)checkPainLocationDataBase{

    //check to see if stored locations
    //are not equal to actual
    //App comes preloaded with a sqlite file
    if(MAX_LOCATIONS != [self painLocationsInDatabase]){
            
        [self getDataFromCSVInDict];
        [self listCoordinates];
    }
}

#pragma mark get painLocation Data from database

-(int)painLocationsInDatabase{
        
    self.keysFromStoredLocData = [NSMutableArray array];
    NSArray *allLocations = [PainLocation painLocations];
    
    if (allLocations) {
     
        for (NSDictionary *dict in allLocations) {
            //getting all names
            [self.keysFromStoredLocData addObject:[[dict allValues]objectAtIndex:0]];
        }
//        NSLog(@"count is %d",[self.keysFromStoredLocData count]);
        return [self.keysFromStoredLocData count];
    }
    return 0;
}

#pragma mark -

#pragma mark Get data from CSV file
-(void)getDataFromCSVInDict{
    
//    NSLog(@"Beginning...");
	NSStringEncoding encoding = 0;
    //if the user already has data front locations
    //and is missing the backView pain Locations
    NSString *file = [[NSBundle mainBundle] pathForResource:@"BackViewData" ofType:@"csv"];
//      NSString *file = [[NSBundle mainBundle] pathForResource:@"NewBodyPartData" ofType:@"csv"];
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
    NSError *error = nil;
    
    //using the CHCSV parser to aprse through the body csv data
	CHCSVParser * p = [[CHCSVParser alloc] initWithStream:stream usedEncoding:&encoding error:&error];
	
	Delegate * d = [[Delegate alloc] init];
	[p setParserDelegate:d];
	
//	NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	[p parse];
//	NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
	
//	NSLog(@"raw difference: %f", (end-start));
    
    NSArray *a = [NSArray arrayWithContentsOfCSVFile:file encoding:encoding error:nil];
    NSString *s = [a CSVString];
    
    NSArray *csvArray = [s CSVComponents];
    int csvArrayCount = [csvArray count];
    
    self.dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *dictValueArray =[[NSMutableArray alloc] init];
    
    NSString *prevString =[[csvArray objectAtIndex:0] objectAtIndex:0];
    
    for (int i=0;i<csvArrayCount;i++) {
        
        NSArray *obj = [csvArray objectAtIndex:i];
        NSString *keyString = [obj objectAtIndex:0];
        
        if ([keyString isEqualToString:prevString]) {
            
            [dictValueArray addObject:obj];
        }
        else{
            
            [self.dict setValue:[dictValueArray copy] forKey:[prevString copy]];
            dictValueArray = [NSMutableArray array];
            
            prevString = [keyString copy];
            [dictValueArray addObject:obj];
        }
        
        if (i==[csvArray count]-1) {
            
            [self.dict setValue:[dictValueArray copy] forKey:[prevString copy]];
        }
    }
}

#pragma mark check if location exists in database
-(BOOL)painLocationExists:(NSString*)locName{
    
    if ([self.keysFromStoredLocData containsObject:locName]) {
//        NSLog(@"exists");
        return YES;
    }
    return NO;
}

#pragma mark create location entries into PainLocation database
-(void)listCoordinates{
    
    
    NSArray *dictKeys = [self.dict allKeys];
    
    for (NSString *ky in dictKeys) {
        
        if ([dictKeys count]!=[self.keysFromStoredLocData count]) {
            
            if ([ky isEqualToString:@"Posterior Head"]) {
                
//                NSLog(@"details are %@",ky);
            }
            
            NSArray *valArray = [self.dict valueForKey:ky];
            
            int itmCount = [valArray count];
            
            [self setPointCount:itmCount];
            
            int i=0;
            
            NSString *orientString = [[valArray objectAtIndex:0] objectAtIndex:6];
            int16_t orientation =  ([orientString isEqualToString:@"Back"])?1:0;
            
            for (NSArray *arr in valArray) {
                
                float xadd = [[arr objectAtIndex:2] floatValue];
                float yadd = [[arr objectAtIndex:3] floatValue];
                float xCoor = [[arr objectAtIndex:4] floatValue];
                float yCoor = [[arr objectAtIndex:5] floatValue];
                
                _pts[i]=CGPointMake((xadd/NUM_COLUMNS) + (xCoor/BODY_WIDTH), (yadd/NUM_ROWS) +(yCoor/BODY_HEIGHT));
                i++;
            }
            
            NSData *shapeVertices = [NSData dataWithBytes:_pts length:sizeof(CGPoint)*itmCount];
            
            int zoomLvl = [[[valArray objectAtIndex:0] objectAtIndex:1] integerValue];
            
            if ([ky isEqualToString:@"Posterior Head"]) {
                
//                NSLog(@"details are %@ zoom%d orient%d",ky,zoomLvl, orientation );
            }
            
            [PainLocation locationEntryWithName:[ky copy] shape:shapeVertices zoomLevel:zoomLvl orientation:orientation ];
            
            valArray = nil;
            
        }
    }
    [self saveContext];
    [self.keysFromStoredLocData removeAllObjects];
    [self painLocationsInDatabase];
    
    [self.dict removeAllObjects];
   
    if (_pts) {
        free(_pts);
        _pts = nil;
    }
    
}

-(void)setPointCount:(NSInteger)newPoints{

    if (_pts) free(_pts);
    _pts = calloc(sizeof(CGPoint), newPoints);
    _pointCount = newPoints;
    
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{

    if(!_managedObjectContext ){
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel ) {
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PainMe" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator ){
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PainMe.sqlite"];
    
        //NSString *storePath = [storeURL path];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:[storeURL path]]) {
            NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"PainMe" withExtension:@"sqlite"];
            if (defaultStoreURL) {
                [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
            }
        }
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: options error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
            
            //        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //        abort();
        }
    }
    return _persistentStoreCoordinator;
}

#pragma mark save the ManagedObject Context
- (void)saveContext
{
    //    NSLog(@"Saving COntext");
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //            abort();
        }
    }
}

#pragma mark -
-(NSManagedObjectContext *) objContext{
    
    return self.managedObjectContext;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -


#pragma mark pain location enrty

+(BOOL)painEntryForLocation:(NSDictionary *)locDetails levelPain:(int)painLvl notes:(NSString *)nots{

   return [PainLocation enterPainEntryForLocation:[locDetails copy] levelPain:painLvl notes:[nots copy]];
}

-(NSArray *)totalPainEntriesForPart:(NSString *)pName{

     NSArray *CrDta;
    
    if (pName && ![pName isEqualToString:@""]) {
    
    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];

    NSPredicate *predictae = [NSPredicate predicateWithFormat:@"Any location.name Like[c] %@",pName];
    [fetReq setPredicate:predictae];
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
        
    }
    
    return [CrDta copy];
}

-(NSDictionary *)entriesPerDayList{

//    int totalNum = 0;
    NSMutableDictionary *dateSortedEntries = [NSMutableDictionary dictionary];

    NSArray *totalEntries;
     totalEntries = [PainEntry arrayofEntiresSorted:^(NSError *err) {

        if (err) {
            NSLog(@"There was an error %@ while gettin entries",[err localizedDescription]);
        }
    }];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterShortStyle];

    NSDate *date = [[(NSDictionary *)[totalEntries objectAtIndex:0] valueForKey:@"timestamp"]copy];
   
    NSString *prevDate = [formatter stringFromDate:date];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i=0; i<[totalEntries count];i++) {
        
        PainEntry *entry = [totalEntries objectAtIndex:i];
        NSString *currDate = nil;
        
        if(entry){
            NSDate *entryDate = [[entry valueForKey:@"timestamp"] copy];
            currDate = [formatter stringFromDate:entryDate];
            
            if (![currDate isEqualToString:prevDate]) {
                
                [dateSortedEntries setValue:arr forKey:[prevDate copy] ];
                arr = [NSMutableArray array];
                
                if(![arr containsObject:entry]){
                    [arr addObject:entry];
                }
            }
            else if (i == [totalEntries count]-1){
            
                id value = [dateSortedEntries valueForKey:currDate];
                if (!value) {
                    [dateSortedEntries setValue:arr forKey:[currDate copy]];
                }
            }
            if(![arr containsObject:entry]){
                [arr addObject:entry];
            }

            prevDate = [currDate copy];
            currDate = nil;
        }
    }
    prevDate = nil;

    return( ([totalEntries count]>0 )?[dateSortedEntries copy]:nil);
}

@end
