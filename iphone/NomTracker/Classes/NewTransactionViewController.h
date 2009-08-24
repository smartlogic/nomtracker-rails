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
@class UserPickerViewController;
@class DatePickerViewController;
@class UserPickerView;

@interface NewTransactionViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
  IBOutlet UITextField *emailAddressField;
  IBOutlet UISegmentedControl *transactionType;
  IBOutlet UITextField *onField;
  IBOutlet UITextField *forField;
  IBOutlet UITextField *amount;
  IBOutlet UIButton *createTransactionButton;
  IBOutlet UIButton *selectExistingButton;
  IBOutlet UIButton *selectImageButton;
  IBOutlet UIImagePickerController *imagePicker;
  IBOutlet UIImageView *imagePreview;
  NSData *selectedImage;
  IBOutlet UIScrollView *scrollView;
  BOOL reloadView;
  NomTrackerAppDelegate *ntDelegate;
  IBOutlet UserPickerViewController *pickUserViewController;
  IBOutlet DatePickerViewController *pickDateViewController;
  Transaction *transaction;
}
@property (nonatomic, retain) UITextField *emailAddressField;
@property (nonatomic, retain) UISegmentedControl *transactionType;
@property (nonatomic, retain) UITextField *onField;
@property (nonatomic, retain) UITextField *forField;
@property (nonatomic, retain) UITextField *amount;
@property (nonatomic, retain) UIButton *createTransactionButton;
@property (nonatomic, retain) UIButton *selectExistingButton;
@property (nonatomic, retain) NomTrackerAppDelegate *ntDelegate;
@property (nonatomic, retain) UserPickerViewController *pickUserViewController;
@property (nonatomic, retain) DatePickerViewController *pickDateViewController;
@property (nonatomic, retain) Transaction *transaction;
@property (nonatomic, retain) UIButton *selectImageButton;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSData *selectedImage;
@property (nonatomic, retain) UIImageView *imagePreview;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic) BOOL reloadView;
-(IBAction)selectExistingContact:(id)sender;
-(IBAction)createTransaction:(id)sender;
-(IBAction)selectDate:(id)sender;
-(IBAction)switchTransactionType:(id)sender;
-(IBAction)selectImage:(id)sender;
-(void)reloadTransaction;
-(NSData *)createMultiPartFormData:(NSDictionary *)params withImage:(NSData *)image andItemKey:(NSString *)key;
@end
