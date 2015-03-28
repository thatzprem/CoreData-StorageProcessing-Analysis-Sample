//
//  Customer+Delete.h
//  CoreDataStoragePOC
//
//  Created by Prem kumar on 03/04/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import "Customer.h"

@interface Customer (Delete)

+ (void)deleteAllCustomersInManagedObjectContext:(NSManagedObjectContext *)context;

@end
