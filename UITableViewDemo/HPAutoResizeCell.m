//
//  HPAutoResizeCell.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/14.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPAutoResizeCell.h"

@implementation HPAutoResizeCell

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self refreshSubviews];
}

- (void)refreshSubviews
{
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        _autoResizeContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 40, CGRectGetHeight(self.bounds));
    } else {
        _autoResizeContentView.frame = self.bounds;
    }
}

@end
