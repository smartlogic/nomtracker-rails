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
@synthesize emailField, passwordField, errorLabel, rememberMeButton, rememberMe, spinner;

-(void)login:(id)sender {
  spinner.hidesWhenStopped = YES;
  spinner.hidden = NO;
  [spinner startAnimating];
  NSLog(@"spinning...");
  
  errorLabel.text = @"";
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
  [spinner stopAnimating];
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

-(IBAction)launchWebsite:(id)sender {
  NSURL *ntURL = [NSURL URLWithString:@"http://www.nomtracker.com/users/new"];
  NSLog(@"%@", ntURL);
  [[UIApplication sharedApplication] openURL:ntURL];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  rememberMe = NO;
  [rememberMeButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginKeyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
  errorLabel.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void) loginKeyboardWillShow: (NSNotification*) aNotification;
{		    
  CGRect rect = [[self view] frame];	
  if(rect.origin.y == 0) {
    rect.origin.y -= 50;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];	
    [[self view] setFrame: rect];  
    [UIView commitAnimations];
  }
}

- (void) loginKeyboardDidHide: (NSNotification*) aNotification;
{
  CGRect rect = [[self view] frame];	
  [UIView beginAnimations:nil context:NULL];	
  [UIView setAnimationDuration:0.3];	  
  rect.origin.y += 50;   
  [[self view] setFrame: rect];	
  [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  [theTextField resignFirstResponder];
  if (theTextField == emailField) {
    [passwordField becomeFirstResponder];
  }
  return YES;
}

- (void)dealloc {
  [emailField release];
  [passwordField release];
  [errorLabel release];
  [rememberMeButton release];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
  [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardDidHideNotification];
  
  [super dealloc];
}


@end
