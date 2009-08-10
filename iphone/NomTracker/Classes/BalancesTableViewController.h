//
//  BalancesTableViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransactionsTableViewController;

@interface BalancesTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UITableView *balancesTable;
  IBOutlet UIBarButtonItem *refreshButton;
  IBOutlet UILabel *nomworthLabel;
  IBOutlet UILabel *backgroundLabel;
  NSMutableArray *balancesArray;
  TransactionsTableViewController *transactionsController;
}
@property (nonatomic, retain) NSArray *balancesArray;
@property (nonatomic, retain) IBOutlet UITableView *balancesTable;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) IBOutlet UILabel *nomworthLabel;
@property (nonatomic, retain) IBOutlet UILabel *backgroundLabel;
@property (nonatomic, retain) TransactionsTableViewController *transactionsController;
-(void)loadBalances;
-(void)refreshNomworth;
-(IBAction)refreshButtonPressed:(id)sender;
@end
