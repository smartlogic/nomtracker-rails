//
//  SettingsViewController.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
  IBOutlet UIButton *logoutButton;
}
@property (nonatomic, retain) UIButton *logoutButton;
-(IBAction)logout:(id)sender;
@end
