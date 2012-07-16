//
//  PainLocation.h
//  PainMe
//
//  Created by Garrett Christopher on 6/25/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PainEntry;

@interface PainLocation : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id shape;
@property (nonatomic) int16_t zoomLevel;
@property (nonatomic, retain) NSSet *painEntries;
@end

@interface PainLocation (CoreDataGeneratedAccessors)

- (void)addPainEntriesObject:(PainEntry *)value;
- (void)removePainEntriesObject:(PainEntry *)value;
- (void)addPainEntries:(NSSet *)values;
- (void)removePainEntries:(NSSet *)values;

//+(void)LocationEntryWithName:(NSString *)locName Shape:(NSData *)shape ZoomLevel:(int16_t)levZoom;
@end
