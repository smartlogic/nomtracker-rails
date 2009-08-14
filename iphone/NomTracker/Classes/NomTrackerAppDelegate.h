//
//  NomTrackerAppDelegate.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright SmartLogic Solutions 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class LoginViewController;
@class BalancesNavController;

@interface NomTrackerAppDelegate : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  UIColor *red;
  UIColor *green;
  IBOutlet UITabBarController *rootController;
  IBOutlet LoginViewController *loginController;
  IBOutlet BalancesNavController *balancesController;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIColor *red;
@property (nonatomic, retain) UIColor *green;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet LoginViewController *loginController;
@property (nonatomic, retain) IBOutlet BalancesNavController *balancesController;
@end

