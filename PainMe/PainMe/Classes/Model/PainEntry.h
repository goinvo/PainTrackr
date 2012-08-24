//
//  PainEntry.h
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "ErrorHandler.h"

typedef void(^ErrorHandler)(NSError *);

@class PainLocation;

@interface PainEntry : NSManagedObject

@property (nonatomic, retain) NSString * notes;
@property (nonatomic) int16_t painLevel;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic, retain) PainLocation *location;

+(void )painEntryWithTime:(NSDate *)time PainLevel:(int16_t)level ExtraNotes:(NSString *)extraNotes Location:(PainLocation *)painLoc;

+(NSArray *)last50PainEntriesIfError:(ErrorHandler)handler;
@end
