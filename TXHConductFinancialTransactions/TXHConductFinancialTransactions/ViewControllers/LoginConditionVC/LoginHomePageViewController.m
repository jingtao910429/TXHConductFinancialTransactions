//
//  LoginHomePageViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/3.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "LoginHomePageViewController.h"
#import "BMAdScrollView.h"

@interface LoginHomePageViewController () <ValueClickDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView        *contentTableView;

@property (nonatomic, strong) UIView             *topBackGroudView;
@property (nonatomic, strong) BMAdScrollView     *bmadScrollView;
@property (nonatomic, strong) UIImageView        *unloginImgView;

//底部button （立即投资）
@property (nonatomic, strong) UIButton           *bottomButton;

@property (nonatomic, strong)   NSMutableArray     *images;

@end

@implementation LoginHomePageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configData {
    
    self.images = [[NSMutableArray alloc] initWithObjects:@"bg1",@"bg1",@"bg1", nil];
    
}

- (void)configUI {
    
    [self navigationBarStyleWithTitle:@"首页" titleColor:[UIColor blackColor]  leftTitle:nil leftImageName:@"img_account_head" leftAction:nil rightTitle:nil rightImageName:nil rightAction:nil];
    
    [self.view addSubview:self.contentTableView];
    [self.view addSubview:self.bottomButton];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.3*self.view.frame.size.height + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    [self.topBackGroudView addSubview:self.unloginImgView];
    return self.topBackGroudView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"CELL_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}

#pragma mark - event response

//活动banner点击事件
-(void)buttonClick:(int)vid {
    
}

#pragma mark - private method

#pragma mark - getters and setters

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64) style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
    }
    return _contentTableView;
}

- (BMAdScrollView *)bmadScrollView {
    
    if (!_bmadScrollView) {
        
        _bmadScrollView = [[BMAdScrollView alloc] initWithNameArr:self.images height:self.topBackGroudView.frame.size.height offsetY:0];
        _bmadScrollView.vDelegate = self;
        _bmadScrollView.pageCenter = CGPointMake(kScreenWidth - 30, self.topBackGroudView.frame.size.height - 30);
        
    }
    return _bmadScrollView;
}

- (UIView *)topBackGroudView
{
    if (!_topBackGroudView) {
        _topBackGroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.3*self.view.frame.size.height + 20)];
    }
    return _topBackGroudView;
}

- (UIImageView *)unloginImgView {
    if (!_unloginImgView) {
        UIImage *image = [UIImage imageNamed:@"topBanner"];
        _unloginImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.topBackGroudView.frame.size.width, self.topBackGroudView.frame.size.height)];
        _unloginImgView.image = image;
    }
    return _unloginImgView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(0, self.view.frame.size.height - 50 - 64, kScreenWidth, 50);
        [_bottomButton setTitle:@"立即投资" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _bottomButton.backgroundColor = COLOR(239, 71, 26, 1.0);
        
    }
    return _bottomButton;
}

@end
