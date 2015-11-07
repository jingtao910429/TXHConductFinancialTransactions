//
//  UserAssetModel.h
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/6.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "CommonModel.h"

@interface UserAssetModel : CommonModel

@property (nonatomic, copy) NSString *allAsset;
@property (nonatomic, copy) NSString *bankCardNum;
@property (nonatomic, copy) NSString *freeze;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *invest;
@property (nonatomic, copy) NSString *rate;
@property (nonatomic, copy) NSString *remainAsset;
@property (nonatomic, copy) NSString *yesterdayIncome;

@end
