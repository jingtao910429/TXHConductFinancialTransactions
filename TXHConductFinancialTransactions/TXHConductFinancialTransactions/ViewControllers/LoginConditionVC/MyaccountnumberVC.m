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
#import "NSString+Additions.h"
#import "HelpCenterVC.h"
#import "RegisterViewController.h"
#import "TelPrompt.h"

@interface MyaccountnumberVC () <UITableViewDataSource,UITableViewDelegate,APICmdApiCallBackDelegate>


@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) UIView*headview;
@property (nonatomic, strong) NSArray *leftDataArr;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UILabel*nameLable;//账号名字

@property (nonatomic, strong) UILabel*priceLable;//余额

//网络请求
@property (nonatomic, strong) UserInfoAPICmd *userInfoAPICmd;
@property (nonatomic, strong) UserInfoModel *userInfoModel;

@property (nonatomic, strong) UILabel*shouyiLable;//收益
@property (nonatomic, strong) UILabel*lastDayiLable;//昨日收益


@end

@implementation MyaccountnumberVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self.userInfoAPICmd loadData];
}

-(void)configUI{    
    
    [self navigationBarStyleWithTitle:@"我的账号" titleColor:[UIColor blackColor]  leftTitle:@"返回" leftImageName:nil leftAction:@selector(popVC) rightTitle:nil rightImageName:nil rightAction:nil];
    //添加视图
    [self.view addSubview:self.contentTableView];
    
    self.leftDataArr=[[NSArray alloc] initWithObjects:@"身份证号",@"银行卡号",@"客服电话",@"QQ官方群",@"关于我们",@"检测更新", nil];
    self.dataSource = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"", nil];
}

//代理方法
#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.leftDataArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.row) {
        return 200;
    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MyaccountnumberCell";
    MyaccountnumberCell *cell = (MyaccountnumberCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[ MyaccountnumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    if (0 == indexPath.row) {
        
        [self.headview removeFromSuperview];
        
        [cell.contentView addSubview:self.headview];
    }
    
    if (4 != indexPath.row) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (0 != indexPath.row) {

        cell.leftimageview.image=[UIImage imageNamed:@"img_account_head"];
        
        cell.leftlable.text=self.leftDataArr[indexPath.row - 1];
        
        cell.rightlable.text = self.dataSource[indexPath.row - 1];
        
    }
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 70;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 70)];
   
    
    UIButton*baocunBTN=[[UIButton alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth-30,44)];
    baocunBTN.backgroundColor=[UIColor orangeColor];
    baocunBTN.layer.cornerRadius = 4;
    baocunBTN.layer.masksToBounds = YES;
    
    [baocunBTN setTitle:@"退出账号" forState:UIControlStateNormal];
    [baocunBTN addTarget:self action:@selector(onbaocunBTN) forControlEvents:UIControlEventTouchUpInside];
    
    [baocunBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [baocunBTN setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];

    [myView addSubview:baocunBTN];
    
    return myView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==5) {
        HelpCenterVC*vc=[[HelpCenterVC alloc] init];
        vc.isGTturl=NO;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    if (indexPath.row == 3) {
        
        [TelPrompt callPhoneNumber:self.userInfoModel.kfPhone call:^(NSTimeInterval duration) {
            
        } cancel:^{
            
        }];
        
//        UIWebView*callWebview =[[UIWebView alloc] init];
//        NSString *telUrl = [NSString stringWithFormat:@"tel://%@", self.userInfoModel.kfPhone?self.userInfoModel.kfPhone:@""];
//        NSURL *telURL =[NSURL URLWithString:telUrl];
//        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//        [self.view addSubview:callWebview];
    }
    
}

#pragma mark - APICmdApiCallBackDelegate

- (void)apiCmdDidSuccess:(RYBaseAPICmd *)baseAPICmd responseData:(id)responseData {
    
    if (baseAPICmd ==self.userInfoAPICmd) {
        
        NSDictionary *tempDict = (NSDictionary *)responseData;
        
        if ([tempDict[@"result"] intValue] != LoginTypeSuccess) {
            
            [Tool ToastNotification:tempDict[@"msg"]];
            
        }else{
            
            self.userInfoModel = [[UserInfoModel alloc] init];
            
            [self.userInfoModel setValuesForKeysWithDictionary:tempDict[@"data"]];
            
            self.dataSource = [[NSArray alloc] initWithObjects:self.userInfoModel.idCard?self.userInfoModel.idCard:@"",self.userInfoModel.bankCardNum?self.userInfoModel.bankCardNum:@"",self.userInfoModel.kfPhone?self.userInfoModel.kfPhone:@"",self.userInfoModel.idCard?self.userInfoModel.idCard:@"",@"",self.userInfoModel.appVersion?self.userInfoModel.appVersion:@"", nil];
            
            [self.contentTableView reloadData];
            
            
        }
    }
    
}

- (void)apiCmdDidFailed:(RYBaseAPICmd *)baseAPICmd error:(NSError *)error {
    [Tool ToastNotification:@"加载失败"];
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
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.isRestPassword = YES;
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

-(void)onxiangxiBtn{
    
    HelpCenterVC*vc=[[HelpCenterVC alloc] init];
    vc.isGTturl=YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - getters and setters

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight - 64) style:UITableViewStylePlain];
        
        UIView*footview=[[UIView alloc] init];
        _contentTableView.tableFooterView=footview;
        footview.backgroundColor=[UIColor whiteColor];
        
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
}

- (UserInfoAPICmd *)userInfoAPICmd {
    if (!_userInfoAPICmd) {
        _userInfoAPICmd = [[UserInfoAPICmd alloc] init];
        _userInfoAPICmd.delegate = self;
        _userInfoAPICmd.path = API_UserInfo;
    }
    _userInfoAPICmd.reformParams = @{@"id":[Tool getUserInfo][@"id"]};
    return _userInfoAPICmd;
}

- (UIView *)headview {
    
    _headview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _headview.backgroundColor = [UIColor whiteColor];
    
    UIView*topview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    
    UIImageView*topimageview=[[UIImageView alloc] initWithFrame:CGRectMake(6, 15, 40, 40)];
    topimageview.image=[UIImage imageNamed:@"img_account_head"];
    
    
    [topview addSubview:topimageview];
    
    _nameLable=[[UILabel alloc] initWithFrame:CGRectMake(topimageview.frame.size.width+15, 15, 140, 20)];
    _nameLable.text = self.userInfoModel.phoneNumber?self.userInfoModel.phoneNumber:@"";
    
    [topview addSubview:_nameLable];
    
    
    _priceLable=[[UILabel alloc] initWithFrame:CGRectMake(topimageview.frame.size.width+15, 35, 140, 30)];
    
    NSString *priceStr = [[NSString stringWithFormat:@"%@",self.userInfoModel.remainAsset?self.userInfoModel.remainAsset:@""] changeYFormatWithMoneyAmount];
    _priceLable.text = [NSString stringWithFormat:@"金额：%@",priceStr];
    _priceLable.textColor=[UIColor redColor];
    
    
    [topview addSubview:_priceLable];
    
    //修改密码
    UIButton*changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-100, 25, 80, 25)];
    
    [changeBtn setTitle:@"修改密码" forState:UIControlStateNormal];
    changeBtn.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,changeBtn.titleLabel.bounds.size.width);
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
    UIButton*xiangxiBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth * 4.0 / 5.0, 80, 20, 20)];
    
    [xiangxiBtn setTitle:@" ？" forState:UIControlStateNormal];
    xiangxiBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    xiangxiBtn.layer.cornerRadius = 10;
    xiangxiBtn.layer.borderWidth = 0.1;
    
    
    xiangxiBtn.userInteractionEnabled=YES;
    [xiangxiBtn addTarget:self action:@selector(onxiangxiBtn) forControlEvents:UIControlEventTouchUpInside];
    [xiangxiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    xiangxiBtn.backgroundColor=[UIColor whiteColor];
    [downview addSubview:xiangxiBtn];
    changeBtn.backgroundColor=[UIColor grayColor];
    
    
    
    
    UILabel*leijiLable=[[UILabel alloc] initWithFrame:CGRectMake(6, 5, 160, 30)];
    leijiLable.text=@"累计收益（元）";
    [downview addSubview:leijiLable];
    leijiLable.textColor=[UIColor whiteColor];
    
    _shouyiLable=[[UILabel alloc] initWithFrame:CGRectMake(6, leijiLable.frame.size.height, 160, 30)];
    
    
    
    NSString *shouyiLabletext = [NSString stringWithFormat :@"%@",self.userInfoModel.income?self.userInfoModel.income:@""];
    
    
    _shouyiLable.text=shouyiLabletext;
    
    _shouyiLable.textColor=[UIColor whiteColor];
    [downview addSubview:_shouyiLable];
    
    
    _lastDayiLable=[[UILabel alloc] initWithFrame:CGRectMake(6, _shouyiLable.frame.size.height+35, 160, 30)];
    
    
    NSString *lastDayiLableStr = [NSString stringWithFormat:@"昨日收益：%@",self.userInfoModel.yesterdayIncome?self.userInfoModel.yesterdayIncome:@""];
    
    
    _lastDayiLable.text=lastDayiLableStr;
    
    
    
    _lastDayiLable.textColor=[UIColor whiteColor];
    
    [downview addSubview:_lastDayiLable];
    
    [_headview addSubview:downview];
    
    return _headview;
}


@end
