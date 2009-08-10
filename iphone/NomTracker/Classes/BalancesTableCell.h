//
//  BalancesTableCell.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BalancesTableCell : UITableViewCell {
  NSMutableArray *columns;
}
@property (nonatomic, retain) NSMutableArray *columns;
-(void)addColumn:(CGFloat)position;
@end
