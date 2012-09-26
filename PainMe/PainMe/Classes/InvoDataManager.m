//
//  InvoDataManager.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/19/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "InvoDataManager.h"


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

@property (nonatomic, readonly)NSInteger pointCount;
@property (nonatomic, retain)NSMutableDictionary *dict;
@property (nonatomic, retain)NSMutableArray *keysFromStoredLocData;

-(void)getDataFromCSVInDict;

-(void)painLocationsInDatabase;
-(void)setPointCount: (NSInteger) newPoints;
-(BOOL)painLocationExists:(NSString*)locName;
-(int)totalLocations;
@end


@implementation InvoDataManager

@synthesize pointCount = _pointCount;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize vertRange = _vertRange;
@synthesize nwArrVert = _nwArrVert;
@synthesize parsedComponents = _parsedComponents;
@synthesize keysFromStoredLocData = _keysFromStoredLocData;


@synthesize dict =_dict;
@synthesize fetCtrl;

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


- (void)saveContext
{
//    NSLog(@"Saving COntext");
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        
//        NSLog(@" managedObjectContext is not nil");
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
        }
    }
}

/*
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

    [self painLocationsInDatabase];
    
    if(137 != [self totalLocations]){
            
        [self getDataFromCSVInDict];
        [self listCoordinates];
    }
}

#pragma mark get painLocation Data from database

-(void)painLocationsInDatabase{
      
    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainLocation" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    NSArray *locData = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    //    NSLog(@"Entries are %@ with count %d", locData,[locData count]);
    self.keysFromStoredLocData = [NSMutableArray array];
    
    for (NSDictionary *dicti in locData) {
        //getting all names
        [self.keysFromStoredLocData addObject:[[dicti allValues]objectAtIndex:0]];
    }
}


-(int)totalLocations{

    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainLocation" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    NSArray *locData = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    //    NSLog(@"Entries are %@ with count %d", locData,[locData count]);
    self.keysFromStoredLocData = [NSMutableArray array];
    
    for (NSDictionary *dicti in locData) {
        //getting all names
        [self.keysFromStoredLocData addObject:[[dicti allValues]objectAtIndex:0]];
    }
    return [locData count];
}

#pragma mark -

#pragma mark Get data from CSV file
-(void)getDataFromCSVInDict{
    
//    NSLog(@"Beginning...");
	NSStringEncoding encoding = 0;
    // NSString *file = @"/Users/DDKarwa/Desktop/tmpCsvParse/Workbook1.csv";
    NSString *file = [[NSBundle mainBundle] pathForResource:@"BodyPartData" ofType:@"csv"];
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
    NSError *error = nil;
    
	CHCSVParser * p = [[CHCSVParser alloc] initWithStream:stream usedEncoding:&encoding error:&error];
	
//	NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
	
	Delegate * d = [[Delegate alloc] init];
	[p setParserDelegate:d];
	
//	NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	[p parse];
//	NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
	
//	NSLog(@"raw difference: %f", (end-start));
    
    NSArray *a = [NSArray arrayWithContentsOfCSVFile:file encoding:encoding error:nil];
    //    NSLog(@"%@", a);
    NSString *s = [a CSVString];
    
    //    NSLog(@"s is %@",s);
    
    NSArray *csvArray = [s CSVComponents];
//    NSLog(@" Array is %d",[csvArray count]);
    
    self.dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *dictValueArray =[[NSMutableArray alloc] init];
    
    
    NSString *prevString =[[csvArray objectAtIndex:0] objectAtIndex:0];
    
    for (int i=0;i<[csvArray count];i++) {
        
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

    for (NSString *str in self.keysFromStoredLocData) {
        
        if ([locName isEqualToString:str]) {
            
            return YES;
        }
    }
    return NO;
}

#pragma mark create location entries into PainLocation database
-(void)listCoordinates{
    
    
    NSArray *dictKeys = [self.dict allKeys];
    
    for (NSString *ky in dictKeys) {
        
        if ([dictKeys count]!=[self.keysFromStoredLocData count]) {
        
            if (![self painLocationExists:[ky copy]])
            {
                NSArray *valArray = [self.dict valueForKey:ky];
                
                int itmCount = [valArray count];
                
                [self setPointCount:itmCount];
                
                int i=0;
                
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
                
                [PainLocation locationEntryWithName:[ky copy] shape:shapeVertices zoomLevel:zoomLvl];
                
                valArray = nil;
            }
        }
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
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PainMe" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PainMe.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: options error:&error]) {
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
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -


#pragma mark pain location enrty

+(void)painEntryForLocation:(NSDictionary *)locDetails levelPain:(int)painLvl notes:(NSString *)nots{

    [PainLocation enterPainEntryForLocation:[locDetails copy] levelPain:painLvl notes:[nots copy]];
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
//    count = [CrDta count];
        
//    NSLog(@"value in COreData PainEntry is %d", [CrDta count]);
        
    }
    
    return [CrDta copy];
}


-(id)lastPainEntryToRender{

    NSEntityDescription *ent = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:ent];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    [fetReq setSortDescriptors:[NSArray arrayWithObject:sort]];
        
//    [fetReq setResultType:NSDictionaryResultType];
    [fetReq setPropertiesToFetch:[NSArray arrayWithObjects:@"location",@"notes",@"painLevel",@"timestamp", nil]];
    
    NSError *error;
    NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    if ([CrDta count] >0) {
        
        return [CrDta objectAtIndex:0];
    }
    return nil;
}


-(NSArray *)namesOfBodyParts{

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PainLocation" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetreq = [[NSFetchRequest alloc] init];
    [fetreq setEntity:entity];
    [fetreq setResultType:NSDictionaryResultType];
    
    NSMutableArray *arrtoRet = [NSMutableArray array];
    NSError *error = nil;
    
    NSArray *data = [self.managedObjectContext executeFetchRequest:fetreq error:&error];
    
    if ([data count] >0) {
        
        for (NSDictionary *arr in data) {
            
            [arrtoRet addObject:[[arr valueForKey:@"name"] copy]];
        }
        return [arrtoRet copy];
    }
    return nil;
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
    [formatter setDateStyle:NSDateFormatterShortStyle];

   // NSString *currDate =[formatter stringFromDate:[(NSDictionary *)[totalEntries objectAtIndex:0] valueForKey:@"timestamp"]];
    
    NSString *prevDate = [formatter stringFromDate:[(NSDictionary *)[totalEntries objectAtIndex:0] valueForKey:@"timestamp"]];
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i=0; i<[totalEntries count];i++) {
        
  
        PainEntry *entry = [totalEntries objectAtIndex:i];
        NSString *currDate;
        
        if(entry){
            currDate = [formatter stringFromDate:[entry valueForKey:@"timestamp"]] ;
            
            if (![currDate isEqualToString:prevDate]) {
                
                [dateSortedEntries setValue:arr forKey:prevDate];
                arr = [NSMutableArray array];
                
                if(![arr containsObject:entry]){
                    [arr addObject:entry];
                }
            }
            else if (i == [totalEntries count]-1){
            
                id value = [dateSortedEntries valueForKey:currDate];
                if (!value) {
                    [dateSortedEntries setValue:arr forKey:currDate];
                }
            }
            if(![arr containsObject:entry]){
                [arr addObject:entry];
            }

            prevDate = currDate;
        }
        
    }
//    NSLog(@"date sorted entries are %@",dateSortedEntries);
    return( ([totalEntries count]>0 )?[dateSortedEntries copy]:nil);
}
#pragma mark -


@end
