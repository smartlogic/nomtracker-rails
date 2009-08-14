//
//  UserPickerView.h
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserPickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource> {
  NSArray *items;
}
@property (nonatomic, retain) NSArray *items;
@end
