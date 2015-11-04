//
//  UnLoginHomePageViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/3.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "UnLoginHomePageViewController.h"
#import "UIViewController+NavigationBarStyle.h"


@interface UnLoginHomePageViewController ()

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

#pragma mark - UITableViewDelegate
#pragma mark - event response
#pragma mark - private method

//设置UI
- (void)configUI {
    
    [self clearNavigationBar];
    //测试
    [self navigationBarStyleWithTitle:@"某某理财" titleColor:[UIColor blackColor]  leftTitle:@"ceshi" leftImageName:nil leftAction:nil rightTitle:nil rightImageName:nil rightAction:nil];
    
}

#pragma mark - getters and setters

@end
