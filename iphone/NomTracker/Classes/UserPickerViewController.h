//
//  UserPickerViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewTransactionViewController;

@interface UserPickerViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
  IBOutlet UIPickerView *userPicker;
  IBOutlet NSMutableArray *emailsArray;
  IBOutlet NewTransactionViewController *ntvController;
}
@property (nonatomic, retain) UIPickerView *userPicker;
@property (nonatomic, retain) NSMutableArray *emailsArray;
@property (nonatomic, retain) NewTransactionViewController *ntvController;
@end
