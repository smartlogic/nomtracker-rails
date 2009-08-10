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
  [datePicker setDate:[NSDate date] animated:NO];
}

-(IBAction)selectDate:(id)sender {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [dateFormatter setDateFormat:@"EEE MMM dd, yyyy"];
  ntvController.onField.text = [dateFormatter stringFromDate:[datePicker date]];
  
  [UIView beginAnimations:@"View Curl" context:nil];
  [UIView setAnimationDuration:1.00];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
  
  [self.view removeFromSuperview];  
  
  [UIView commitAnimations];  
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
  [datePicker release];
  [ntvController release];
  [super dealloc];
}


@end
