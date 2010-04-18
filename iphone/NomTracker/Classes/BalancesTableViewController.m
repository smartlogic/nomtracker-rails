//
//  BalancesTableViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "BalancesTableViewController.h"
#import "TransactionsTableViewController.h"
#import "NomTrackerAppDelegate.h"
#import "Balance.h"
#import "ObjectiveResource.h"

@implementation BalancesTableViewController
@synthesize balancesArray, balancesTable, refreshButton, nomworthLabel, backgroundLabel, balancesTableViewCell;
@synthesize transactionsController;

-(void)loadBalances {
  self.balancesArray = (NSMutableArray *)[Balance allBalances];
  [balancesTable reloadData];
  [self refreshNomworth];
}

-(void)refreshNomworth {
  float nomworth = 0.0;
  Balance *balance;
  for (balance in balancesArray) {
    float balanceValue = [[balance balance] floatValue];
    nomworth += balanceValue;
  }
  NomTrackerAppDelegate *delegate = [UIApplication sharedApplication].delegate;
  if (nomworth >= 0) {
    [backgroundLabel setBackgroundColor:delegate.green];
  } else {
    [backgroundLabel setBackgroundColor:delegate.green];
  }
  NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
  [numberFormatter setPositiveFormat:@"$###,###.00"];
  [numberFormatter setNegativePrefix:@"-$"];
  nomworthLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:nomworth]];  
}

-(IBAction)refreshButtonPressed:(id)sender {
  self.loadBalances;
}

- (void)viewDidLoad {
  self.title = @"Your Balances";
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Balances" style:UIBarButtonItemStyleDone target:self action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  [backButton release];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.loadBalances;

}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
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
    return [balancesArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"BalanceTableViewCell" owner:self options:NULL]; 
		cell = balancesTableViewCell;
  }
    
  Balance *balance = (Balance *)[balancesArray objectAtIndex:indexPath.row];
  
  BOOL balIsPos = balance.balanceIsPositive;
  
  NomTrackerAppDelegate *delegate = [UIApplication sharedApplication].delegate;
  
  // You owe/Owes you label
  UILabel *textLabel = (UILabel*) [cell viewWithTag:1];
	textLabel.text = [balance nameField: NO];
  if (balIsPos == YES) {
    textLabel.textColor = indexPath.row % 2 == 0 ? delegate.greenOnBlue : delegate.greenOnWhite;
  } else {
    textLabel.textColor = indexPath.row % 2 == 0 ? delegate.redOnBlue : delegate.redOnWhite;
  }  
  
  // Amount label
  UILabel *amountLabel = (UILabel*) [cell viewWithTag:2];
  amountLabel.text = [balance balanceString];
  amountLabel.textColor = delegate.darkTextColor;

  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

  NomTrackerAppDelegate *delegate = [UIApplication sharedApplication].delegate;  
  if(indexPath.row % 2 == 0) {
    cell.backgroundColor = delegate.alternateRowBackground; 
  }
  else {
    cell.backgroundColor = delegate.white;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  TransactionsTableViewController *tController = [[TransactionsTableViewController alloc] initWithNibName:@"TransactionsTableView" bundle:nil];
  tController.otherUserId = [[balancesArray objectAtIndex:indexPath.row] userId];
  self.transactionsController = tController;
  [tController release];

  transactionsController.title = [[balancesArray objectAtIndex:indexPath.row] nameField:YES];
  NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  [delegate.balancesController pushViewController:transactionsController animated:YES];
}

- (void)dealloc {
  [balancesTable release];
  [refreshButton release];
  [nomworthLabel release];
  [backgroundLabel release];
  [transactionsController release];
  [balancesArray release];
  [super dealloc];
}


@end