//
//  InvoMasterViewController.h
//  PainMe
//
//  Created by Garrett Christopher on 6/18/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvoDetailViewController;

#import <CoreData/CoreData.h>

@interface InvoMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) InvoDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
