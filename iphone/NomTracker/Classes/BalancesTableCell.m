//
//  BalancesTableCell.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "BalancesTableCell.h"


@implementation BalancesTableCell
@synthesize columns;

-(void)addColumn:(CGFloat)position {
  [columns addObject:[NSNumber numberWithFloat:position]];
}

-(void)drawRect:(CGRect)rect {
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1.0);
  CGContextSetLineWidth(ctx, 0.25);
  
  for (int i = 0; i < [columns count]; i++) {
    CGFloat f = [((NSNumber*) [columns objectAtIndex:i]) floatValue];
    CGContextMoveToPoint(ctx, f, 0);
    CGContextAddLineToPoint(ctx, f, self.bounds.size.height);
  }
  CGContextStrokePath(ctx);
  [super drawRect:rect];
}

- (void)dealloc {
  [columns release];
  [super dealloc];
}


@end
