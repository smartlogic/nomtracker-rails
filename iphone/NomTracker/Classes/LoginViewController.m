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
  NSString *email = emailField.text;
  NSString *password = passwordField.text;
  NSString *loginPath = [NSString stringWithFormat:@"%@users/authenticate_user?email=%@&password=%@", [ObjectiveResourceConfig getSite], email, password];
  Response *res = [Connection post:@"" to:loginPath];
  if (res.statusCode == 200) {
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

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  emailField.text = @"michael@slsdev.net";
  passwordField.text = @"mikemike";
  rememberMe = NO;
  [rememberMeButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  [theTextField resignFirstResponder];
  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [emailField release];
  [passwordField release];
  [errorLabel release];
  [rememberMeButton release];
  [super dealloc];
}


@end
