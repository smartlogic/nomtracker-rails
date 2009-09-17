//
//  SettingsViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
  IBOutlet UILabel *currentUser;
  IBOutlet UIButton *logoutButton;
}
@property (nonatomic, retain) UILabel *currentUser;
@property (nonatomic, retain) UIButton *logoutButton;
-(IBAction)logout:(id)sender;
-(IBAction)launchWebsite:(id)sender;
@end
