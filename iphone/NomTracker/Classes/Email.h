//
//  Email.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveResource.h"

@interface Email : NSObject {
  NSString *address;
}
@property (nonatomic, retain) NSString *address;
+(NSArray *)allEmails;
@end
