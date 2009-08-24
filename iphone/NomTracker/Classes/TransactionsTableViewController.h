//
//  TransactionsTableViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Transaction;
@class TransactionDetailViewController;

@interface TransactionsTableViewController : UITableViewController {
  NSString *otherUserId;
  IBOutlet NSMutableArray *transactionsArray;
  IBOutlet UITableView *transactionsTable;
  TransactionDetailViewController *transactionController;
}
@property (nonatomic, retain) NSString *otherUserId;
@property (nonatomic, retain) NSMutableArray *transactionsArray;
@property (nonatomic, retain) UITableView *transactionsTable;
@property (nonatomic, retain) TransactionDetailViewController *transactionController;
@end
