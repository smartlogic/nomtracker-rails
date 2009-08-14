//
//  UserPickerViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "UserPickerViewController.h"
#import "NewTransactionViewController.h"
#import "Email.h"

@implementation UserPickerViewController
@synthesize userPicker, emailsArray, ntvController;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  [super loadView];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  NSArray *array = [Email allEmails];
  self.emailsArray = array;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [emailsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return [[emailsArray objectAtIndex:row] address];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  ntvController.emailAddressField.text = [[emailsArray objectAtIndex:row] address];

  [UIView beginAnimations:@"View Curl" context:nil];
  [UIView setAnimationDuration:1.00];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
  
  [self.view removeFromSuperview];  

  [UIView commitAnimations];
  
  

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (void)dealloc {
  [emailsArray release];
  [ntvController release];
  [userPicker release];
  [super dealloc];
}


@end
