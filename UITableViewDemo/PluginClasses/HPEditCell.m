//
//  HPEditCell.m
//  EdtiCellTest
//
//  Created by 胡鹏 on 15/5/3.
//  Copyright (c) 2015年 胡鹏. All rights reserved.
//

#import "HPEditCell.h"
#import "NSBKeyframeAnimation.h"
#import "UIColor+ColorExt.h"

#define kAnimationDuration 0.3f
#define kSuccessAnimationDuration 0.5f
#define kAnimationSpringLevel 1.0f
#define HPHIGHLIGHTVIEW_HIGH_LIGHT_COLOR [UIColor colorWithR:244 g:244 b:244 a:1.0]

@interface HPHighLightView ()
{
    UIColor *_backgroundColor;
}
@end

@implementation HPHighLightView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_backgroundColor) {
        _backgroundColor = self.backgroundColor;
    }
    self.backgroundColor = HPHIGHLIGHTVIEW_HIGH_LIGHT_COLOR;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _backgroundColor;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = _backgroundColor;
}

- (void)setHightLight:(BOOL)hightLight
{
    _hightLight = hightLight;
    
    if (!_backgroundColor) {
        _backgroundColor = self.backgroundColor;
    }
    
    self.backgroundColor = _hightLight ? HPHIGHLIGHTVIEW_HIGH_LIGHT_COLOR : _backgroundColor;
    
}

@end


@interface HPEditCell () <UIScrollViewDelegate>
{
    CGRect _leftButtonsArea;
    CGRect _rightButtonsArea;
    
    float _offsetX;
    
    BOOL _canEditing;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet HPHighLightView *editCellContentView;

@end

@implementation HPEditCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (!selected) {
        if ([_editCellContentView isKindOfClass:[HPHighLightView class]]) {
            _editCellContentView.hightLight = FALSE;
        }
    }
}

- (void)updateInterface
{
    _isAnimating = FALSE;
    
    int w = CGRectGetWidth(self.bounds);
    int h = CGRectGetHeight(self.bounds);
    
    _leftButtonsArea = CGRectMake(0, 0, 0, h);
    _rightButtonsArea = CGRectMake(w, 0, 0, h);
    
    for (UIButton *button in _leftButtons) {
        _leftButtonsArea.size.width += CGRectGetWidth(button.frame);
    }
    
    for (UIButton *button in _rightButtons) {
        _rightButtonsArea.size.width += CGRectGetWidth(button.frame);
        _rightButtonsArea.origin.x -= CGRectGetWidth(button.frame);
    }
    
    _offsetX = CGRectGetWidth(_leftButtonsArea);
    
    _scrollView.contentSize = CGSizeMake(w + CGRectGetWidth(_rightButtonsArea) + CGRectGetWidth(_leftButtonsArea), h);
    _scrollView.contentOffset = CGPointMake(_offsetX, 0);
    _editCellContentView.frame = CGRectMake(_offsetX, 0, w, h);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.isAnimating = FALSE;
    self.isEditingMode = FALSE;
    self.currentStatus = HPEditCellStatusNormal;
    _editCellContentView.backgroundColor = [UIColor whiteColor];
    [self updateInterface];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self updateInterface];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    UITapGestureRecognizer *tapButtons = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapButtons:)];
    [_scrollView addGestureRecognizer:tapButtons];
    
    UITapGestureRecognizer *tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
    [_editCellContentView addGestureRecognizer:tapCell];
    
    _isAnimating = FALSE;
    
    [tapButtons requireGestureRecognizerToFail:tapCell];
}

- (void)cancelEditing
{
    if (!_isEditingMode) {
        return;
    }
    [_scrollView scrollRectToVisible:_editCellContentView.frame animated:YES];
    self.isEditingMode = FALSE;
    self.currentStatus = HPEditCellStatusNormal;
    self.isAnimating = FALSE;
    
    [self cellDidEndEditing];
}

#pragma mark - event handlers

- (void)tapCell:(UITapGestureRecognizer *)tapGesture
{
    if (_isAnimating) {
        return;
    }
    if (_isEditingMode) {
        [self cancelEditing];
        return;
    }
    
    [_tableView selectRowAtIndexPath:[_tableView indexPathForCell:self] animated:YES scrollPosition:UITableViewScrollPositionNone];
    if (_tableView.delegate && [_tableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_tableView.delegate tableView:_tableView didSelectRowAtIndexPath:[_tableView indexPathForCell:self]];
    }
}

- (void)tapButtons:(UITapGestureRecognizer *)tapGesture
{
    CGPoint tapPoint = [tapGesture locationInView:self];
    
    if (CGRectContainsPoint(_leftButtonsArea, tapPoint)) {
        
        for (UIButton *button in _leftButtons) {
            if (CGRectContainsPoint(button.frame, tapPoint)) {
                [self actionButtonClicked:button];
                return;
            }
        }
        
    } else if (CGRectContainsPoint(_rightButtonsArea, tapPoint)) {
        for (UIButton *button in _rightButtons) {
            if (CGRectContainsPoint(button.frame, tapPoint)) {
                [self actionButtonClicked:button];
                return;
            }
        }
    }
}

- (void)actionButtonClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(obj:respondsToAction:)]) {
        [_delegate obj:self respondsToAction:sender];
    }
}

#pragma mark - methods to be implemented

- (void)cellWillBeginTranslate
{
    //...
}
- (void)cellDidEndEditing
{
    //...
}
- (void)cellDidBeginEditing
{
    //...
}

- (void)showGuideAnimation
{
    if (_leftButtons && _leftButtons.count > 0) {

        // TO DO...
    } else  if (_rightButtons && _rightButtons.count > 0) {
        
        _isAnimating = TRUE;
        // fix bug : https://app.ilegendsoft.com/jira/browse/SP-445
        float startValue = (CGRectGetWidth(self.bounds) - CGRectGetWidth(_rightButtonsArea)) * 0.5;
        float endValue = CGRectGetWidth(self.bounds) * 0.5;
        NSString *keyPath = @"position.x";
        NSBKeyframeAnimation *animation = [NSBKeyframeAnimation animationWithKeyPath:keyPath duration:kAnimationDuration*2 startValue:startValue endValue:endValue function:NSBKeyframeAnimationFunctionEaseOutBounce];
        
        animation.completionBlock = ^(BOOL finished) {
            if (finished) {
                _isAnimating = FALSE;
            }
        };
        [_scrollView.layer setValue:@(endValue) forKeyPath:keyPath];
        [_scrollView.layer addAnimation:animation forKey:keyPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSArray *visibleCells = [_tableView visibleCells];
    
    _canEditing = TRUE;
    for (HPEditCell *cell in visibleCells) {
        if (![cell isKindOfClass:[HPEditCell class]]) {
            continue;
        }
        if ([cell isEqual:self]) {
            continue;
        }
        if (cell.isEditingMode) {
            [cell cancelEditing];
            _canEditing = FALSE;
            return;
        } else if (cell.isAnimating) {
            _canEditing = FALSE;
            return;
        }
    }
    
    if (self.disableEditing || !_canEditing || _tableView.isEditing) {
        return;
    }
    
    _isAnimating = TRUE;
    
    [self cellWillBeginTranslate];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.disableEditing || !_canEditing || _tableView.isEditing) {

        scrollView.contentOffset = CGPointMake(_offsetX, 0);
        return;
    }
    float offsetX = scrollView.contentOffset.x;
    if (offsetX > _offsetX && CGRectGetWidth(_rightButtonsArea) == 0) {
        scrollView.contentOffset = CGPointMake(_offsetX, 0);
        return;
    }

    if (offsetX < _offsetX && CGRectGetWidth(_leftButtonsArea) == 0) {
        scrollView.contentOffset = CGPointMake(_offsetX, 0);
        return;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        _isAnimating = FALSE;
        if (scrollView.contentOffset.x == _offsetX) {
            self.currentStatus = HPEditCellStatusNormal;
            self.isEditingMode = FALSE;
            [self cellDidEndEditing];
        } else if (scrollView.contentOffset.x == 0) {
            self.currentStatus = HPEditCellStatusLeftEditing;
            self.isEditingMode = TRUE;
            [self cellDidBeginEditing];
        } else {
            self.currentStatus = HPEditCellStatusRightEditing;
            self.isEditingMode = TRUE;
            [self cellDidBeginEditing];
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.disableEditing || !_canEditing || _tableView.isEditing) {
        *targetContentOffset = CGPointMake(_offsetX, 0);
        return;
    }
    
    float leftButtonsAreaWidth = CGRectGetWidth(_leftButtonsArea);
    float rightButtonsAreaWidth = CGRectGetWidth(_rightButtonsArea);
    
    if (velocity.x >= 0.5) {
        // swipe left - end up with showing right buttons
        *targetContentOffset = CGPointMake(leftButtonsAreaWidth + rightButtonsAreaWidth, 0);
    } else if (velocity.x <= -0.5) {
        // swipe right - end up with showing left buttons
        *targetContentOffset = CGPointMake(0, 0);
    } else {
        float targetOffsetX = (*targetContentOffset).x;
        
        if (targetOffsetX < leftButtonsAreaWidth * 0.5) {
            *targetContentOffset = CGPointMake(0, 0);
        } else if (targetOffsetX > leftButtonsAreaWidth + rightButtonsAreaWidth * 0.5) {
        
            *targetContentOffset = CGPointMake(leftButtonsAreaWidth + rightButtonsAreaWidth, 0);
        } else {
            *targetContentOffset = CGPointMake(_offsetX, 0);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isAnimating = FALSE;
    if (scrollView.contentOffset.x == _offsetX) {
        self.currentStatus = HPEditCellStatusNormal;
        self.isEditingMode = FALSE;
        [self cellDidEndEditing];
    } else if (scrollView.contentOffset.x == 0) {
        self.currentStatus = HPEditCellStatusLeftEditing;
        self.isEditingMode = TRUE;
        [self cellDidBeginEditing];
    } else {
        self.currentStatus = HPEditCellStatusRightEditing;
        self.isEditingMode = TRUE;
        [self cellDidBeginEditing];
    }
}

@end
