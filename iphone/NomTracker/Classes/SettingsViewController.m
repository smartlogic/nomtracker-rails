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
@synthesize logoutButton;

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
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc {
  [logoutButton release];
  [super dealloc];
}

@end