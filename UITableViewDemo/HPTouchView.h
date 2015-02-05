//
//  HPTouchView.h
//  UITableViewDemo
//
//  Created by hupeng on 14-10-11.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

// only support one touch point

typedef enum {
    HPTouchViewTouchDirectionAll,
    HPTouchViewTouchDirectionHor,
    HPTouchViewTouchDirectionVec

} HPTouchViewTouchDirection;

#import <UIKit/UIKit.h>

@class HPTouchView;

@protocol HPTouchViewProtocol<NSObject>

@optional

- (void)touchView:(HPTouchView *)touchView didClickedAtPoint:(CGPoint)point;

- (void)touchView:(HPTouchView *)touchView touchWillMoveFromPoint:(CGPoint)point;

- (void)touchView:(HPTouchView *)touchView touchWillMoveToPoint:(CGPoint)point distance:(CGSize)distance;

- (void)touchView:(HPTouchView *)touchView touchWillEndAtPoint:(CGPoint)point;

@end

@interface HPTouchView : UIView

@property (nonatomic, assign) IBOutlet id <HPTouchViewProtocol> delegate;

@property (nonatomic, assign) HPTouchViewTouchDirection touchDirection;

@end
