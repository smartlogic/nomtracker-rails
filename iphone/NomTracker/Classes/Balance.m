//
//  Balance.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "Balance.h"
#import "ObjectiveResource.h"

@implementation Balance
@synthesize name, balance, email, userId;

+(NSArray *)allBalances {
  NSString *balancesPath = [NSString stringWithFormat:@"%@balances", [ObjectiveResourceConfig getRemoteSite]];
  Response *res = [Connection get:balancesPath withUser:[ObjectiveResourceConfig getUser] andPassword:[ObjectiveResourceConfig getPassword]];
  return [self allFromXMLData:res.body];
}

-(BOOL)balanceIsPositive {
  float balFloat = [[self balance] floatValue];
  if (balFloat > 0) {
    return YES;
  } else {
    return NO;
  }
}

-(NSString *)balanceString {
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setFormat:@"###,###,##0.00"];
  return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:fabs([[self balance] floatValue])]];  
}

-(NSString *)nameField:(BOOL)fullEmail {
  NSString *returnValue;
  if ([self.name length] > 0) {
    returnValue = self.name;
  } else {
    if (fullEmail == YES) {
      returnValue = self.email;
    } else {
      returnValue = [[self.email componentsSeparatedByString:@"@"] objectAtIndex:0];
    }
  }
  return returnValue;
}

-(void) dealloc {
  [balance release];
  [name release];
  [email release];
  [userId release];
  [super dealloc];
}
@end
