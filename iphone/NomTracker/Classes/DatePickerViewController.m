//
//  DatePickerViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/7/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "DatePickerViewController.h"
#import "NewTransactionViewController.h"

@implementation DatePickerViewController
@synthesize datePicker, ntvController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [datePicker setDate:[NSDate date] animated:NO];
}

-(IBAction)selectDate:(id)sender {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  ntvController.onField.text = [dateFormatter stringFromDate:[datePicker date]];
  
  [UIView beginAnimations:@"View Curl" context:nil];
  [UIView setAnimationDuration:1.00];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
  
  [self.view removeFromSuperview];  
  
  [UIView commitAnimations];  
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)dealloc {
  [datePicker release];
  [ntvController release];
  [super dealloc];
}


@end
