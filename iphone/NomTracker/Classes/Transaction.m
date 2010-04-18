//
//  Transaction.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "Transaction.h"
#import "ObjectiveResource.h"

@implementation Transaction
@synthesize transactionId, creditorEmail, debtorEmail, email, transactionType, when, description, amount, image, createdAt, updatedAt;

+(NSArray *)transactionsWithUser:(NSString *)userId {
  NSString *transactionsPath = [NSString stringWithFormat:@"%@transactions_with_user/%@", [ObjectiveResourceConfig getRemoteSite], userId];
  Response *res = [Connection get:transactionsPath withUser:[ObjectiveResourceConfig getUser] andPassword:[ObjectiveResourceConfig getPassword]];
  return [self allFromXMLData:res.body];
}

-(NSString *)amountString {
  NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
  [numberFormatter setPositiveFormat:@"$###,###,##0.00"];
  return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self amount] floatValue]]];  
}

-(void) dealloc {
  [creditorEmail release];
  [debtorEmail release];
  [transactionId release];
  [email release];
  [transactionType release];
  [when release];
  [description release];
  [amount release];
  [image release];
  [createdAt release];
  [updatedAt release];
  [super dealloc];
}
@end
