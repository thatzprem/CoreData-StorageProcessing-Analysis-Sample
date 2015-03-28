//
//  AppDelegate.m
//  coredataTest
//
//  Created by Prem kumar on 18/03/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+CoreData.h"
#import "Customer+Create.h"
#import "CustomerDatabaseAvailabilty.h"
#import "NSJSONSerialization+Additions.h"
#import "Customer+Delete.h"

@interface AppDelegate()

@property (nonatomic,strong)NSManagedObjectContext *globalDatabaseContext;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.globalDatabaseContext = [self createMainQueueManagedObjectContext];
//    [self createDBEntry:@"test_rec_3000"];
    return YES;
}

- (void)deleteAllRecordsInDB
{
//    dispatch_queue_t queue;
//    queue = dispatch_queue_create("DeleteDBQueue", NULL);
//    dispatch_sync(queue, ^{        
        [Customer deleteAllCustomersInManagedObjectContext:self.globalDatabaseContext];
        NSDictionary *userInfo = self.globalDatabaseContext? @{CustomerDataBaseEmptyContext: self.globalDatabaseContext} :nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:CustomerDatabaseEmptyNotification object:self userInfo:userInfo];
//    });
    
}

- (void)createDBEntry:(NSString *)filePath{
     NSArray *itemsArray = [[NSArray alloc] init];
//    dispatch_queue_t queue;
//    queue = dispatch_queue_create("JsonParsingQueue", NULL);
//    dispatch_sync(queue, ^{
    
    NSDate *startTime = [NSDate date];

        NSString* path = [[NSBundle mainBundle] pathForResource:filePath
                                                         ofType:@"json"];
        NSData *fileContent = [[NSData alloc] initWithContentsOfFile:path];
        NSString *jsonString = [NSJSONSerialization convertNSDataToJsonString:fileContent];
        NSDictionary *jsonDict = [NSJSONSerialization convertJsonStringToDictionary:jsonString];
        itemsArray = [jsonDict valueForKeyPath:@"features"];
        NSLog(@"Features items count: %lu",(unsigned long)[itemsArray count]);
        
        [self createCustomerDetails:itemsArray];
        NSString *alertString = [NSString stringWithFormat:@"Executed in %.2fsecs",[[NSDate date] timeIntervalSinceDate:startTime]];
        
        NSDictionary *userInfo1 = alertString? @{CustomerDataBaseUpdateContext:alertString} :nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:CustomerDatabaseUpdateNotification object:self userInfo:userInfo1];
        
        NSDictionary *userInfo = self.globalDatabaseContext? @{CustomerDataBaseAvailabilityContext: self.globalDatabaseContext} :nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:CustomerDatabaseAvailabilityNotification object:self userInfo:userInfo];
//    });
}

-(void)createCustomerDetails:(NSArray *)featuresArray{
    for (NSDictionary *feature in featuresArray) {
        NSString *blklotString = [feature valueForKeyPath:@"properties.BLKLOT"];
        [Customer customerWithName:blklotString inManagedObjectContext:self.globalDatabaseContext];
    }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Fetch Initated...");
    NSURL *url = [self generateFetchURL];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    sessionConfig.allowsCellularAccess = NO;
    sessionConfig.timeoutIntervalForRequest = 10.0;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                                                        if (error)
                                                        {
                                                            NSLog(@"Background fetch failed: %@", error.localizedDescription);
                                                            completionHandler(UIBackgroundFetchResultNoData);
                                                        } else
                                                        {
                                                            NSLog(@"Background fetch successful...");
                                                            NSDictionary *flickrPropertyList;
                                                            NSData *flickrJSONData = [NSData dataWithContentsOfURL:localFile];
                                                            if (flickrJSONData) {
                                                                flickrPropertyList = [NSJSONSerialization JSONObjectWithData:flickrJSONData options:0 error:NULL];
                                                            }
                                                            [self createCustomerDetails:[flickrPropertyList allValues]];
                                                            completionHandler(UIBackgroundFetchResultNewData);
                                                        }
                                                    }];
    [task resume];
}

- (int)getRandomNumber{
    return arc4random() % 100;
}

//Method to generate a random fetch URL.
- (NSURL *)generateFetchURL{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://echo.jsontest.com/name1/testName%d/name2/testName%d/name3/testName%d/name4/testName%d",[self getRandomNumber],[self getRandomNumber],[self getRandomNumber],[self getRandomNumber]]];
}

@end
