//
//  TestStorageTVC.m
//  CoreDataStoragePOC
//
//  Created by Prem kumar on 03/04/14.
//  Copyright (c) 2014 happiestminds. All rights reserved.
//

#import "TestStorageTVC.h"
#import "AppDelegate.h"
#import "AppDelegate.h"
#import "CustomerDatabaseAvailabilty.h"

@interface TestStorageTVC ()

@property (nonatomic,strong)NSArray *itemsArray;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic,strong) NSDate *startDate;

@end

@implementation TestStorageTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)clearDBButtonPressed:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.spinner startAnimating];
    });
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate deleteAllRecordsInDB];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CustomerDatabaseUpdateNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = note.userInfo[CustomerDataBaseUpdateContext];
            [self.spinner stopAnimating];
            NSString *alertString = [NSString stringWithFormat:@"Executed in %.2fsecs",[[NSDate date] timeIntervalSinceDate:self.startDate]];
            NSLog(@"Time String: %@",alertString);
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CustomerDatabaseEmptyNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = @"Timer is reset";
            [self.spinner stopAnimating];
        });
    }];

    self.itemsArray  = @[@"1MB_1500Rec",@"2MB_3000Rec",@"5MB_7000Rec",@"10MB_15000Rec",@"20MB_30000Rec",@"50MB_70000Rec"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test Storage Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.itemsArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.title = @"Timer is reset";
    self.startDate = [NSDate date];
    [self.spinner startAnimating];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate createDBEntry:[self.itemsArray objectAtIndex:indexPath.row]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
