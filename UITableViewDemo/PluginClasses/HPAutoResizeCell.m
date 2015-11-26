//
//  HPAutoResizeCell.m
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/14.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import "HPAutoResizeCell.h"
#import "UIColor+ColorExt.h"
#import "HPCommonMacro.h"
#import "HPLine.h"

@interface HPAutoResizeCell ()
{
    HPLine *_topLine;
    HPLine *_bottomLine;
}
@end

@implementation HPAutoResizeCell

- (void)setShouldHightLight:(BOOL)shouldHightLight
{
    [self setShouldHightLight:shouldHightLight animated:NO];
}

- (void)setShouldHightLight:(BOOL)shouldHightLight animated:(BOOL)animated
{
    _shouldHightLight = shouldHightLight;
    
    self.autoResizeContentView.backgroundColor = shouldHightLight ? [UIColor colorWithR:154 g:82 b:234 a:0.1] : [UIColor whiteColor];
    
    if (shouldHightLight && animated) {
        [UIView animateWithDuration:0.75 animations:^{
            self.autoResizeContentView.backgroundColor = [UIColor colorWithR:154 g:82 b:234 a:0.2];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.75 animations:^{
                self.autoResizeContentView.backgroundColor = [UIColor colorWithR:154 g:82 b:234 a:0.1];
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self refreshSubviews];
    
    [self bringSubviewToFront:_topLine];
    [self bringSubviewToFront:_bottomLine];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self refreshSubviews];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cell_highlight"]];
}

- (void)refreshSubviews
{
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        _autoResizeContentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - 40, CGRectGetHeight(self.bounds));
    } else {
        _autoResizeContentView.frame = self.bounds;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [_topLine removeFromSuperview];
    [_bottomLine removeFromSuperview];
    _topLine    = nil;
    _bottomLine = nil;
}

- (void)setSeperateLines:(HPSectionSeperateLine)seperateLines
{
    if ((HPSectionSeperateLineBottom & seperateLines) && !_bottomLine) {
        _bottomLine = [HPLine horizontalLineWithWidth:CGRectGetWidth(self.bounds)];
        CGRect frame = _bottomLine.frame;
        frame.origin.y = CGRectGetHeight(self.bounds) - HP_ONE_PX_SIZE;
        _bottomLine.frame = frame;
        _bottomLine.backgroundColor = [UIColor colorWithR:203 g:203 b:203 a:1.0];
        _bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_bottomLine];
    }
    
    if ((HPSectionSeperateLineTop & seperateLines) && !_topLine) {
        _topLine = [HPLine horizontalLineWithWidth:CGRectGetWidth(self.bounds)];
        _topLine.backgroundColor = [UIColor colorWithR:203 g:203 b:203 a:1.0];
        _topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_topLine];
    }
}

@end
