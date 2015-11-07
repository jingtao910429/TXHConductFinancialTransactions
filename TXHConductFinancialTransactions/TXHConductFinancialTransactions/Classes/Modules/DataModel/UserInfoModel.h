//
//  UserInfoModel.h
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/7.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "CommonModel.h"

@interface UserInfoModel : CommonModel

@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *bankCardNum;
@property (nonatomic, copy) NSString *idCard;
@property (nonatomic, copy) NSNumber *income;
@property (nonatomic, copy) NSString *kfPhone;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *remainAsset;
@property (nonatomic, copy) NSString *yesterdayIncome;

@end
