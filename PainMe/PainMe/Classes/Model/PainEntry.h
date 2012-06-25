//
//  PainEntry.h
//  PainMe
//
//  Created by Garrett Christopher on 6/21/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PainLocation;

@interface PainEntry : NSManagedObject

@property (nonatomic, retain) NSString * notes;
@property (nonatomic) int16_t painLevel;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic, retain) PainLocation *location;

@end
