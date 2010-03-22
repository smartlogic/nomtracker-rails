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
  [self dismissModalViewControllerAnimated: YES];
}

-(IBAction)cancel:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
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