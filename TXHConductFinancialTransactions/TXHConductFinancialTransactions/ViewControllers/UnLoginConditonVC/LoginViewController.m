//
//  LoginViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/4.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#define CELL_HEIGHT 45
#define CELL_NUMBER 5
#define CELL_IMAGE_FIRSTTAG   111
#define CELL_IMAGE_SENCONDTAG 112

@interface LoginViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UITextField *contentTextFiled;
@property (nonatomic, strong) UIButton    *forgetPasswordBtn;
@property (nonatomic, strong) UIButton    *loginBtn;

@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSArray *placeHolders;

//alertView

@property (nonatomic, strong) UIAlertView *forgetPassWordAlertView;

@end

@implementation LoginViewController

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
    self.images = @[@"ic_login_num",@"",@"ic_modify_password"];
    self.placeHolders = @[@"手机号",@"",@"登录密码"];
}

- (void)configUI {
    
    [self navigationBarStyleWithTitle:@"登录" titleColor:[UIColor blackColor]  leftTitle:nil leftImageName:@"img_account_head" leftAction:@selector(popVC) rightTitle:@"注册" rightImageName:nil rightAction:@selector(registeBtnClick)];
    
    [self.view addSubview:self.contentTableView];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (1 == indexPath.row) {
        return 10;
    }else if (4 == indexPath.row) {
        return CELL_HEIGHT + 30;
    }
    
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELL_NUMBER;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Identifier";
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!tableViewCell) {
        
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (1 != indexPath.row) {
            
            if (0 == indexPath.row || 2 == indexPath.row) {
                
                [tableViewCell.contentView addSubview:self.contentImageView];
                [tableViewCell.contentView addSubview:self.contentTextFiled];
                
                tableViewCell.layer.cornerRadius = 5;
                tableViewCell.layer.masksToBounds = YES;
            }else if (3 == indexPath.row){
                [tableViewCell.contentView addSubview:self.forgetPasswordBtn];
            }else{
                [tableViewCell.contentView addSubview:self.loginBtn];
            }
            
            
        }
    }
    
    if (indexPath.row !=0 && indexPath.row != 2) {
        
        tableViewCell.contentView.backgroundColor = COLOR(232, 232, 232, 1.0);
        
    }else{
        
        tableViewCell.contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = (UIImageView *)[tableViewCell.contentView viewWithTag:CELL_IMAGE_FIRSTTAG];
        
        imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
        
        UITextField *textField = (UITextField *)[tableViewCell.contentView viewWithTag:CELL_IMAGE_SENCONDTAG];
        
        if (0 == textField.text.length) {
            textField.placeholder = self.placeHolders[indexPath.row];
        }
    }
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - event response

- (void)forgetPasswordBtnClick:(UIButton *)sender {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.isRestPassword = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)loginBtnClick {
    
}

#pragma mark - private method

- (void)popVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)registeBtnClick {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.isRestPassword = NO;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

#pragma mark - getters and setters

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 30, kScreenWidth - 40, kScreenHeight - 100) style:UITableViewStyleGrouped];
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.scrollEnabled = NO;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
    }
    return _contentTableView;
}

- (UIImageView *)contentImageView {
    
    UIImage *image = [UIImage imageNamed:self.images[0]];
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CELL_HEIGHT - image.size.height)/2, image.size.width, image.size.height)];
    _contentImageView.tag = CELL_IMAGE_FIRSTTAG;
    
    return _contentImageView;
}

- (UITextField *)contentTextFiled {
    
    _contentTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(self.contentImageView.frame.origin.x + self.contentImageView.frame.size.width + 8, 0, kScreenWidth - 50 - self.contentImageView.frame.size.width, CELL_HEIGHT)];
    _contentTextFiled.tag = CELL_IMAGE_SENCONDTAG;
    _contentTextFiled.delegate = self;
    
    return _contentTextFiled;
}

- (UIButton *)forgetPasswordBtn {
    
    if (!_forgetPasswordBtn) {
        _forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetPasswordBtn.frame = CGRectMake(kScreenWidth - 140 , 5, 100, 30);
        [_forgetPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPasswordBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        _forgetPasswordBtn.titleLabel.font = [UIFont fontWithName:FontName size:18];
        _forgetPasswordBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_forgetPasswordBtn addTarget:self action:@selector(forgetPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordBtn;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(0, 20, kScreenWidth - 40, 44);
        _loginBtn.backgroundColor = [UIColor orangeColor];
        _loginBtn.layer.cornerRadius = 4;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setTitle:@"立即登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBtn;
}

@end
