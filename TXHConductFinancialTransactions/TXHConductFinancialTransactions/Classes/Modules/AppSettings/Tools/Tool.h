//
//  Tool.h
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/5.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

+ (void)ToastNotification:(NSString *)text;

//存储用户信息
+ (void)setUserInfoWithDict:(NSDictionary *)userInfos;
+ (NSDictionary *)getUserInfo;

@end
