//
//  Customer+Create.h
//  CoreDataPOC
//
//  Created by Prem kumar on 18/03/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import "Customer.h"

@interface Customer (Create)

+ (Customer *)customerWithName:(NSString *)name
       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
