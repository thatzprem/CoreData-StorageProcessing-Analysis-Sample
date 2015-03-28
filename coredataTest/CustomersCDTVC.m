//
//  CustomersCDTVC.m
//  CoreDataPOC
//
//  Created by Prem kumar on 18/03/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import "CustomersCDTVC.h"
#import "Customer.h"
#import "CustomerDatabaseAvailabilty.h"
#import "AppDelegate.h"

@interface CustomersCDTVC ()

@end

@implementation CustomersCDTVC

- (void)awakeFromNib{
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CustomerDatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//        self.managedObjectContext = note.userInfo[CustomerDataBaseAvailabilityContext];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CustomerDatabaseEmptyNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
//        self.managedObjectContext = note.userInfo[CustomerDataBaseEmptyContext];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.tableView reloadData];
            self.title = [NSString stringWithFormat:@"%lu items found",(unsigned long)[self.fetchedResultsController.fetchedObjects count]];
        });
    }];
}
- (IBAction)refreshButtonPressed:(id)sender
{ 
   
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Customer"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"blklot" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.title = [NSString stringWithFormat:@"%lu items found",(unsigned long)[self.fetchedResultsController.fetchedObjects count]];
    });
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Customer Cell"];
    Customer *customer = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",customer.blklot];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)prepareViewController:(id)vc
                     forSegue:(NSString *)segueIdentifer
                fromIndexPath:(NSIndexPath *)indexPath
{

}

// boilerplate
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    [self prepareViewController:segue.destinationViewController
                       forSegue:segue.identifier
                  fromIndexPath:indexPath];
}

@end
