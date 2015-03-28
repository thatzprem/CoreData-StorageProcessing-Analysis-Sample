//
//  Customer.h
//  CoreDataStoragePOC
//
//  Created by Prem kumar on 03/04/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customer : NSManagedObject

@property (nonatomic, retain) NSNumber * blklot;
@property (nonatomic, retain) NSNumber * block_num;
@property (nonatomic, retain) NSString * from_st;
@property (nonatomic, retain) NSNumber * lot_num;
@property (nonatomic, retain) NSNumber * mapblklot;
@property (nonatomic, retain) NSString * odd_even;
@property (nonatomic, retain) NSString * st_type;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * to_st;

@end
