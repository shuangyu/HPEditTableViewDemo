//
//  HPAutoResizeCell.h
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/14.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HPSectionSeperateLineTop    = 1 << 1,
    HPSectionSeperateLineBottom = 1 << 2
} HPSectionSeperateLine;

@interface HPAutoResizeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *autoResizeContentView;
@property (nonatomic, assign)  HPSectionSeperateLine seperateLines;

@property (nonatomic, assign) BOOL shouldHightLight;

- (void)setShouldHightLight:(BOOL)shouldHightLight animated:(BOOL)animated;

@end
