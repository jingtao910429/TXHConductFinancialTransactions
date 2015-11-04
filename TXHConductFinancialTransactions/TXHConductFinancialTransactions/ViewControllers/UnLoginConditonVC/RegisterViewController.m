//
//  RegisterViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/4.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "RegisterViewController.h"
#import "FactoryManager.h"
#import "RYSmsManager.h"
#import "GetVertifyCodeAPICmd.h"
#import "LoginViewController.h"

#define CELL_NUMBERS 6
#define CELL_HEIGHT 45

@interface RegisterViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,APICmdApiCallBackDelegate>

@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong) UIImage *topImage;

@property (nonatomic, strong) UIView *phoneView;
@property (nonatomic, strong) UIView *vertifyCodeView;
@property (nonatomic, strong) UIButton *getVertifyBtn;

@property (nonatomic, strong) UIButton    *registerBtn;

//数据请求
@property (nonatomic, strong) GetVertifyCodeAPICmd *getVertifyCodeAPICmd;

@end

@implementation RegisterViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configData];
    [self configUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configData {
    
    self.topImage = [UIImage imageNamed:@"bg_account"];
    
}

- (void)configUI {
    
    if (self.isRestPassword) {
        [self navigationBarStyleWithTitle:@"重置密码" titleColor:[UIColor blackColor]  leftTitle:nil leftImageName:@"img_account_head" leftAction:@selector(popVC) rightTitle:@"登录" rightImageName:nil rightAction:@selector(loginBtnClick)];
    }else{
        [self navigationBarStyleWithTitle:@"注册" titleColor:[UIColor blackColor]  leftTitle:nil leftImageName:@"img_account_head" leftAction:@selector(popVC) rightTitle:@"登录" rightImageName:nil rightAction:@selector(loginBtnClick)];
    }
    
    
    
    [self.view addSubview:self.contentTableView];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.topImage.size.height/self.topImage.size.width * (kScreenWidth * 1.0) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.row ) {
        return 25;
    }else if (2 == indexPath.row || 4 == indexPath.row) {
        return 15;
    }
    
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return CELL_NUMBERS;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:self.topImage];
    topImageView.frame = CGRectMake(0, 0, kScreenWidth, self.topImage.size.height/self.topImage.size.width * (kScreenWidth * 1.0));
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    return topImageView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Identifier";
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!tableViewCell) {
        
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableViewCell.contentView.backgroundColor = COLOR(232, 232, 232, 1.0);
        
        if (1 == indexPath.row) {
            
            self.phoneView = [[FactoryManager shareManager] createCellViewWithFrame:CGRectMake(20, 0, kScreenWidth - 40, CELL_HEIGHT) imageName:@"ic_login_num" placeHolder:@"请输入手机号" imageTag:indexPath.row textFiledTag:indexPath.row * 10 cellHeight:CELL_HEIGHT target:self isNeedImage:YES];
            
            [tableViewCell.contentView addSubview:self.phoneView];
            
        }else if (3 == indexPath.row) {
            
            self.vertifyCodeView = [[FactoryManager shareManager] createCellViewWithFrame:CGRectMake(20, 0, (kScreenWidth - 40 - 20)*2.0/3, CELL_HEIGHT) imageName:@"ic_login_num" placeHolder:@"短信验证码" imageTag:indexPath.row textFiledTag:indexPath.row * 10  cellHeight:CELL_HEIGHT target:self isNeedImage:YES];
            
            [tableViewCell.contentView addSubview:self.vertifyCodeView];
            
            [tableViewCell.contentView addSubview:self.getVertifyBtn];
            
        }else if (5 == indexPath.row) {
            [tableViewCell.contentView addSubview:self.registerBtn];
        }
        
    }
    
    return tableViewCell;
}

#pragma mark - APICmdApiCallBackDelegate

- (void)apiCmdDidSuccess:(RYBaseAPICmd *)baseAPICmd responseData:(id)responseData {
    
    if (baseAPICmd == self.getVertifyCodeAPICmd) {
        
        if ([responseData[@"Status"] integerValue] != 1){
            [self.timer invalidate];
            [self canGetVerifyCode];
            if (![responseData[@"Message"] isEqual:[NSNull null]]){
                
                self.alertView.message = responseData[@"Message"];
                [self.alertView show];
            }
        }
        else{
            
            [RYSmsManager defaultManager].count = self.second  + [RYSmsManager defaultManager].second;
            //将手机号和时间以键值存入字典中(针对多个手机号同时获取验证码时间显示)
            [[RYSmsManager defaultManager].infoDictionary  setObject:[NSString stringWithFormat:@"%ld",(long)[RYSmsManager defaultManager].count] forKey:[RYSmsManager defaultManager].mobile];
        }
        
    }
    
}

- (void)apiCmdDidFailed:(RYBaseAPICmd *)baseAPICmd error:(NSError *)error {
    
}

#pragma mark - event response

//获取验证码
- (void)getVertifyBtnClick {
    
    [self.view endEditing:YES];
    
    UITextField *phoneTF = (UITextField *)[self.phoneView viewWithTag:10];
    
    if ([self isMobileNumber:phoneTF.text]) {
        [RYSmsManager defaultManager].mobile = phoneTF.text;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        //网络请求
        [self.getVertifyCodeAPICmd loadData];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码输入错误" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

//立即注册
- (void)registerBtnClick {
    
}

#pragma mark - private method

- (void)popVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//登录
- (void)loginBtnClick {
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)timerFireMethod {
    
    if (self.second == 1) {
        [self.timer invalidate];
        [self canGetVerifyCode];
    }else{
        self.second--;
        [self gettingVerifyCode];
    }
    
}

//倒计时开启状态
-(void)gettingVerifyCode{
    
    self.getVertifyBtn.enabled = NO;
    NSString *title = [NSString stringWithFormat:@"%ld秒后重新获取",(long)self.second];
    [self.getVertifyBtn setTitle:title forState:UIControlStateNormal];
}
//倒计时关闭状态
-(void)canGetVerifyCode{
    
    self.second = 60;
    self.getVertifyBtn.enabled = YES;
    [self.getVertifyBtn setTitle:@"点击获取" forState:UIControlStateNormal];
}

//手机号码判断
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * regex = @"1[0-9]{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:mobileNum];
    return isMatch;
}

#pragma mark - getters and setters

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.scrollEnabled = NO;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
    }
    return _contentTableView;
}

- (UIButton *)getVertifyBtn {
    if (!_getVertifyBtn) {
        _getVertifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getVertifyBtn.frame = CGRectMake(self.vertifyCodeView.frame.origin.x + self.vertifyCodeView.frame.size.width + 20, 0, (kScreenWidth - 40 - 20)*1.0/3, CELL_HEIGHT);
        _getVertifyBtn.backgroundColor = COLOR(239, 71, 26, 1.0);
        [_getVertifyBtn setTitle:@"点击获取" forState:UIControlStateNormal];
        [_getVertifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getVertifyBtn addTarget:self action:@selector(getVertifyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _getVertifyBtn.layer.cornerRadius = 5;
        _getVertifyBtn.layer.masksToBounds = YES;
    }
    return _getVertifyBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(20, 10, kScreenWidth - 40, 44);
        _registerBtn.backgroundColor = COLOR(239, 71, 26, 1.0);
        _registerBtn.layer.cornerRadius = 4;
        _registerBtn.layer.masksToBounds = YES;
        
        if (self.isRestPassword) {
            [_registerBtn setTitle:@"验证手机号码" forState:UIControlStateNormal];
        }else{
            [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        }
        
        
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _registerBtn;
}

- (GetVertifyCodeAPICmd *)getVertifyCodeAPICmd {
    if (!_getVertifyCodeAPICmd) {
        _getVertifyCodeAPICmd = [[GetVertifyCodeAPICmd alloc] init];
        _getVertifyCodeAPICmd.delegate = self;
        _getVertifyCodeAPICmd.path = @"";
        _getVertifyCodeAPICmd.reformParams = @{};
    }
    return _getVertifyCodeAPICmd;
}

@end
