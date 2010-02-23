//
//  FindFirstResponder.m
//  NomTracker
//
//  Created by Michael Berkowitz on 2/23/10.
//  Copyright 2010 SmartLogic Solutions. All rights reserved.
//

#import "FindFirstResponder.h"


@implementation UIView (findFirstResponder)
  -(UIView *)findFirstResponder {
    if (self.isFirstResponder) {
      return self;
    }
    
    for (UIView *subview in self.subviews) {
      UIView *thisFirstResponder = [subview findFirstResponder];
      if (thisFirstResponder != nil) {
        return thisFirstResponder;
      }
    }
    return nil;
  }
@end
