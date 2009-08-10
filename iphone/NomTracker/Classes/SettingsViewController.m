//
//  SettingsViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "SettingsViewController.h"
#import "ObjectiveResource.h"
#import "NomTrackerAppDelegate.h"

@implementation SettingsViewController
@synthesize currentUser, logoutButton;
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

-(IBAction)logout:(id)sender {
  NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  
  [UIView beginAnimations:@"View Flip" context:nil];
  [UIView setAnimationDuration:1.25];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[delegate.rootController view].superview cache:YES];
  
  [[delegate.rootController view] removeFromSuperview];
  [delegate.window addSubview:[[delegate loginController] view]];

  
  [UIView commitAnimations];
  
  [ObjectiveResourceConfig setUser:@""];
  [ObjectiveResourceConfig setPassword:@""];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nomTrackerUserEmail"];
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nomTrackerUserPassword"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  currentUser.text = [ObjectiveResourceConfig getUser]; 
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
  [currentUser release];
  [logoutButton release];
  [super dealloc];
}


@end
