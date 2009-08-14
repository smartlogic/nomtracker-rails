//
//  BalancesNavController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "BalancesNavController.h"


@implementation BalancesNavController

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


- (void)dealloc {
  [super dealloc];
}
@end
