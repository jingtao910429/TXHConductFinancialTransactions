//
//  RechargeWithDrawDepositViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/8.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "RechargeWithDrawDepositViewController.h"
#import "UIViewController+NavigationBarStyle.h"
#import "RechargeCell.h"
#import "UserInfoAPICmd.h"
#import "UserInfoModel.h"
#import "NSString+Additions.h"
#import "CashPreAPICmd.h"
#import "CashApplayAPICmd.h"
#import "PayPreAPICmd.h"

static NSString *kLLOidPartner = @"201510201000546503";   // 商户号
static NSString *kLLPartnerKey = @"ihzb1l7xgv20151020";   // 密钥

@interface RechargeWithDrawDepositViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,APICmdApiCallBackDelegate,LLPaySdkDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *inputMoneyTF;

@property (nonatomic, strong) UITableView *RechargeView;

@property (nonatomic, strong) NSArray *nameArr;
@property (nonatomic, strong) NSArray *textArr;
@property (nonatomic, strong) UILabel *firstLable;

@property (nonatomic, strong) UIView          *tipView;

@property (nonatomic, strong) UserInfoModel *userInfoModel;

//提现前
@property (nonatomic, strong) CashPreAPICmd *cashPreAPICmd;
//提现申请
@property (nonatomic, strong) CashApplayAPICmd *cashApplayAPICmd;
//充值前
@property (nonatomic, strong) PayPreAPICmd *payPreAPICmd;

@property (nonatomic, strong) NSDictionary *dataDict;
//是否是第一次充值

@property (nonatomic, assign) BOOL isFirstPay;

@end

@implementation RechargeWithDrawDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configUI];
    [self createTableview];
    
}


-(void)createTableview{
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGes];
    [self.RechargeView addGestureRecognizer:tapGes];
    
    [self.view addSubview:self.RechargeView];
    
    if (self.isDeposite) {
        [self.cashPreAPICmd loadData];
    }else{
        [self.payPreAPICmd loadData];
    }
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!self.isDeposite) {
        if (self.isFirstPay) {
            //如果没有银行卡
            
            self.nameArr=@[@"账户余额(元)：",@"银行卡：",@"身份证：",@"真实姓名：",@"提现金额(元)："];
            self.textArr = @[@"",@"",@"输入您的身份证",@"输入您的真实姓名",@"输入提现金额"];
            
            return 7;
        }else{
            return 5;
        }
    }else{
        return 5;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isChangeFrame = YES;
    
    if (!self.isDeposite) {
        if (self.isFirstPay) {
            //如果没有银行卡
            isChangeFrame = NO;
        }
    }
    
    if (!isChangeFrame) {
        if (5 == indexPath.row) {
            return 100;
        }else if (6 == indexPath.row) {
            return 250;
        }
    }else{
        if (3 == indexPath.row) {
            return 100;
        }else if (4 == indexPath.row) {
            return 250;
        }
    }
    
    return 50;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger indexFirst = 3;
    NSInteger indexSecond = 4;
    
    if (!self.isDeposite) {
        if (self.isFirstPay) {
            //如果没有银行卡
            indexFirst = 5;
            indexSecond = 6;
        }
    }
    
    if (indexFirst == indexPath.row || indexSecond == indexPath.row) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_ID"];
            
            if (indexFirst == indexPath.row) {
                
                UIButton*querenBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 20, kScreenWidth-20, 44)];
                
                if (self.isDeposite) {
                    [querenBtn setTitle:@"确认提现" forState:UIControlStateNormal];
                }else{
                    [querenBtn setTitle:@"确认充值" forState:UIControlStateNormal];
                }
                
                querenBtn.enabled = YES;
                querenBtn.backgroundColor=[UIColor orangeColor];
                [querenBtn addTarget:self action:@selector(onquerenBtn) forControlEvents:UIControlEventTouchUpInside];
                querenBtn.tag = indexPath.row * 11;
                
                [querenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.contentView addSubview:querenBtn];
                
                
                
            }
            
        }
        
        UIButton* querenBtn = (UIButton *)[cell.contentView viewWithTag:indexPath.row * 11];
        
        if (self.isDeposite) {
            //提现
            if (!self.userInfoModel || !self.userInfoModel.bankCardNum || [self.userInfoModel.bankCardNum isKindOfClass:[NSNull class]] || [self.userInfoModel.bankCardNum isEqualToString:@"未绑定"]) {
                querenBtn.enabled = NO;
                querenBtn.backgroundColor = [UIColor grayColor];
            }else{
                querenBtn.enabled = YES;
                querenBtn.backgroundColor=[UIColor orangeColor];
            }
        }
        
        if (indexSecond == indexPath.row) {
            
            [self.tipView removeFromSuperview];
            [cell.contentView addSubview:self.tipView];
            
            self.tipView.backgroundColor = [UIColor redColor];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    
    static NSString *CellIdentifier = @"RechargeCell";
    RechargeCell *cell = (RechargeCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ RechargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49.5, kScreenWidth, 0.5)];
        imageView.backgroundColor = COLOR(221, 221, 221, 1.0f);
        
        [cell.contentView addSubview:imageView];
        
        if (0 == indexPath.row || 1 == indexPath.row) {
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.leftLable.frame.size.width+10, 10, kScreenWidth-cell.leftLable.frame.size.width+10, 40)];
            tempLabel.tag = indexPath.row + 11;
            [cell.contentView addSubview:tempLabel];
        }
    }
    
    if (indexPath.row != 0 && indexPath.row != 1) {
        
        cell.textField.placeholder = self.textArr[indexPath.row];
        
        cell.textField.hidden = NO;
        
    }else{
        
        cell.textField.hidden = YES;
        
        UILabel *tempLabel = (UILabel *)[cell.contentView viewWithTag:indexPath.row + 11];
        
        NSString *priceStr = [[NSString stringWithFormat:@"%@",self.userInfoModel.income?self.userInfoModel.income:@""] changeYFormatWithMoneyAmount];
        
        
        if (0 == indexPath.row) {
            
            tempLabel.text = priceStr;
            tempLabel.textColor=[UIColor redColor];
            
        }else{
            
            tempLabel.text = [NSString stringWithFormat:@"%@",self.userInfoModel.bankCardNum?self.userInfoModel.bankCardNum:@""];
            tempLabel.textColor=[UIColor grayColor];
            
        }
        
    }
    
    cell.leftLable.text=self.nameArr[indexPath.row];
    cell.textField.tag=indexPath.row;
    cell.textField.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


#pragma mark - APICmdApiCallBackDelegate

- (void)apiCmdDidSuccess:(RYBaseAPICmd *)baseAPICmd responseData:(id)responseData {
    
    NSDictionary *tempDict = (NSDictionary *)responseData;
    
    if (baseAPICmd == self.cashPreAPICmd) {
        
        if ([tempDict[@"result"] intValue] != LoginTypeSuccess) {
            
            [Tool ToastNotification:tempDict[@"msg"]];
            
        }else{
            
            self.userInfoModel = [[UserInfoModel alloc] init];
            self.userInfoModel.bankCardNum = tempDict[@"data"][@"bankCardNum"];
            self.userInfoModel.income = tempDict[@"data"][@"allAsset"];
            
            [self.RechargeView reloadData];
        }
        
    }else if (baseAPICmd == self.cashApplayAPICmd) {
        
        [Tool ToastNotification:tempDict[@"msg"]];
        
        if ([tempDict[@"result"] intValue] != LoginTypeSuccess) {
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else if (baseAPICmd == self.payPreAPICmd){
        
        if ([tempDict[@"result"] intValue] != LoginTypeSuccess) {
            
            [Tool ToastNotification:tempDict[@"msg"]];
            
        }else{
            
            self.dataDict = [[NSDictionary alloc] initWithDictionary:tempDict[@"data"]];
            
            self.isFirstPay = [self.dataDict[@"isFirstPay"] boolValue];
            
            [self.RechargeView reloadData];
            
        }
        
    }
    
}

- (void)apiCmdDidFailed:(RYBaseAPICmd *)baseAPICmd error:(NSError *)error {
    [Tool ToastNotification:@"加载失败"];
}


#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag==1||textField.tag==2||textField.tag==3||textField.tag==4) {
        [textField resignFirstResponder];
    }
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //invertedSet方法是去反字符,把所有的除了kNumber里的字符都找出来(包含去空格功能)
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kkNumber] invertedSet];
    //按cs分离出数组,数组按@""分离出字符串
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
}

#pragma -mark 支付结果 LLPaySdkDelegate
// 订单支付结果返回，主要是异常和成功的不同状态
// TODO: 开发人员需要根据实际业务调整逻辑
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                //
                //NSString *payBackAgreeNo = dic[@"agreementno"];
                // TODO: 协议号
            }
            else if ([result_pay isEqualToString:@"PROCESSING"])
            {
                msg = @"支付单处理中";
            }
            else if ([result_pay isEqualToString:@"FAILURE"])
            {
                msg = @"支付单失败";
            }
            else if ([result_pay isEqualToString:@"REFUND"])
            {
                msg = @"支付单已退款";
            }
        }
            break;
        case kLLPayResultFail:
        {
            msg = @"支付失败";
        }
            break;
        case kLLPayResultCancel:
        {
            msg = @"支付取消";
        }
            break;
        case kLLPayResultInitError:
        {
            msg = @"sdk初始化异常";
        }
            break;
        case kLLPayResultInitParamError:
        {
            msg = dic[@"ret_msg"];
        }
            break;
        default:
            break;
    }
    
    NSString *showMsg = [msg stringByAppendingString:[LLPayUtil jsonStringOfObj:dic]];
    
    [[[UIAlertView alloc] initWithTitle:@"结果"
                                message:showMsg
                               delegate:nil
                      cancelButtonTitle:@"确认"
                      otherButtonTitles:nil] show];
}


#pragma mark - 订单支付
- (void)pay {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self.dataDict[@"config_ll"]];
    
    if (self.isFirstPay) {
        
        //如果是第一次支付
        
        [dict addEntriesFromDictionary:@{
                                          @"id_no":self.dataDict[@"idCard"],
                                          //证件号码 id_no 否 String
                                          @"acct_name":self.dataDict[@"realName"],
                                          //银行账号姓名 acct_name 否 String
                                          }];
        
    }
    
    LLPayUtil *payUtil = [[LLPayUtil alloc] init];
    
    
    // 进行签名
    NSDictionary *signedOrder = [payUtil signedOrderDic:dict
                                             andSignKey:kLLPartnerKey];
    
    
    [LLPaySdk sharedSdk].sdkDelegate = self;
    
    // TODO: 根据需要使用特定支付方式
    
    // 快捷支付
    //[self.sdk presentQuickPaySdkInViewController:self withTraderInfo:signedOrder];
    
    // 认证支付
    [[LLPaySdk sharedSdk] presentVerifyPaySdkInViewController:self withTraderInfo:signedOrder];
    
    // 预授权
    //[self.sdk presentPreAuthPaySdkInViewController:self withTraderInfo:signedOrder];
    
}



#pragma mark - event response

- (void)tap {
    [self.view endEditing:YES];
}

- (void)popVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)onquerenBtn{
    
    if (self.isDeposite) {
        
        RechargeCell * cell = (RechargeCell *)[self.RechargeView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        
        self.inputMoneyTF = (UITextField *)[cell.contentView viewWithTag:2];
        
        if ([self.inputMoneyTF.text intValue] < 100){
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"提现金额必须大于100" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else{
            [self.cashApplayAPICmd loadData];
        }
        
    }else{
        
        
        
    }
    
}


#pragma mark - private method

-(void)configUI{
    
    if (self.isDeposite) {
        
        [self navigationBarStyleWithTitle:@"提现" titleColor:[UIColor blackColor]  leftTitle:@"返回" leftImageName:nil leftAction:@selector(popVC) rightTitle:nil rightImageName:nil rightAction:nil];
        self.nameArr=@[@"账户余额(元):",@"银行卡:",@"提现金额(元):",];
        
        self.textArr=@[@"",@"",@"输入提现金额"];
        
    }else{
        [self navigationBarStyleWithTitle:@"充值" titleColor:[UIColor blackColor]  leftTitle:@"返回" leftImageName:nil leftAction:@selector(popVC) rightTitle:nil rightImageName:nil rightAction:nil];
        self.nameArr=@[@"账户余额(元):",@"银行卡:",@"充值金额(元):",];
        
        self.textArr=@[@"",@"",@"输入充值金额"];
    }
    
    
    
}


-(void)cretedowntextWithView:(UIView *)contentView{
    
    NSArray*lableTextArr = nil;
    
    if (self.isDeposite) {
        
        lableTextArr=@[@"单笔提现限额5万元",@"当日限额5万元，当日提现次数限3次",@"仅支持本人名下银行卡，且与充值同卡",@"提现不收取任何手续费"];
        
    }else{
        
        lableTextArr=@[@"单笔充值金额不低于一元，不高于5万元",@"单日限额5万元,当月限额50万元",@"仅支持本人名下银行卡充值",@"充值不收取任何手续费"];
        
    }
    
    
    for (int i=0; i<4; i++) {
        
        int col = i%4;
        CGRect rect = CGRectMake(12, 42+col*40,10, 10);
        CGRect rect2 = CGRectMake(30, 32+col*40,kScreenWidth-40, 30);
        
        
        UIButton*oneBtn=[[UIButton alloc] init];
        oneBtn.backgroundColor=[UIColor orangeColor];
        oneBtn.layer.cornerRadius = 5.0;
        oneBtn.layer.borderWidth = 0.1;
        oneBtn.frame = rect;
        [contentView addSubview:oneBtn];
        
        
        
        UILabel*onelable=[[UILabel alloc]init];
        
        onelable.frame=rect2;
        onelable.text=lableTextArr[i];
        onelable.font=[UIFont systemFontOfSize:14];
        
        [contentView addSubview:onelable];
    }
    
}

#pragma mark - getters and setters


- (UITableView *)RechargeView {
    if (!_RechargeView) {
        
        _RechargeView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _RechargeView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _RechargeView.dataSource=self;
        _RechargeView.delegate=self;
        _RechargeView.scrollEnabled =YES;
        
        _RechargeView.backgroundColor=[UIColor whiteColor];
        
    }
    return _RechargeView;
}

- (UIView *)tipView {
    
    _tipView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth, 250)];
    
    //温馨提示
    
    UIButton*appcionBtn=[[UIButton alloc] initWithFrame:CGRectMake(12, 6, 18, 18)];
    appcionBtn.backgroundColor=[UIColor orangeColor];
    [appcionBtn setTitle:@"i" forState:UIControlStateNormal];
    appcionBtn.layer.cornerRadius = 9.0;
    appcionBtn.layer.borderWidth = 0.1;
    [appcionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_tipView addSubview:appcionBtn];
    
    
    UILabel*appcionLable=[[UILabel alloc] initWithFrame:CGRectMake(appcionBtn.frame.size.width+18, 0, 100, 30)];
    appcionLable.text=@"温馨提示";
    appcionLable.font=[UIFont systemFontOfSize:12];
    appcionLable.textColor=[UIColor grayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 29.5, kScreenWidth, 0.5)];
    imageView.backgroundColor = COLOR(221, 221, 221, 1.0f);
    
    [_tipView addSubview:imageView];
    
    [_tipView addSubview:appcionLable];
    [self cretedowntextWithView:_tipView];
    return _tipView;
}

- (CashPreAPICmd *)cashPreAPICmd {
    if (!_cashPreAPICmd) {
        _cashPreAPICmd = [[CashPreAPICmd alloc] init];
        _cashPreAPICmd.delegate = self;
        _cashPreAPICmd.path = API_CashPre;
    }
    _cashPreAPICmd.reformParams = @{@"id":[Tool getUserInfo][@"id"]};
    return _cashPreAPICmd;
}

- (CashApplayAPICmd *)cashApplayAPICmd {
    if (!_cashApplayAPICmd) {
        _cashApplayAPICmd = [[CashApplayAPICmd alloc] init];
        _cashApplayAPICmd.delegate = self;
        _cashApplayAPICmd.path = API_CashApplay;
    }
    _cashApplayAPICmd.reformParams = @{@"id":[Tool getUserInfo][@"id"],@"money":[NSNumber numberWithChar:[self.inputMoneyTF.text doubleValue]]};
    return _cashApplayAPICmd;
}

- (PayPreAPICmd *)payPreAPICmd {
    if (!_payPreAPICmd) {
        _payPreAPICmd = [[PayPreAPICmd alloc] init];
        _payPreAPICmd.delegate = self;
        _payPreAPICmd.path = API_PayPre;
    }
    _payPreAPICmd.reformParams = @{@"id":[Tool getUserInfo][@"id"]};
    return _payPreAPICmd;
}


@end
