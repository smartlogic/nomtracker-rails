//
//  NomTrackerAppDelegate.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright SmartLogic Solutions 2009. All rights reserved.
//

#import "ObjectiveResource.h"
#import "NomTrackerAppDelegate.h"
#import "LoginViewController.h"
#import "BalancesNavController.h"
#import "NSError+Error.h"

@implementation NomTrackerAppDelegate

@synthesize window;
@synthesize rootController, loginController, balancesController, red, green;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  // Set the default colors
  self.red = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
  self.green = [UIColor colorWithRed:0.0 green:0.75 blue:0.21 alpha:1.0];
  
  [ObjectiveResourceConfig setSite:@"http://www.nomtracker.com/"];
  
  [ObjectiveResourceConfig setResponseType:JSONResponse];

  // Initialize login view
  LoginViewController *lvController = [[[LoginViewController alloc] initWithNibName:@"LoginView" bundle:nil] autorelease];
  self.loginController = lvController;
  [window addSubview:loginController.view];
  
  // Load saved data if exists
  // TODO - encryption!
  NSString *presetEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"nomTrackerUserEmail"];
  NSString *presetPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"nomTrackerUserPassword"];

  if ((presetEmail != nil) && (presetPassword != nil)) {
    [ObjectiveResourceConfig setUser:presetEmail];
    [ObjectiveResourceConfig setPassword:presetPassword];
    [loginController.view removeFromSuperview];
    [window addSubview:rootController.view];
    [rootController setSelectedIndex:2];
  }
  [window makeKeyAndVisible];
}

- (void)dealloc {
  [red release];
  [green release];
  [window release];
  [balancesController release];
  [loginController release];
  [rootController release];
  [super dealloc];
}
@end
