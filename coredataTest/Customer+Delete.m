//
//  Customer+Delete.m
//  CoreDataStoragePOC
//
//  Created by Prem kumar on 03/04/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import "Customer+Delete.h"

@implementation Customer (Delete)

+ (void)deleteAllCustomersInManagedObjectContext:(NSManagedObjectContext *)context{
    
    NSFetchRequest * allRecords = [[NSFetchRequest alloc] init];
    [allRecords setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:context]];
    [allRecords setIncludesPropertyValues:NO];
    NSError * error = nil;
    NSArray * records = [context executeFetchRequest:allRecords error:&error];
    for (NSManagedObject * record in records) {
        [context deleteObject:record];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}
@end
