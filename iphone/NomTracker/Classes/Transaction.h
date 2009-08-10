//
//  Transaction.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "ObjectiveResource.h"

@interface Transaction : NSObject {
  NSString *creditorEmail;
  NSString *debtorEmail;
  NSString *transactionId;
  NSString *email;
  NSString *transactionType;
  NSString *amount;
  NSString *when;
  NSString *description;
  NSString *createdAt;
  NSDate *updatedAt;
}
@property (nonatomic, retain) NSString *creditorEmail;
@property (nonatomic, retain) NSString *debtorEmail;
@property (nonatomic, retain) NSString *transactionId;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *transactionType;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *when;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;
+(NSArray *)transactionsWithUser:(NSString *)userId;
-(NSString *)amountString;
@end
