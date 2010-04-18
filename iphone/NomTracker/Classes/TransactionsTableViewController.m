//
//  TransactionsTableViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "TransactionsTableViewController.h"
#import "Transaction.h"
#import "NomTrackerAppDelegate.h"
#import "TransactionDetailViewController.h"

@implementation TransactionsTableViewController
@synthesize otherUserId, transactionsArray, transactionsTable, transactionController, transactionTableViewCell;

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.transactionsArray = (NSMutableArray *)[Transaction transactionsWithUser:self.otherUserId];
  [transactionsTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [transactionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  
  Transaction *thisTransaction = [transactionsArray objectAtIndex:indexPath.row];

  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if( cell == nil) {
    [[NSBundle mainBundle] loadNibNamed:@"TransactionTableViewCell" owner:self options:NULL];
    cell = transactionTableViewCell;
  }
  
  // USER
  UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
  textLabel.text = [thisTransaction createdAt];
  textLabel.textColor = [UIColor blackColor];
  
  // AMOUNT
  UILabel *amountLabel = (UILabel*) [cell viewWithTag:2];
  NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  if ([thisTransaction.creditorEmail isEqualToString:[ObjectiveResourceConfig getUser]]) {
    amountLabel.textColor = delegate.green;
  } else {
    amountLabel.textColor = delegate.red;
  }
  amountLabel.text = [thisTransaction amountString];
  
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

