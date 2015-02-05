//
//  HPTouchView.m
//  UITableViewDemo
//
//  Created by hupeng on 14-10-11.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

const float kHPTouchViewTouchLimitationTime = 1.0;
const float kHPTouchViewTouchTolerantRadius = 4.0;
const float kHPTouchViewTouchDirectionRatio = 5.0;

#import "HPTouchView.h"

@interface HPTouchView ()
{
    CGPoint _touchStartPoint;
    float _touchStartTimeStamp;
}
@end

@implementation HPTouchView

#pragma mark - touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    _touchStartPoint = [touch locationInView:self];
    _touchStartTimeStamp = touch.timestamp;
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchView:touchWillMoveFromPoint:)]) {
        [_delegate touchView:self touchWillMoveFromPoint:_touchStartPoint];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];

    CGPoint previousPoint = [touch previousLocationInView:self];
    
    if (_touchDirection == HPTouchViewTouchDirectionHor) {
        
        if (fabs((touchPoint.x - previousPoint.x) / (touchPoint.y - previousPoint.y)) < kHPTouchViewTouchDirectionRatio) {
            [super touchesMoved:touches withEvent:event];
            return;
        }
    }
    
    if (_touchDirection == HPTouchViewTouchDirectionVec) {
        if (fabs((touchPoint.x - previousPoint.x) / (touchPoint.y - previousPoint.y)) < 1.0 / kHPTouchViewTouchDirectionRatio) {
            [super touchesMoved:touches withEvent:event];
            return;
        }
    }
    
    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
        [self touchesCancelled:touches withEvent:event];
        return;
    }

    if (_delegate && [_delegate respondsToSelector:@selector(touchView:touchWillMoveToPoint:distance:)]) {
        [_delegate touchView:self touchWillMoveToPoint:touchPoint distance:CGSizeMake(touchPoint.x - _touchStartPoint.x, touchPoint.y - _touchStartPoint.y)];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
//    CGPoint previousPoint = [touch previousLocationInView:self];
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchView:touchWillEndAtPoint:)]) {
        [_delegate touchView:self touchWillEndAtPoint:touchPoint];
    }
    
    float tolerantRadius = sqrtf(powf(touchPoint.x - _touchStartPoint.x, 2) + powf(touchPoint.y - _touchStartPoint.y, 2));
    
    float touchTime = touch.timestamp - _touchStartTimeStamp;
    
    if (touchTime <= kHPTouchViewTouchLimitationTime && tolerantRadius <= kHPTouchViewTouchTolerantRadius) {
//        NSLog(@"%s -- tap gesture", __func__);
        
        if (_delegate && [_delegate respondsToSelector:@selector(touchView:didClickedAtPoint:)]) {
            [_delegate touchView:self didClickedAtPoint:touchPoint];
        }
        return;
    }
    
    if (touchTime <= kHPTouchViewTouchLimitationTime && tolerantRadius > kHPTouchViewTouchTolerantRadius) {
//        NSLog(@"%s -- swipe gesture", __func__);
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    if (touchTime > kHPTouchViewTouchLimitationTime && tolerantRadius <= kHPTouchViewTouchTolerantRadius) {
//        NSLog(@"%s -- long press gesture", __func__);
        return;
    }
    
    if (touchTime > kHPTouchViewTouchLimitationTime && tolerantRadius > kHPTouchViewTouchTolerantRadius) {
    
        if (_delegate && [_delegate respondsToSelector:@selector(touchView:touchWillMoveToPoint:distance:)]) {
            [_delegate touchView:self touchWillMoveToPoint:touchPoint distance:CGSizeMake(touchPoint.x - _touchStartPoint.x, touchPoint.y - _touchStartPoint.y)];
        }
        return;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    NSLog(@"%s -- touch cancelled" ,__func__);
    
    if (_delegate && [_delegate respondsToSelector:@selector(touchView:touchWillEndAtPoint:)]) {
        [_delegate touchView:self touchWillEndAtPoint:touchPoint];
    }
    
    [self touchesEnded:touches withEvent:event];
}

@end
