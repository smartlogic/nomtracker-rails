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
@synthesize rootController, loginController, balancesController, red, green, alternateRowBackground, white, greenOnWhite, greenOnBlue, redOnWhite, redOnBlue, darkTextColor;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
  // Set the default colors
  self.red = [UIColor colorWithRed:1.0 green:0.470588235294118 blue:0.431372549019608 alpha:1.0];
  self.green = [UIColor colorWithRed:0.705882352941177 green:0.862745098039216 blue:0.588235294117647 alpha:1.0];
  
  self.alternateRowBackground = [UIColor colorWithRed:0.784313725490196 green:0.941176470588235 blue:1.0 alpha:1.0];
  self.white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
  
  self.greenOnWhite = [UIColor colorWithRed:0.109803921568627 green:0.545098039215686 blue:0.196078431372549 alpha:1.0];
  self.greenOnBlue = [UIColor colorWithRed:0.227450980392157 green:0.603921568627451 blue:0.196078431372549 alpha:1.0];
  self.redOnWhite = [UIColor colorWithRed:1.0 green:0.392156862745098 blue:0.352941176470588 alpha:1.0];
  self.redOnBlue = [UIColor colorWithRed:1.0 green:0.352941176470588 blue:0.352941176470588 alpha:1.0];
  
  self.darkTextColor = [UIColor colorWithRed:0.301960784313725 green:0.301960784313725 blue:0.301960784313725 alpha:1.0];
  
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
    [rootController setSelectedIndex:1];
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
