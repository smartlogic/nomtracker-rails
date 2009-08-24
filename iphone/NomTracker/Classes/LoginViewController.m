//
//  LoginViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "LoginViewController.h"
#import "NomTrackerAppDelegate.h"
#import "ObjectiveResource.h"
#import "Email.h"

@implementation LoginViewController
@synthesize emailField, passwordField, errorLabel, rememberMeButton, rememberMe;

-(void)login:(id)sender {
  NSString *loginPath = [NSString stringWithFormat:@"%@users/authenticate_user?email=%@&password=%@", [ObjectiveResourceConfig getSite], emailField.text, passwordField.text];
  Response *res = [Connection post:@"" to:loginPath];

  if ([res isSuccess]) { 
    [ObjectiveResourceConfig setUser:emailField.text];
    [ObjectiveResourceConfig setPassword:passwordField.text];

    if (rememberMe == 1) {
      [[NSUserDefaults standardUserDefaults] setObject:[ObjectiveResourceConfig getUser] forKey:@"nomTrackerUserEmail"];
      [[NSUserDefaults standardUserDefaults] setObject:[ObjectiveResourceConfig getPassword] forKey:@"nomTrackerUserPassword"];
    }
    
    NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view.superview cache:YES];
    
    [self.view removeFromSuperview];
    [delegate.window addSubview:delegate.rootController.view];
    [delegate.rootController setSelectedIndex:0];

    [UIView commitAnimations];
  } else {
    passwordField.text = @"";
    errorLabel.text = @"Login failed.";
  }
}

-(IBAction)toggleRememberMe:(id)sender {
  if (rememberMe == 0) {
    [rememberMeButton setSelected:YES];
    rememberMe = 1;
  } else {
    [rememberMeButton setSelected:NO];
    rememberMe = 0;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // TODO - for dev only. REMOVE!
  emailField.text = @"michael.berkowitz@gmail.com";
  passwordField.text = @"zenboy2";
  rememberMe = NO;
  [rememberMeButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  [theTextField resignFirstResponder];
  return YES;
}

- (void)dealloc {
  [emailField release];
  [passwordField release];
  [errorLabel release];
  [rememberMeButton release];
  [super dealloc];
}


@end
