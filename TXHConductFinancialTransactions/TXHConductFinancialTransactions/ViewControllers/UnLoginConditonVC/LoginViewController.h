//
//  LoginViewController.h
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/4.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

//区分是登录还是设置密码
@property (nonatomic, assign) BOOL isSetPassword;
//区分是注册还是重置密码
@property (nonatomic, assign) BOOL isRegisterPassword;
@property (nonatomic, copy)   NSString *userName;

@end
