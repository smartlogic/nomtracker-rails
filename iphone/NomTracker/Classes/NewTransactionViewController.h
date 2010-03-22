//
//  NewTransactionViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Transaction;
@class NomTrackerAppDelegate;

@interface NewTransactionViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UINavigationControllerDelegate> {
  IBOutlet UITextField *emailAddressField;
  IBOutlet UISegmentedControl *transactionType;
  IBOutlet UITextField *forField;
  IBOutlet UITextField *amount;
  IBOutlet UIButton *createTransactionButton;
  IBOutlet UIScrollView *scrollView;
  NomTrackerAppDelegate *ntDelegate;
  Transaction *transaction;
}

@property (nonatomic, retain) UITextField *emailAddressField;
@property (nonatomic, retain) UISegmentedControl *transactionType;
@property (nonatomic, retain) UITextField *forField;
@property (nonatomic, retain) UITextField *amount;
@property (nonatomic, retain) UIButton *createTransactionButton;
@property (nonatomic, retain) NomTrackerAppDelegate *ntDelegate;
@property (nonatomic, retain) Transaction *transaction;
@property (nonatomic, retain) UIScrollView *scrollView;

-(IBAction)createTransaction:(id)sender;
-(IBAction)switchTransactionType:(id)sender;
-(IBAction)selectContact:(id)sender;
-(NSData *)createMultiPartFormData:(NSDictionary *)params withItemKey:(NSString *)key;
@end