//
//  EarnDetailModel.h
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/7.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "CommonModel.h"

@interface EarnDetailModel : CommonModel

/*
 canInvest = "-33068000";
 createDate = "2015-10-12+17:14:35";
 id = 5;
 max = 500000;
 min = 50;
 money = 100000000;
 name = "\U6295\U5c0f\U7334\U7406\U8d22\U7b2c5\U671f";
 rate = 10;
 realMoney = 89818000;
 status = 2;
 version = 42;
 
 */

@property (nonatomic, copy) NSString *canInvest;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *max;
@property (nonatomic, copy) NSString *min;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *realMoney;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *version;



@end
