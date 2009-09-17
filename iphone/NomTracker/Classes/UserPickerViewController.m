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
  self.emailsArray = (NSMutableArray *)array;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return [emailsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return (NSString *)[[emailsArray objectAtIndex:row] address];
}


-(IBAction)selectUser:(id)sender {
  ntvController.emailAddressField.text = (NSString *)[[emailsArray objectAtIndex:[userPicker selectedRowInComponent:0]] address];
  [self fadeAway];
}

-(IBAction)leaveAsIs:(id)sender {
  [self fadeAway];
}

-(void)fadeAway {
  
  self.view.alpha = 1;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:1];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  self.view.alpha = 0;
  
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
