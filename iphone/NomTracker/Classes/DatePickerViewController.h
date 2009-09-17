//
//  DatePickerViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewTransactionViewController;

@interface DatePickerViewController : UIViewController {
  IBOutlet UIDatePicker *datePicker;
  IBOutlet NewTransactionViewController *ntvController;
}
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NewTransactionViewController *ntvController;
-(IBAction)selectDate:(id)sender;
-(IBAction)leaveAsIs:(id)sender;
-(void)fadeAway;
@end
