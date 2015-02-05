//
//  ILSEditTableViewCell.m
//  UITableViewDemo
//
//  Created by hupeng on 14-10-10.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

#import "HPEditTableViewCell.h"

@interface HPEditTableViewCell()<HPTouchViewProtocol>
{
    CGPoint _touchStartPoint;
    
    CGRect _contentViewFrame;
    
    CGRect _animationFromFrame;
    
    float _minOffsetX;
    
    float _maxOffsetX;
    
    BOOL _animating;
}

@end

@implementation HPEditTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupCell];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topView.frame = self.bounds;
    self.bottomView.frame = _topView.bounds;
    
    if (CGRectEqualToRect(_contentViewFrame, CGRectZero)) {
        _contentViewFrame = self.bounds;
        for (UIButton *button in _editButtons) {
            button.enabled = FALSE;
            _minOffsetX = MIN(_minOffsetX, CGRectGetMinX(button.frame));
            _maxOffsetX = MAX(_maxOffsetX, CGRectGetMinX(button.frame));
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    if (!CGRectEqualToRect(_contentViewFrame, CGRectZero)) {
        [_topView setFrame:_contentViewFrame];
    }
}

- (void)setupCell
{
    _contentViewFrame = CGRectZero;
    _minOffsetX = CGRectGetWidth(self.bounds);
    _maxOffsetX = 0.0;
    
    _bottomView.clipsToBounds = TRUE;
    _bottomView.touchDirection = HPTouchViewTouchDirectionHor;
    _bottomView.delegate = self;
}

- (void)cancelEditing
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidCancelEditing:)]) {
        [_delegate cellDidCancelEditing:self];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _topView.frame = _contentViewFrame;
    }];
}

- (void)didBeginEditing
{
    //...
}

- (void)willBeginTranslate
{
    //...
}
- (void)didEndTranslate
{
    //..
}

- (void)didCancelEditing
{
    //..
}

#pragma mark - HPTouchViewProtocol

- (void)touchView:(HPTouchView *)touchView touchWillMoveFromPoint:(CGPoint)point
{
    
    if (_animating) {
        return;
    }
    
    if (![_delegate cellCanEditing:self]) {
        return;
    }
    
    _animationFromFrame = _topView.frame;
    
    
}

- (void)touchView:(HPTouchView *)touchView touchWillMoveToPoint:(CGPoint)point distance:(CGSize)distance
{
    if (_animating) {
        return;
    }
    
    if (![_delegate cellCanEditing:self]) {
        return;
    }
    
    [self willBeginTranslate];
    if (_delegate && [_delegate respondsToSelector:@selector(cellWillBeginTranslate:)]) {
        [_delegate cellWillBeginTranslate:self];
    }
    
    int fromWidth = _animationFromFrame.size.width;
    
    int toWidth = fromWidth + distance.width;
    
    int minWidth = _minOffsetX;
    
    
    if (toWidth <= minWidth) {
        
        toWidth = minWidth + (distance.width + (fromWidth - minWidth)) / 5;
    }
    toWidth = _contentViewFrame.size.width > toWidth ? toWidth : _contentViewFrame.size.width;
    //    toWidth = MIN(_contentViewFrame.size.width, toWidth);
    
    
    _topView.frame = CGRectMake(0, 0, toWidth , _contentViewFrame.size.height);
}

- (void)touchView:(HPTouchView *)touchView touchWillEndAtPoint:(CGPoint)point
{
    if (_animating) {
        return;
    }
    
    if (![_delegate cellCanEditing:self]) {
        return;
    }
    [self didEndTranslate];
    if (_delegate && [_delegate respondsToSelector:@selector(cellDidEndTranslate:)]) {
        [_delegate cellDidEndTranslate:self];
    }
    
    for (UIButton *button in _editButtons) {
        button.enabled = TRUE;
    }
    
    float currentX = CGRectGetMaxX(_topView.frame);
    
    @synchronized(_topView) {
        
        _animating = TRUE;
        
        if (currentX > _maxOffsetX) {
            
            [self didCancelEditing];
            if (_delegate && [_delegate respondsToSelector:@selector(cellDidCancelEditing:)]) {
                [_delegate cellDidCancelEditing:self];
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                _topView.frame = _contentViewFrame;
            } completion:^(BOOL finished) {
                _animating = FALSE;
            }];
        } else {
            [self didBeginEditing];
            if (_delegate && [_delegate respondsToSelector:@selector(cellDidBeginEditing:)]) {
                [_delegate cellDidBeginEditing:self];
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                _topView.frame = CGRectMake(0, 0, _minOffsetX , CGRectGetHeight(_contentViewFrame));
            } completion:^(BOOL finished) {
                _animating = FALSE;
            }];
        }
    }
}

- (void)touchView:(HPTouchView *)touchView didClickedAtPoint:(CGPoint)point
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickCell:)]) {
        [_delegate clickCell:self];
    }
}
@end
