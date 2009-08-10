//
//  Balance.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "ObjectiveResource.h"

@interface Balance : NSObject {
  NSString *name;
  NSString *email;
  NSString *userId;
  NSNumber *balance;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSNumber *balance;
+(NSArray *)allBalances;
-(BOOL)balanceIsPositive;
-(NSString *)balanceString;
-(NSString *)nameField:(BOOL)fullEmail;
@end
