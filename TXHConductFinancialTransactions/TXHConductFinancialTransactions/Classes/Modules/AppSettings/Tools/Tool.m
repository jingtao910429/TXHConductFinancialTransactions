//
//  Tool.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/5.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "Tool.h"

@implementation Tool

+ (void)ToastNotification:(NSString *)text{
    
    [WToast showWithText:text duration:1.5];
    
}

+ (void)setUserInfoWithDict:(NSDictionary *)userInfos {
    NSString *userInfoStr = [[EncryptionManager shareManager] encodeWithData:userInfos version:VERSION];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:userInfoStr forKey:@"userInfo"];
    [defaults synchronize];
}

+ (NSDictionary *)getUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[EncryptionManager shareManager] decodeWithStr:[defaults objectForKey:@"userInfo"] version:VERSION];
}

@end
