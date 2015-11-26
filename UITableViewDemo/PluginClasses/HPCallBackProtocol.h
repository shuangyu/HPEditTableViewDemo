//
//  ILSPPCallBackProtocol.h
//  ILSPrivatePhoto
//
//  Created by hupeng on 15/4/30.
//  Copyright (c) 2015年 iLegendSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HPCallBackProtocol <NSObject>

@optional
- (void)obj:(id)obj respondsToAction:(id)actionInfo;

@end
