//
//  UserPickerView.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "UserPickerView.h"


@implementation UserPickerView
@synthesize items;

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    NSLog(@"OK");
  }
  return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
