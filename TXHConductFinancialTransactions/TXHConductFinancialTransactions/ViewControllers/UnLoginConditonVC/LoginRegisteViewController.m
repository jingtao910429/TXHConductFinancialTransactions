//
//  LoginViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/4.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "LoginRegisteViewController.h"

#define CELL_HEIGHT 40
#define CELL_IMAGE_FIRSTTAG   111
#define CELL_IMAGE_SENCONDTAG 112

@interface LoginRegisteViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *contentTableView;

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UITextField *contentTextFiled;

@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSArray *placeHolders;

@end

@implementation LoginRegisteViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    }
    
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Identifier";
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!tableViewCell) {
        
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (1 != indexPath.row) {
            [tableViewCell.contentView addSubview:self.contentImageView];
            [tableViewCell.contentView addSubview:self.contentTextFiled];
            
            tableViewCell.layer.cornerRadius = 5;
            tableViewCell.layer.masksToBounds = YES;
        }
    }
    
    if (1 == indexPath.row) {
        
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


- (void)configData {
    self.images = @[@"ic_login_num",@"",@"ic_modify_password"];
    self.placeHolders = @[@"手机号",@"",@"密码"];
}

- (void)configUI {
    
    NSString *titleStr = @"";
    NSString *otherTitleStr = @"";
    
    if (self.isLogin) {
        titleStr = @"登录";
        otherTitleStr = @"注册";
    }else {
        titleStr = @"注册";
        otherTitleStr = @"登录";
    }
    
    [self navigationBarStyleWithTitle:titleStr titleColor:[UIColor blackColor]  leftTitle:nil leftImageName:@"img_account_head" leftAction:@selector(popVC) rightTitle:otherTitleStr rightImageName:nil rightAction:@selector(navigationBarBtnClick)];
    
    [self.view addSubview:self.contentTableView];
    
}

#pragma mark - private method

- (void)popVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)navigationBarBtnClick {
    
    LoginRegisteViewController *loginRegisteVC = [[LoginRegisteViewController alloc] init];
    
    if (self.isLogin) {
        loginRegisteVC.isLogin = NO;
    }else{
        loginRegisteVC.isLogin = YES;
    }
    
    [self.navigationController pushViewController:loginRegisteVC animated:YES];
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
    if (!_contentImageView) {
        UIImage *image = [UIImage imageNamed:self.images[0]];
        
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (CELL_HEIGHT - image.size.height), image.size.width, image.size.height)];
        _contentImageView.image = image;
        _contentImageView.tag = CELL_IMAGE_FIRSTTAG;
    }
    return _contentImageView;
}

- (UITextField *)contentTextFiled {
    if (!_contentTextFiled) {
        _contentTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(self.contentTableView.frame.origin.x + self.contentTableView.frame.size.width + 5, self.contentTableView.frame.origin.y, kScreenWidth - 50 - self.contentTableView.frame.size.width, self.contentTableView.frame.size.height)];
        _contentTextFiled.tag = CELL_IMAGE_SENCONDTAG;
        _contentTextFiled.delegate = self;
    }
    return _contentTextFiled;
}

@end
