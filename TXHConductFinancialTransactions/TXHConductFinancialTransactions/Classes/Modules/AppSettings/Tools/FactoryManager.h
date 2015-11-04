//
//  FactoryManager.h
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/3.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import <Foundation/Foundation.h>

//工厂类
@interface FactoryManager : NSObject

+ (instancetype)shareManager;

//需要其他属性对应扩展
- (UIButton *)createBtnWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor;

- (UIView *)createCellViewWithFrame:(CGRect)frame imageName:(NSString *)imageName placeHolder:(NSString *)placeHoder imageTag:(NSInteger)imageTag textFiledTag:(NSInteger)textFiledTag cellHeight:(NSInteger)cellHeight target:(id)target isNeedImage:(BOOL)isNeedImage;

@end
