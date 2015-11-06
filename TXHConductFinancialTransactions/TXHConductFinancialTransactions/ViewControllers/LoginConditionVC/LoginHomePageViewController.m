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

@property (nonatomic, copy)   NSMutableArray     *images;

@end

@implementation LoginHomePageViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI {
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.3*self.view.frame.size.height + 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

#pragma mark - event response

//活动banner点击事件
-(void)buttonClick:(int)vid {
    
}

#pragma mark - private method

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

- (BMAdScrollView *)bmadScrollView {
    
    if (!_bmadScrollView) {
        
        _bmadScrollView = [[BMAdScrollView alloc] initWithNameArr:self.images height:self.topBackGroudView.frame.size.height offsetY:0];
        _bmadScrollView.vDelegate = self;
        _bmadScrollView.pageCenter = CGPointMake(kScreenWidth - 30, self.topBackGroudView.frame.size.height - 30);
        [self.topBackGroudView addSubview:self.bmadScrollView];
        
    }
    return _bmadScrollView;
}

- (UIView *)topBackGroudView
{
    if (!_topBackGroudView) {
        _topBackGroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.3*self.view.frame.size.height + 20)];
        UIImage *image = [UIImage imageNamed:@"topBanner"];
        self.unloginImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.topBackGroudView.frame.size.width, self.topBackGroudView.frame.size.height)];
        self.unloginImgView.image = image;
        [_topBackGroudView addSubview:self.unloginImgView];
    }
    return _topBackGroudView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.frame = CGRectMake(0, self.view.frame.size.height - 50, kScreenWidth, 50);
        [_bottomButton setTitle:@"立即投资" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:COLOR(239, 71, 26, 1.0) forState:UIControlStateNormal];
        
    }
    return _bottomButton;
}

@end
