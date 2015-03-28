//
//  AppDelegate+CoreData.h
//  coredataTest
//
//  Created by Prem kumar on 18/03/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (CoreData)

- (NSManagedObjectContext *)createMainQueueManagedObjectContext;

- (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

@end
