//
//  TransactionsTableViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "Transaction.h"
#import "BalancesTableCell.h"
#import "NomTrackerAppDelegate.h"
#import "TransactionDetailViewController.h"

@implementation TransactionsTableViewController
@synthesize otherUserId, transactionsArray, transactionsTable, transactionController;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
  [super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.transactionsArray = [Transaction transactionsWithUser:self.otherUserId];
  [transactionsTable reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [transactionsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  BalancesTableCell *cell = (BalancesTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  Transaction *thisTransaction = [transactionsArray objectAtIndex:indexPath.row];
  cell = [[[BalancesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  // USER
  UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(25.0, 0, 175.0, tableView.rowHeight)] autorelease];
  [cell addColumn:120];
  
  label.text = [thisTransaction createdAt];
  label.textAlignment = UITextAlignmentLeft;
  label.textColor = [UIColor blackColor];
  label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
  [cell.contentView addSubview:label];
  
  // AMOUNT
  label = [[[UILabel alloc] initWithFrame:CGRectMake(200.0, 0, 100.0, tableView.rowHeight)] autorelease];
  [cell addColumn:120];
  NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  if ([thisTransaction.creditorEmail isEqualToString:[ObjectiveResourceConfig getUser]]) {
    label.textColor = delegate.green;
  } else {
    label.textColor = delegate.red;
  }
  label.textAlignment = UITextAlignmentRight;
  label.text = [thisTransaction amountString];
  label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
  [cell.contentView addSubview:label];
  return cell;
//  
//  
//  
//  static NSString *CellIdentifier = @"Cell";
//    
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//  if (cell == nil) {
//      cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
//  }
//    
//    // Set up the cell...
//  cell.text = [NSString stringWithFormat:@"%@", [(Transaction *)[transactionsArray objectAtIndex:indexPath.row] formattedCreatedAtString]];
//  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  TransactionDetailViewController *tController = [[TransactionDetailViewController alloc] initWithNibName:@"TransactionDetailView" bundle:nil];
  self.transactionController = tController;
  [tController release];
  
  transactionController.title = @"Transaction Details";
  transactionController.otherUserName = self.title;
  transactionController.transaction = [transactionsArray objectAtIndex:indexPath.row];
  NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  [delegate.balancesController pushViewController:transactionController animated:YES];
  
  
  // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
  [otherUserId release];
  [transactionsArray release];
  [transactionsTable release];
  [transactionController release];
  [super dealloc];
}


@end

