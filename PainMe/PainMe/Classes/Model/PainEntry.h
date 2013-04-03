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

@property (nonatomic, strong) NSString * notes;
@property (nonatomic) int16_t painLevel;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic, strong) PainLocation *location;

+(void )painEntryWithTime:(NSDate *)time painLevel:(int16_t)level extraNotes:(NSString *)extraNotes location:(PainLocation *)painLoc;

+(NSArray *)last50PainEntriesIfError:(ErrorHandler)handler;
+(NSArray *)arrayofEntiresSorted:(ErrorHandler)handler;

@end
