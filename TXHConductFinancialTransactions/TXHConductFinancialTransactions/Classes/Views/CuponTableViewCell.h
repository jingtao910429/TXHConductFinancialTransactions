//
//  CuponTableViewCell.h
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/12.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *takeLabel;
@property (weak, nonatomic) IBOutlet UILabel *restDayLabel;

@end
