//
//  InvoDataManager.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/19/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "InvoDataManager.h"
#import "PainLocation.h"
#import "PainEntry.h"

#define NUM_COLUMNS 8.0
#define NUM_ROWS 17.0
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
	NSLog(@"ERROR: %@", error);
}
@end


@interface InvoDataManager (){

    CGPoint *_pts;
}

@property (nonatomic, readonly)NSInteger pointCount;
@property (nonatomic, retain)NSMutableDictionary *dict;

-(void)getDataFromCSVInDict;

-(BOOL)painLocationsInDatabase;
-(void) setPointCount: (NSInteger) newPoints;

@end


@implementation InvoDataManager

@synthesize pointCount = _pointCount;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize vertRange = _vertRange;
@synthesize nwArrVert = _nwArrVert;
@synthesize parsedComponents = _parsedComponents;


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

/*
+(id)alloc{

    @synchronized([InvoDataManager class]){
        instance = [super alloc];
    }
    return instance;
}
*/

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

/*
-(id)init{

    self = [super init];
    if (self) {
        
        NSLog(@"Beginning...");
    }
    return self;
}

 */
-(void)checkPainLocationDataBase{

    if (NO == [self painLocationsInDatabase]) {
        
        [self getDataFromCSVInDict];
        [self listCoordinates];
    }

}



-(void)getDataFromCSVInDict{
    
    NSLog(@"Beginning...");
	NSStringEncoding encoding = 0;
    // NSString *file = @"/Users/DDKarwa/Desktop/tmpCsvParse/Workbook1.csv";
    NSString *file = [[NSBundle mainBundle] pathForResource:@"NewData" ofType:@"csv"];
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
    NSError *error = nil;
    
	CHCSVParser * p = [[CHCSVParser alloc] initWithStream:stream usedEncoding:&encoding error:&error];
	
	NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
	
	Delegate * d = [[Delegate alloc] init];
	[p setParserDelegate:d];
	
	NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	[p parse];
	NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
	
	NSLog(@"raw difference: %f", (end-start));
    
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
    
//        NSLog(@"DICTIONARY VALUES  for key Left up :%@",[self.dict valueForKey:@"Left up Leg"]);
    
}

-(void)listCoordinates{
    
   // NSArray *neckValues = [self.dict valueForKey:@"Left up Leg"];
    
    NSArray *dictKeys = [self.dict allKeys];
    
    for (NSString *ky in dictKeys) {
        
        NSArray *valArray = [self.dict valueForKey:ky];
        
        int itmCount = [valArray count];
      
        [self setPointCount:itmCount];

        int i=0;
        
        for (NSArray *arr in valArray) {

            float xadd = [[arr objectAtIndex:2] floatValue];
            float yadd = [[arr objectAtIndex:3] floatValue];
            float xCoor = [[arr objectAtIndex:4] floatValue];
            float yCoor = [[arr objectAtIndex:5] floatValue];
            
//            CGPoint newPt = CGPointMake((xadd/NUM_COLUMNS) + (xCoor/BODY_WIDTH), (yadd/NUM_ROWS) +(yCoor/BODY_HEIGHT));
//            
//            NSLog(@"newPt for key:%@ is :%@", ky,NSStringFromCGPoint(newPt));
            _pts[i]=CGPointMake((xadd/NUM_COLUMNS) + (xCoor/BODY_WIDTH), (yadd/NUM_ROWS) +(yCoor/BODY_HEIGHT));
            i++;
        }
    
    NSData *shapeVertices = [NSData dataWithBytes:_pts length:sizeof(CGPoint)*itmCount];

    int zoomLvl = [[[valArray objectAtIndex:0] objectAtIndex:1] integerValue];
    
    [PainLocation LocationEntryWithName:[ky copy] Shape:shapeVertices ZoomLevel:zoomLvl];
       
    valArray = nil;
    
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
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
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

#pragma mark Check If painLocation Database is filled

-(BOOL)painLocationsInDatabase{

    BOOL toReturn = NO;
    
    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainLocation" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *crDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    if ([crDta count]>0) {

//        NSLog(@"value in COreData PainLocation is %@", crDta);
        toReturn = YES;
    }
    
    fetReq = nil;
    return toReturn;
}

#pragma mark -

#pragma mark pain location enrty

+(void)painEntryForLocation:(NSDictionary *)locDetails LevelPain:(int)painLvl notes:(NSString *)nots{

    [PainLocation enterPainEntryForLocation:[locDetails copy] LevelPain:painLvl notes:[nots copy]];
}

-(int)totalPainEntries{

    
    /*
    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];
    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"location.name like face "];
//    [fetReq setPredicate:pred];
    
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];

    NSLog(@"value in COreData PainEntry is %d", [CrDta count]);
    
    return [CrDta count];
 */
    
    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];

    NSPredicate *predictae = [NSPredicate predicateWithFormat:@"Any location.name Like[c] %@",@"face"];
    [fetReq setPredicate:predictae];
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error = nil;
    NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    NSLog(@"value in COreData PainEntry is %d", [CrDta count]);
    
    return [CrDta count];
}

-(NSArray *)painLevelsForAllEntries{

    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];
    
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    NSMutableArray *painLevelArr = [NSMutableArray array];
    
    for (int i=0; i<[CrDta count];i++) {
        
        NSDictionary *dict = [CrDta objectAtIndex:i];
        [painLevelArr addObject:[dict valueForKey:@"painLevel"]];
    }
    
//    NSLog(@"value in COreData PainEntry is %@", CrDta);
    
    return [painLevelArr copy];
}

-(NSArray *)timeStampsForPainEntries{

    NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:descript];
    
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    NSMutableArray *painTimeArr = [NSMutableArray array];
    
    for (int i=0; i<[CrDta count];i++) {
        
        NSDictionary *dict = [CrDta objectAtIndex:i];
        NSDate *stmp = [dict valueForKey:@"timestamp"];
        
        [painTimeArr addObject:stmp];
    }
    
//    NSLog(@"value in COreData PainEntry is %@", CrDta);
    
    return [painTimeArr copy];

}

-(id)lastPainEntryToRender{

    
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
    [fetReq setEntity:ent];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    [fetReq setSortDescriptors:[NSArray arrayWithObject:sort]];
        
    [fetReq setResultType:NSDictionaryResultType];
    
    NSError *error;
    NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
    
    if ([CrDta count] >0) {
        
        return [CrDta objectAtIndex:0];
        
    }
    return nil;
}

#pragma mark -


@end
