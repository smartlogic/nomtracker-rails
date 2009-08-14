//
//  TransactionDetailViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionDetailViewController : UITableViewController <UITableViewDelegate> {
  IBOutlet UILabel *dateLabel;
  IBOutlet UILabel *transactionLabel;
  IBOutlet UILabel *forLabel;
  NSString *otherUserName;
  Transaction *transaction;
}
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *transactionLabel;
@property (nonatomic, retain) UILabel *forLabel;
@property (nonatomic, retain) NSString *otherUserName;
@property (nonatomic, retain) Transaction *transaction;
@end
