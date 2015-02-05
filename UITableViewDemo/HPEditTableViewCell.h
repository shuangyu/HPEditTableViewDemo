//
//  ILSEditTableViewCell.h
//  UITableViewDemo
//
//  Created by hupeng on 14-10-10.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPTouchView.h"

@class HPEditTableViewCell;

@protocol  HPEditTableViewCellProtocol<NSObject>

@required
- (BOOL)cellCanEditing:(HPEditTableViewCell *)cell;

@optional
- (void)cellWillBeginTranslate:(HPEditTableViewCell *)cell;
- (void)cellDidEndTranslate:(HPEditTableViewCell *)cell;

- (void)cellDidCancelEditing:(HPEditTableViewCell *)cell;
- (void)cellDidBeginEditing:(HPEditTableViewCell *)cell;
- (void)clickCell:(HPEditTableViewCell *)cell;

@end

@interface HPEditTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HPEditTableViewCellProtocol> delegate;
@property (nonatomic, weak) IBOutlet HPTouchView *bottomView;
@property (nonatomic, weak) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *editButtons;

- (void)cancelEditing;

- (void)willBeginTranslate;
- (void)didEndTranslate;
- (void)didBeginEditing;
- (void)didCancelEditing;
@end
