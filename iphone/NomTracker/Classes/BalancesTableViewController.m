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
#import "BalancesTableCell.h"

@implementation BalancesTableViewController
@synthesize balancesArray, balancesTable, refreshButton, nomworthLabel, backgroundLabel;
@synthesize transactionsController;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

-(void)loadBalances {
  self.balancesArray = [Balance allBalances];
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
  if (nomworth > 0) {
    [backgroundLabel setBackgroundColor:delegate.green];
  } else {
    [backgroundLabel setBackgroundColor:delegate.red];
  }
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setFormat:@"$###,###.00;-$###,###.00"];
  nomworthLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:nomworth]];  
}

-(IBAction)refreshButtonPressed:(id)sender {
  self.loadBalances;
}

- (void)viewDidLoad {
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.title = @"Your Balances";
  
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.loadBalances;
  float nomworth = 0.0;
  Balance *balance;
  for (balance in balancesArray) {
    float balanceValue = [[balance balance] floatValue];
    nomworth += balanceValue;
  }
  NomTrackerAppDelegate *delegate = [UIApplication sharedApplication].delegate;
  if (nomworth > 0) {
    [backgroundLabel setBackgroundColor:delegate.green];
  } else {
    [backgroundLabel setBackgroundColor:delegate.red];
  }
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setFormat:@"$###,###.00;-$###,###.00"];
  nomworthLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:nomworth]];  
  
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  //  self.loadBalances;
//  float nomworth = 0.0;
//  Balance *balance;
//  for (balance in balancesArray) {
//    float balanceValue = [[balance balance] floatValue];
//    nomworth += balanceValue;
//  }
//  nomworthLabel.text = [NSString stringWithFormat:@"%f2", nomworth];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
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
    return [balancesArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
    
  BalancesTableCell *cell = (BalancesTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  Balance *bal = (Balance *)[balancesArray objectAtIndex:indexPath.row];
  BOOL balIsPos = bal.balanceIsPositive;
  cell = [[[BalancesTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  // USER
  UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(25.0, 0, 175.0, tableView.rowHeight)] autorelease];
  [cell addColumn:120];
  if (balIsPos == YES) {
    label.text = [NSString stringWithFormat:@"%@ owes you", [bal nameField:NO]];
  } else {
    label.text = [NSString stringWithFormat:@"You owe %@", [bal nameField:NO]];
  }
  label.textAlignment = UITextAlignmentLeft;
  label.textColor = [UIColor blackColor];
  label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
  [cell.contentView addSubview:label];
  
  // AMOUNT
  label = [[[UILabel alloc] initWithFrame:CGRectMake(200.0, 0, 100.0, tableView.rowHeight)] autorelease];
  [cell addColumn:120];
  label.text = [bal balanceString];
  label.textAlignment = UITextAlignmentRight;
  NomTrackerAppDelegate *delegate = [UIApplication sharedApplication].delegate;
  if (balIsPos) {
    label.textColor = delegate.green;
  } else {
    label.textColor = delegate.red;
  }
  label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
  [cell.contentView addSubview:label];
  return cell;
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
  [balancesTable release];
  [refreshButton release];
  [nomworthLabel release];
  [backgroundLabel release];
  [transactionsController release];
  [balancesArray release];
  [super dealloc];
}


@end

