//
//  LoginViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController <UITextFieldDelegate> {
  IBOutlet UIButton *loginButton;
  IBOutlet UITextField *emailField;
  IBOutlet UITextField *passwordField;
  IBOutlet UIButton *rememberMeButton;
  IBOutlet UILabel *errorLabel;
  BOOL rememberMe;
}
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIButton *rememberMeButton;
@property (nonatomic) BOOL rememberMe;
-(IBAction)login:(id)sender;
-(IBAction)toggleRememberMe:(id)sender;
@end
