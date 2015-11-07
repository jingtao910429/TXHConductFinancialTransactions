//
//  MyaccountnumberVC.m
//  TXHConductFinancialTransactions
//
//  Created by 吴建良 on 15/11/4.
//  Copyright © 2015年 rongyu. All rights reserved.
//

#import "MyaccountnumberVC.h"
#import "UIViewController+NavigationBarStyle.h"
#import "MyaccountnumberCell.h"
#import "UnLoginHomePageViewController.h"
#import "UserInfoAPICmd.h"
#import "UserInfoModel.h"

@interface MyaccountnumberVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) UIView*headview;
@property (nonatomic, strong) NSArray *leftDataArr;
@property (nonatomic, strong) UILabel*nameLable;//账号名字

@property (nonatomic, strong) UILabel*priceLable;//余额


@end

@implementation MyaccountnumberVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configUI];
}

-(void)configUI{    
    
    [self navigationBarStyleWithTitle:@"我的账号" titleColor:[UIColor blackColor]  leftTitle:@"返回" leftImageName:nil leftAction:@selector(popVC) rightTitle:nil rightImageName:nil rightAction:nil];
    //添加视图
    [self.view addSubview:self.contentTableView];
    
    self.leftDataArr=[[NSArray alloc] initWithObjects:@"身份证号",@"银行卡号",@"客服电话",@"QQ官方群",@"关于我们",@"检测更新", nil];
    
}

//代理方法
#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyaccountnumberCell";
    MyaccountnumberCell *cell = (MyaccountnumberCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ MyaccountnumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    cell.leftimageview.image=[UIImage imageNamed:@"img_account_head"];

    cell.leftlable.text=self.leftDataArr[indexPath.row];
    
    cell.rightlable.text=self.leftDataArr[indexPath.row];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 70;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 70)];
   
    
    UIButton*baocunBTN=[[UIButton alloc] initWithFrame:CGRectMake(30, 10, kScreenWidth-60,40)];
    baocunBTN.backgroundColor=[UIColor orangeColor];
    
    [baocunBTN setTitle:@"退出账号" forState:UIControlStateNormal];
    [baocunBTN addTarget:self action:@selector(onbaocunBTN) forControlEvents:UIControlEventTouchUpInside];
    
    [baocunBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [baocunBTN setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];

    [myView addSubview:baocunBTN];
    
    return myView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - event response

#pragma mark - private method

//退出账号
- (void)onbaocunBTN {
    
    UnLoginHomePageViewController *unLoginHomePageVC = [[UnLoginHomePageViewController alloc] init];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:[[UINavigationController alloc] initWithRootViewController:unLoginHomePageVC]];
    
    [Tool clearUserInfo];
    
}

//修改密码
-(void)onchangeBtn{
    
}

-(void)onxiangxiBtn{
    
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getters and setters

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight) style:UITableViewStylePlain];
        
        _headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        
        
        
        UIView*topview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        
        UIImageView*topimageview=[[UIImageView alloc] initWithFrame:CGRectMake(6, 15, 40, 40)];
        topimageview.image=[UIImage imageNamed:@"img_account_head"];
        
        
        [topview addSubview:topimageview];
        
        _nameLable=[[UILabel alloc] initWithFrame:CGRectMake(topimageview.frame.size.width+15, 15, 140, 20)];
        _nameLable.text=@"1234567890";
        
        [topview addSubview:_nameLable];
        
        
        _priceLable=[[UILabel alloc] initWithFrame:CGRectMake(topimageview.frame.size.width+15, 35, 140, 30)];
        _priceLable.text=@"余额:00";
        _priceLable.textColor=[UIColor redColor];
        
        
        [topview addSubview:_priceLable];
        
        //修改密码
        UIButton*changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100, 25, 80, 25)];
        
        [changeBtn setTitle:@"修改密码" forState:UIControlStateNormal];
        changeBtn.imageView.frame =changeBtn.bounds;
        changeBtn.hidden = NO;
        
        [changeBtn addTarget:self action:@selector(onchangeBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        changeBtn.imageView.backgroundColor=[UIColor redColor];
        [topview addSubview:changeBtn];
        changeBtn.backgroundColor=[UIColor grayColor];
        
        
        [_headview addSubview:topview];
        
        
        
        
        UIImageView*downview=[[UIImageView alloc] initWithFrame:CGRectMake(0, topview.frame.size.height, kScreenWidth, 120)];
        
        downview.image=[UIImage imageNamed:@"bg_account_asset_info"];
        downview.userInteractionEnabled=YES;
        
        
        
        
        //详细介绍
        UIButton*xiangxiBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80, 60, 30, 30)];
        
        [xiangxiBtn setTitle:@" ？" forState:UIControlStateNormal];
        
        
        xiangxiBtn.userInteractionEnabled=YES;
        [xiangxiBtn addTarget:self action:@selector(onxiangxiBtn) forControlEvents:UIControlEventTouchUpInside];
        xiangxiBtn.backgroundColor=[UIColor blackColor];
        [downview addSubview:xiangxiBtn];
        changeBtn.backgroundColor=[UIColor grayColor];
        
        
        
        
        [_headview addSubview:downview];
        
        
        _contentTableView.tableHeaderView=_headview;
        
        UIView*footview=[[UIView alloc] init];
        _contentTableView.tableFooterView=footview;
        footview.backgroundColor=[UIColor whiteColor];
        
        
        
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
}


@end
