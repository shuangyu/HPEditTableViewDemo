//
//  ILSEditTableView.m
//  UITableViewDemo
//
//  Created by hupeng on 14-10-10.
//  Copyright (c) 2014年 hupeng. All rights reserved.
//

#import "HPEditTableView.h"
#import "HPEditTableViewCell.h"

@interface HPEditTableView()<HPEditTableViewCellProtocol>
{
    HPEditTableViewCell *_editingCell;
}
@end

@implementation HPEditTableView

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    id cell = [super dequeueReusableCellWithIdentifier:identifier];
    
    if ([cell isKindOfClass:[HPEditTableViewCell class]]) {
        ((HPEditTableViewCell *)cell).delegate = self;
        
    }
    return cell;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    id cell = [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[HPEditTableViewCell class]]) {
        
        HPEditTableViewCell *editCell = (HPEditTableViewCell *)cell;
        editCell.delegate = self;
    }
    return cell;
}

#pragma mark - ILSEditTableViewCellProtocol

- (BOOL)cellCanEditing:(HPEditTableViewCell *)cell
{
    [_editingCell cancelEditing];
    return _editingCell == nil;
}

- (void)cellWillBeginTranslate:(HPEditTableViewCell *)cell
{
    self.scrollEnabled = FALSE;
}

- (void)cellDidEndTranslate:(HPEditTableViewCell *)cell
{
    self.scrollEnabled = TRUE;
}

- (void)cellDidCancelEditing:(HPEditTableViewCell *)cell
{
    _editingCell = nil;
    self.scrollEnabled = TRUE;
}
- (void)cellDidBeginEditing:(HPEditTableViewCell *)cell
{
    _editingCell = cell;
    self.scrollEnabled = FALSE;
}

- (void)clickCell:(HPEditTableViewCell *)cell
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.delegate tableView:self didSelectRowAtIndexPath:[self indexPathForCell:cell]];
    }
}
@end
