//
//  PainLocation.h
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "InvoDataManager.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum{

    orientationFront =0,
    orientationBack
    
} orientationTags;

@class PainEntry;

@interface PainLocation : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id shape;
@property (nonatomic) int16_t zoomLevel;
@property (nonatomic, retain) NSSet *painEntries;
@property (nonatomic) int16_t orientation;
@end

@interface PainLocation (CoreDataGeneratedAccessors)

- (void)addPainEntriesObject:(PainEntry *)value;
- (void)removePainEntriesObject:(PainEntry *)value;
- (void)addPainEntries:(NSSet *)values;
- (void)removePainEntries:(NSSet *)values;


+(void)enterPainEntryForLocation:(NSDictionary *)locdict levelPain:(int)painLvl notes:(NSString *)notes ;


+(void)locationEntryWithName:(NSString *)locName shape:(NSData *)shape zoomLevel:(int16_t)levZoom orientation:(int16_t)orient;

+(NSArray *)painLocations;
@end
