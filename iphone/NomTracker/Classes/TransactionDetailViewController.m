//
//  TransactionDetailViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "Transaction.h"

@implementation TransactionDetailViewController
@synthesize dateLabel, transactionLabel, forLabel, transaction, otherUserName;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSString *thisDate;
  if (transaction.when != nil) {
    thisDate = transaction.when;
  } else {
    thisDate = transaction.createdAt;
  }
  [dateLabel setText:[NSString stringWithFormat:@"On %@", thisDate]];
  
  NSString *transactionText;
  if ([transaction.creditorEmail isEqualToString:[ObjectiveResourceConfig getUser]]) {
    transactionText = @"borrowed";
  } else {
    transactionText = @"lent you";
  }
  [transactionLabel setText:[NSString stringWithFormat:@"%@ %@ %@", otherUserName, transactionText, transaction.amountString]];

  if (transaction.description != nil) {
    [forLabel setText:[NSString stringWithFormat:@"For %@", transaction.description]];
  }
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return @"On";
      break;
    case 1:
      return @"For";
      break;
    default:
      return @"";
      break;
  }
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 2;
      break;
    case 1:
      return 1;
      break;
    default:
      return 0;
      break;
  }
}




// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  static NSString *CellIdentifier = @"Cell";
    
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
  }
  NSString *thisDate;
  if (transaction.when != nil) {
    thisDate = transaction.when;
  } else {
    thisDate = transaction.createdAt;
  }
  [dateLabel setText:[NSString stringWithFormat:@"On %@", thisDate]];
  
  NSString *transactionText;
  if ([transaction.creditorEmail isEqualToString:[ObjectiveResourceConfig getUser]]) {
    transactionText = @"borrowed";
  } else {
    transactionText = @"lent you";
  }
  [transactionLabel setText:[NSString stringWithFormat:@"%@ %@ %@", otherUserName, transactionText, transaction.amountString]];
  
  if (transaction.description != nil) {
    [forLabel setText:[NSString stringWithFormat:@"For %@", transaction.description]];
  }  
  
  // Set up the cell...
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      if (transaction.when != nil) {
        cell.text = transaction.when;
      } else {
        cell.text = transaction.createdAt;
      }
    } else {
      NSString *transactionText;
      if ([transaction.creditorEmail isEqualToString:[ObjectiveResourceConfig getUser]]) {
        transactionText = @"borrowed";
      } else {
        transactionText = @"lent you";
      }
      cell.text = [NSString stringWithFormat:@"%@ %@ %@", otherUserName, transactionText, transaction.amountString];
    }
  } else {
    cell.text = transaction.description;
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
  [dateLabel release];
  [transactionLabel release];
  [forLabel release];
  [transaction release];
  [otherUserName release];
  [super dealloc];
}


@end

