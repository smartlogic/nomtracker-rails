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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

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
}

- (void)dealloc {
  [otherUserId release];
  [transactionsArray release];
  [transactionsTable release];
  [transactionController release];
  [super dealloc];
}


@end

