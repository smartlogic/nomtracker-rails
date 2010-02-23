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
      if ([transaction.description isEqualToString:@""] && [transaction.image.description isEqualToString:@""]) {
        return @"";
      } else {
        return @"For";
      }
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
      return 3;
      break;
    case 1:
      {
        int rowCount;
        rowCount = 2;
        if ([transaction.description isEqualToString:@""]) { rowCount--; }
        if ([transaction.image.description isEqualToString:@""]) {rowCount--;}
        return rowCount;
        break;
      }
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
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", transaction.when]];
      } else {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", transaction.createdAt]];
      }
    } else if (indexPath.row == 1) {
      NSString *transactionText;
      if ([transaction.creditorEmail isEqualToString:[ObjectiveResourceConfig getUser]]) {
        transactionText = @"borrowed";
      } else {
        transactionText = @"lent you";
      }
      [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", otherUserName, transactionText]];
    } else if (indexPath.row == 2) {
      [cell.textLabel setText:[NSString stringWithFormat:@"%@", transaction.amountString]];
    }
  } else {
    if (indexPath.row == 0 && ![transaction.description isEqualToString:@""]) {
      [cell.textLabel setText:[NSString stringWithFormat:@"%@", transaction.description]];
    } else {
      UIImage *cellImage = [UIImage imageWithContentsOfFile:transaction.image.description];
      [cell.imageView setImage:cellImage];
    }
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1 && ((indexPath.row == 1 && ![transaction.image.description isEqualToString:@""]) || (indexPath.row == 0 && [transaction.description isEqualToString:@""]))) {
    UIImage *cellImage = [UIImage imageWithContentsOfFile:transaction.image.description];
    return cellImage.size.height + 25;
  } else {
    return 44.0;
  }
}

- (void)dealloc {
  [dateLabel release];
  [transactionLabel release];
  [forLabel release];
  [transaction release];
  [otherUserName release];
  [super dealloc];
}


@end