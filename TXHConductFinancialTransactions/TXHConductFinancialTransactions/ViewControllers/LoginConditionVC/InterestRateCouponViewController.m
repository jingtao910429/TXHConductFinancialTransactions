//
//  InterestRateCouponViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/11.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "InterestRateCouponViewController.h"
#import "InterestRateCouponAPICmd.h"
#import "MJRefresh.h"
#import "NSString+Additions.h"
#import "InterestRateCouponModel.h"

@interface InterestRateCouponViewController () <UITableViewDataSource,UITableViewDelegate,APICmdApiCallBackDelegate>


@property (nonatomic, strong) UITableView     *contentTableView;
@property (nonatomic,retain) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) InterestRateCouponAPICmd *interestRateCouponAPICmd;

@property (nonatomic, strong) InterestRateCouponModel *interestRateCouponModel;

//分页
@property (nonatomic, assign) NSInteger index;

@end

@implementation InterestRateCouponViewController

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
    
    self.index = 1;
    self.dataSource = [[NSMutableArray alloc] init];
    [self.interestRateCouponAPICmd loadData];
}

- (void)configUI {
    
    [self navigationBarStyleWithTitle:@"加息体验卷" titleColor:[UIColor blackColor]  leftTitle:@"返回" leftImageName:nil leftAction:@selector(popVC) rightTitle:nil rightImageName:nil rightAction:nil];
    
    [self.view addSubview:self.contentTableView];
    
    [self.contentTableView addSubview:self.refreshControl];
    
    //上拉加载
    self.contentTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pollUpReloadData)];
    
}



#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (1 == indexPath.row % 2) {
        return 60;
    }
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_ID"];
        
    }
    
    cell.contentView.backgroundColor = COLOR(232, 232, 232, 1.0);
    
    return cell;
    
//    if (1 == indexPath.row % 2) {
//        
//        static NSString *cellID = @"DealDetailTableViewCellID";
//        
//        DealDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"DealDetailTableViewCell" owner:self options:nil] lastObject];
//            [cell updateUI];
//            cell.layer.cornerRadius = 4;
//            cell.layer.masksToBounds = YES;
//        }
//        
//        return cell;
//        
//        
//    }else{
//        
//        
//    }
//    
//    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - APICmdApiCallBackDelegate

- (void)apiCmdDidSuccess:(RYBaseAPICmd *)baseAPICmd responseData:(id)responseData {
    
    if (baseAPICmd ==self.interestRateCouponAPICmd) {
        
        NSDictionary *tempDict = (NSDictionary *)responseData;
        
        if ([tempDict[@"result"] intValue] != LoginTypeSuccess) {
            
            [Tool ToastNotification:tempDict[@"msg"]];
            
        }else{
            
//            NSArray *data = tempDict[@"data"];
//            
//            if (data && ![data isKindOfClass:[NSNull class]] && data.count != 0) {
//                
//                self.dataSource = [[NSMutableArray alloc] initWithCapacity:20];
//                
////                for (NSDictionary *subDict in data) {
////                    
////                    DealDetailModel *model = [[DealDetailModel alloc] init];
////                    [model setValuesForKeysWithDictionary:subDict];
////                    [self.dataSource addObject:model];
////                }
//                
//                [self.contentTableView reloadData];
//            }else{
//                [Tool ToastNotification:@"没有更多内容"];
//            }
            
        }
        
        [self.refreshControl endRefreshing];
        [self.contentTableView.footer endRefreshing];
    }
    
    
}

- (void)apiCmdDidFailed:(RYBaseAPICmd *)baseAPICmd error:(NSError *)error {
    [Tool ToastNotification:@"加载失败"];
}

#pragma mark - event response
#pragma mark - private method

//下拉刷新
- (void)reload:(__unused id)sender {
    
    self.index = 1;
    [self.interestRateCouponAPICmd loadData];
    
}

- (void)pollUpReloadData {
    
    self.index ++;
    [self.interestRateCouponAPICmd loadData];
    
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - getters and setters

- (InterestRateCouponAPICmd *)interestRateCouponAPICmd {
    if (!_interestRateCouponAPICmd) {
        _interestRateCouponAPICmd = [[InterestRateCouponAPICmd alloc] init];
        _interestRateCouponAPICmd.delegate = self;
        _interestRateCouponAPICmd.path = API_ActiveLog;
    }
    _interestRateCouponAPICmd.reformParams = @{@"id":[Tool getUserInfo][@"id"],@"pageNum":[NSString stringWithFormat:@"%d",(int)self.index]};
    return _interestRateCouponAPICmd;
}


@end
