//
//  Email.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "Email.h"


@implementation Email
@synthesize address;

+(NSArray *)allEmails {
  NSString *emailsPath = [NSString stringWithFormat:@"%@emails", [ObjectiveResourceConfig getRemoteSite]];
  Response *res = [Connection get:emailsPath withUser:[ObjectiveResourceConfig getUser] andPassword:[ObjectiveResourceConfig getPassword]];
  return [self allFromXMLData:res.body];
}


-(void)dealloc {
  [address release];
  [super dealloc]; 
}
@end
