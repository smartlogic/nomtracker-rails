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
  IBOutlet UILabel *errorLabel;
  IBOutlet UITextField *emailField;
  IBOutlet UITextField *passwordField;
  IBOutlet UIButton *rememberMeButton;
  IBOutlet UIActivityIndicatorView *spinner;
  BOOL rememberMe;
}
@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIButton *rememberMeButton;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic) BOOL rememberMe;
-(IBAction)login:(id)sender;
-(IBAction)toggleRememberMe:(id)sender;
-(IBAction)launchWebsite:(id)sender;
@end
