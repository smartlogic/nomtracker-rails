//
//  NewTransactionViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "NomTrackerAppDelegate.h"
#import "NewTransactionViewController.h"
#import "Transaction.h"
#import "UserPickerViewController.h"
#import "DatePickerViewController.h"

@implementation NewTransactionViewController
@synthesize emailAddressField, transactionType, onField, forField, createTransactionButton, selectExistingButton, amount, transaction, ntDelegate;
@synthesize pickUserViewController, pickDateViewController;

-(IBAction)createTransaction:(id)sender {
  transaction.amount = amount.text;
  transaction.description = forField.text;
  transaction.when = onField.text;
  transaction.email = emailAddressField.text;
  if ([transactionType selectedSegmentIndex] == 0) {
    // credit
    transaction.transactionType = @"credit";
  } else {
    // debt
    transaction.transactionType = @"debt";
  }

  NSError *aError = nil;
  BOOL success = [transaction saveRemoteWithResponse:&aError];
  if (success) {

    NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.rootController.selectedIndex = 0;
    [[delegate balancesController] popToRootViewControllerAnimated:YES];
  } else {
    NSString *errors = [[NSString stringWithFormat:@"%@", [[aError errors] componentsJoinedByString:@"\n"]] stringByReplacingOccurrencesOfString:@"_id" withString:@""];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"There were errors saving this transaction" message:errors delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
  }
}

-(IBAction)selectExistingContact:(id)sender {
  UserPickerViewController *upvController = [[UserPickerViewController alloc] initWithNibName:@"UserPickerView" bundle:nil];
  upvController.ntvController = self;

  [UIView beginAnimations:@"View Curl" context:nil];
  [UIView setAnimationDuration:1.00];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view.superview cache:YES];
  
//  [[delegate.rootController view] removeFromSuperview];
//  [delegate.window addSubview:[[delegate loginController] view]];
  
  [self.view.superview addSubview:upvController.view];  
  [UIView commitAnimations];
}

-(IBAction)selectDate:(id)sender {
  DatePickerViewController *dpvController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerView" bundle:nil];
  dpvController.ntvController = self;
  
  [UIView beginAnimations:@"View Curl" context:nil];
  [UIView setAnimationDuration:1.00];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view.superview cache:YES];
  
  //  [[delegate.rootController view] removeFromSuperview];
  //  [delegate.window addSubview:[[delegate loginController] view]];
  
  [self.view.superview addSubview:dpvController.view];  
  [UIView commitAnimations];
}

-(IBAction)switchTransactionType:(id)sender {
  if ([transactionType selectedSegmentIndex] == 0) {
    [transactionType setImage:[UIImage imageNamed:@"borrowed_unlit.png"] forSegmentAtIndex:0];
    [transactionType setImage:[UIImage imageNamed:@"lentme_lit.png"] forSegmentAtIndex:1];
  } else {
    [transactionType setImage:[UIImage imageNamed:@"borrowed_lit.png"] forSegmentAtIndex:0];
    [transactionType setImage:[UIImage imageNamed:@"lentme_unlit.png"] forSegmentAtIndex:1];
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
  UserPickerViewController *upvController = [[UserPickerViewController alloc] initWithNibName:@"UserPickerView" bundle:nil];
  self.pickUserViewController = upvController;
  [upvController release];
  Transaction *t = [[Transaction alloc] init];
  self.transaction = t;
  [t release];
  amount.text = @"";
  forField.text = @"";
  onField.text = @"";
  emailAddressField.text = @"";
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  UserPickerViewController *upvController = [[UserPickerViewController alloc] initWithNibName:@"UserPickerView" bundle:nil];
  self.pickUserViewController = upvController;
  [upvController release];
  Transaction *t = [[Transaction alloc] init];
  self.transaction = t;
  [t release];
  amount.text = @"";
  forField.text = @"";
  onField.text = @"";
  onField.enabled = NO;
  emailAddressField.text = @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  [theTextField resignFirstResponder];
  return YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [emailAddressField release];
  [transactionType release];
  [onField release];
  [forField release];
  [createTransactionButton release];
  [selectExistingButton release];
  [amount release];
  [transaction release];
  [ntDelegate release];
  [pickUserViewController release];
  [pickDateViewController release];
  [super dealloc];
}


@end
