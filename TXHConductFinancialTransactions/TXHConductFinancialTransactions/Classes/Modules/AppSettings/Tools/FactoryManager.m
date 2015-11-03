//
//  FactoryManager.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/3.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "FactoryManager.h"

static FactoryManager *shareManager = nil;

@implementation FactoryManager

+ (instancetype)shareManager {
    
    static dispatch_once_t onceInstance;
    dispatch_once(&onceInstance, ^{
        shareManager = [[FactoryManager alloc] init];
    });
    return shareManager;
}

- (UIButton *)createBtnWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor {
    
    UIButton *button                = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame                    = frame;
    button.titleLabel.text          = text;
    button.titleLabel.textColor     = textColor;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    return button;
}

@end
