//
//  UIViewController+NavigationBarStyle.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/3.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "UIViewController+NavigationBarStyle.h"
#import "FactoryManager.h"

@implementation UIViewController (NavigationBarStyle)

- (void)navigationBarStyleWithTitle:(NSString *)titleStr titleColor:(UIColor *)titleColor leftTitle:(NSString *)leftTitle leftImageName:(NSString *)leftImageName leftAction:(SEL)leftAction rightTitle:(NSString *)rightTitle rightImageName:(NSString *)rightImageName rightAction:(SEL)rightAction{
    
    //设置标题
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100 ,100)];
    titleLabel.text = titleStr;
    titleLabel.textColor = titleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:FontName size:21];
    self.navigationItem.titleView = titleLabel;
    
    //设置左右button
    
    if (leftTitle && !leftImageName) {
        
        UIButton *leftBtn = [[FactoryManager shareManager] createBtnWithFrame:CGRectMake(0, 0, 50, 30) text:leftTitle textColor:[UIColor orangeColor]];
        [leftBtn addTarget:self action:leftAction forControlEvents:UIControlEventTouchUpInside];
        
        //如果左是纯文本
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
    }else if (!leftTitle && leftImageName){
        
        //如果左是纯图片
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:leftImageName] style:UIBarButtonItemStylePlain target:self action:leftAction];
        
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    }
    
    if (rightTitle && !rightImageName) {
        
        UIButton *rightBtn = [[FactoryManager shareManager] createBtnWithFrame:CGRectMake(0, 0, 40, 30) text:rightTitle textColor:[UIColor orangeColor]];
        [rightBtn addTarget:self action:rightAction forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        
    }else if (!rightTitle && rightImageName) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:rightImageName] style:UIBarButtonItemStylePlain target:self action:rightAction];
        
    }else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    }
    
}

- (void)clearNavigationBar {
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    //navigationController与navigationBar之间的横线置空
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

@end
