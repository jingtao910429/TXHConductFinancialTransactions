//
//  UnLoginHomePageViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/3.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "UnLoginHomePageViewController.h"
#import "UIViewController+NavigationBarStyle.h"
#import "TestAPICmd.h"
#import "MyaccountnumberVC.h"


@interface UnLoginHomePageViewController () <APICmdApiCallBackDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentTableView;

//网络请求，需要继承RYBaseAPICmd并实现RYBaseAPICmdDelegate，说明接口请求类型和用途
@property (nonatomic, strong) TestAPICmd *testAPICmd;

@end

@implementation UnLoginHomePageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//代理方法
#pragma mark - UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - APICmdApiCallBackDelegate

//数据请求成功
- (void)apiCmdDidSuccess:(RYBaseAPICmd *)baseAPICmd responseData:(id)responseData {
    
}
//请求失败
- (void)apiCmdDidFailed:(RYBaseAPICmd *)baseAPICmd error:(NSError *)error {
    
}

#pragma mark - event response

//按钮点击事件
- (void)btnClick:(UIButton *)sender {
    
}

//通知方法
- (void)notifyMethod:(NSNotification *)notification {
    
}

//触摸事件
- (void)touchMethod {
    
}

#pragma mark - private method

//设置UI
- (void)configUI {
    
    [self clearNavigationBar];
    //测试

    [self navigationBarStyleWithTitle:@"某某理财" titleColor:[UIColor redColor]  leftTitle:@"返回" leftImageName:nil leftAction:nil rightTitle:nil rightImageName:nil rightAction:nil];
    
    //添加视图
    [self.view addSubview:self.contentTableView];
}


#pragma mark--测试我的账号
-(void)onleftAction{
 
    MyaccountnumberVC*vc=[[MyaccountnumberVC alloc] init];
    [self .navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - getters and setters

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
}

- (TestAPICmd *)testAPICmd {
    if (!_testAPICmd) {
        _testAPICmd = [[TestAPICmd alloc] init];
        _testAPICmd.delegate = self;
        _testAPICmd.reformParams = @{};
    }
    return _testAPICmd;
}


@end
