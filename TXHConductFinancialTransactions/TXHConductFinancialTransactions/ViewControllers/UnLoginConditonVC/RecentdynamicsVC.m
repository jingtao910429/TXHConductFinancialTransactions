//
//  RecentdynamicsVC.m
//  TXHConductFinancialTransactions
//
//  Created by 吴建良 on 15/11/5.
//  Copyright © 2015年 rongyu. All rights reserved.
//

#import "RecentdynamicsVC.h"

#import "RecentdynamicsCell.h"

@interface RecentdynamicsVC ()<UITableViewDelegate,UITableViewDataSource>

{
 UITableView         *_lefttableView;

  
}
@end
@implementation RecentdynamicsVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearNavigationBar];
    
    
    [self navigationBarStyleWithTitle:@"最近动态" titleColor:[UIColor blackColor]  leftTitle:@"返回" leftImageName:nil leftAction:nil rightTitle:nil rightImageName:nil rightAction:nil];
    [self configUI];
}
#pragma mark - 配置视图
- (void)configUI{
    _lefttableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _lefttableView.delegate = self;
    _lefttableView.dataSource = self;
       _lefttableView.rowHeight = 160;
     _lefttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_lefttableView];
    
  }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentdynamicsCell";
    RecentdynamicsCell *cell = (RecentdynamicsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        cell = [[ RecentdynamicsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       
        
    }
    
   
    
    cell.backgroundColor=BackColor;
    cell.bgimageview.image=[UIImage imageNamed:@"bg1"];
    
   cell.textlable.text=@"小武，不要每天太晚休息啊，身体也是重要的";
    
    
    
    
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}


@end
