//
//  InvoDataManager.m
//  PainMe
//
//  Created by Dhaval Karwa on 7/19/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "InvoDataManager.h"

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


@interface InvoDataManager ()

-(void)getVertxPtsFromString:(NSString *)str;
-(void)fillVertRangeFrom:(NSArray *)rngArr;
-(BOOL)painLocationsInDatabase;
@end


@implementation InvoDataManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize vertRange = _vertRange;
@synthesize nwArrVert = _nwArrVert;
@synthesize parsedComponents = _parsedComponents;


+(InvoDataManager *)sharedDataManager{

    static InvoDataManager *instance = nil;
    
    @synchronized([InvoDataManager class]){
    
        if (!instance) {
            instance = [[super allocWithZone:NULL] init];
        }
    }
   return instance;
}

+(id)allocWithZone:(NSZone *)zone{

   return [self sharedDataManager];
}


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

-(id)init{

    self = [super init];
    if (self) {
        
        NSLog(@"Beginning...");
        
        
        if (NO == [self painLocationsInDatabase]) {
            
            self.parsedComponents = [NSMutableArray array];
            
            NSStringEncoding encoding = 0;
            // NSString *file = @"/Users/DDKarwa/Desktop/tmpCsvParse/Workbook1.csv";
            NSString *file = [[NSBundle mainBundle] pathForResource:@"T2" ofType:@"csv"];
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
  //        NSLog(@"%@", a);
            
            NSString *s = [a CSVString];
            
            NSArray *newArr = [s CSVComponents];
            
  //        NSLog(@" Array is %d",[newArr count]);
            
            for (id obj in newArr) {
                
                NSArray *rangeArr = [[obj objectAtIndex:2] componentsSeparatedByString:@"|"];
                
                [self fillVertRangeFrom:rangeArr];
                
                NSString *vert = [obj objectAtIndex:3];
                
                [self getVertxPtsFromString:vert];
                
            }

        }
        
        
        /*
         NSEntityDescription *descript = [NSEntityDescription entityForName:@"PainEntry" inManagedObjectContext:self.managedObjectContext];
         
         NSFetchRequest *fetReq = [[NSFetchRequest alloc] init];
         [fetReq setEntity:descript];
         [fetReq setResultType:NSDictionaryResultType];
         
         NSError *error;
         NSArray *CrDta = [self.managedObjectContext executeFetchRequest:fetReq error:&error];
         NSLog(@"value in COreData PainEntry is %@", CrDta);

         */
    }
    return self;
}

-(void)getVertxPtsFromString:(NSString *)str{
    
    self.nwArrVert = [str componentsSeparatedByString:@"|"];
    
    /*
    int coordCount = [self.nwArrVert count];
    if(coordCount >0){
        for (int i=0; i<coordCount; i++) {
            
//            if (NSLocationInRange(i, )) {
//                <#statements#>
//            }
        }
    }
    */
    
    for (NSString *tmp in self.nwArrVert) {
        
        NSString  *nTmp = [tmp stringByReplacingOccurrencesOfString:@";" withString:@","];
        NSLog(@" Coordinates are %@", NSStringFromCGPoint(CGPointFromString(nTmp)));
    }
     
}

-(void)fillVertRangeFrom:(NSArray *)rngArr{
    
    NSArray *newArr = [rngArr copy];
    rngArr = nil;
    
    self.vertRange =[NSMutableArray array];
    
    for (NSString *tmp in newArr) {
        
        NSRange range = NSRangeFromString(tmp);
        
        NSLog(@"range is %@", NSStringFromRange(range));
        
        NSRange rng = [tmp rangeOfString:@">"];
        NSString *subTmp = [NSString stringWithString:[tmp substringFromIndex:rng.location+1]];
        
        subTmp = [subTmp stringByReplacingOccurrencesOfString:@";" withString:@","];
        
        NSLog(@"points for range are %@", NSStringFromCGPoint(CGPointFromString(subTmp)));
        
        [self.vertRange addObject:NSStringFromCGPoint(CGPointFromString(subTmp))];
    }
    
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

        NSLog(@"value in COreData PainLocation is %@", crDta);
        toReturn = YES;
    }
    
    return toReturn;
}

#pragma mark -
@end
