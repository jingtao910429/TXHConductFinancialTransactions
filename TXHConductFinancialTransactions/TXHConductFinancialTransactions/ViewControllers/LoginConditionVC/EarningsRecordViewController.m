//
//  EarningsRecordViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/7.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "EarningsRecordViewController.h"
#import "EarnDetailAPICmd.h"
#import "MJRefresh.h"
#import "NSString+Additions.h"
#import "LCLineChartView.h"
#import "EarnDetailModel.h"

#define SECS_PER_DAY (86400)

@interface EarningsRecordViewController () <UITableViewDataSource,UITableViewDelegate,APICmdApiCallBackDelegate>

@property (nonatomic, strong) EarnDetailAPICmd *earnDetailAPICmd;

@property (nonatomic, strong) UITableView     *contentTableView;
@property (nonatomic,retain)  UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) EarnDetailModel *earnDetailModel;

//分页
@property (nonatomic, assign) NSInteger index;

//顶部视图
@property (nonatomic, strong) LCLineChartView *chartView;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation EarningsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configData {
    
    self.index = 1;
    self.dataSource = [[NSMutableArray alloc] init];
    [self.earnDetailAPICmd loadData];
}

- (void)configUI {
    
    [self navigationBarStyleWithTitle:@"收益记录" titleColor:[UIColor blackColor]  leftTitle:nil leftImageName:@"back" leftAction:@selector(popVC) rightTitle:nil rightImageName:nil rightAction:nil];
    
    [self.view addSubview:self.contentTableView];
    
    [self.contentTableView addSubview:self.refreshControl];
    
    //上拉加载
    self.contentTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pollUpReloadData)];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.chartView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_ID"];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 155, 5, 135, 40)];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.tag = 12345;
        [cell.contentView addSubview:contentLabel];
        
    }
    
    EarnDetailModel *model = self.dataSource[indexPath.row];
    
    NSArray *arrs = [model.createDate componentsSeparatedByString:@"+"];
    
    NSString *createTime = [NSString stringWithFormat:@"%@ %@",arrs[0],arrs[1]];
    
    cell.textLabel.text = createTime;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *contentLabel = (UILabel *)[cell.contentView viewWithTag:12345];
    contentLabel.text = [NSString stringWithFormat:@"%.2f",[model.rate floatValue]/100.00];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - APICmdApiCallBackDelegate

- (void)apiCmdDidSuccess:(RYBaseAPICmd *)baseAPICmd responseData:(id)responseData {
    
    if (baseAPICmd ==self.earnDetailAPICmd) {
        
        NSDictionary *tempDict = (NSDictionary *)responseData;
        
        if ([tempDict[@"result"] intValue] != LoginTypeSuccess) {
            
            [Tool ToastNotification:tempDict[@"msg"]];
            
        }else{
            
            NSArray *data = tempDict[@"data"];
            
            if (data && ![data isKindOfClass:[NSNull class]] && data.count != 0) {
                
                if (1 == self.index) {
                    self.dataSource = [[NSMutableArray alloc] initWithCapacity:20];
                }
                
                for (NSDictionary *subDict in data) {
                    
                    EarnDetailModel *model = [[EarnDetailModel alloc] init];
                    [model setValuesForKeysWithDictionary:subDict];
                    [self.dataSource addObject:model];
                }
                
                [self.dataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    
                    EarnDetailModel *modelObject1 = (EarnDetailModel *)obj1;
                    EarnDetailModel *modelObject2 = (EarnDetailModel *)obj2;
                    
                    return [modelObject1.createDate compare:modelObject2.createDate];
                    
                }];
                
                [self.contentTableView reloadData];
            }else{
                [Tool ToastNotification:@"没有更多内容"];
            }
            
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
    [self.earnDetailAPICmd loadData];
    
}

- (void)pollUpReloadData {
    
    self.index ++;
    [self.earnDetailAPICmd loadData];
    
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getters and setters

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.showsVerticalScrollIndicator = NO;
    }
    return _contentTableView;
}

- (UIRefreshControl *)refreshControl {
    
    if (!_refreshControl) {
        
        _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.contentTableView.frame.size.width, -40)];
        [_refreshControl addTarget:self action:@selector(reload:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (LCLineChartView *)chartView {
    
    if (self.dataSource.count == 0) {
        return _chartView;
    }
    
    {
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"yyyyMMMd" options:0 locale:[NSLocale currentLocale]]];
    }
    
    // first sample chart view:
    {
        LCLineChartData *d1x = ({
            LCLineChartData *d1 = [LCLineChartData new];
            
            [self.dataSource sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                EarnDetailModel *modelObject1 = (EarnDetailModel *)obj1;
                EarnDetailModel *modelObject2 = (EarnDetailModel *)obj2;
                
                return [modelObject1.createDate compare:modelObject2.createDate];
                
            }];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            EarnDetailModel *firstModel = self.dataSource[0];
            NSArray *firstTimesArr = [firstModel.createDate componentsSeparatedByString:@"+"];
            NSString *firstTime = [NSString stringWithFormat:@"%@ %@",firstTimesArr[0],firstTimesArr[1]];
            
            if (self.dataSource.count > 2) {
                
                EarnDetailModel *lastModel = self.dataSource[self.dataSource.count - 1];
                NSArray *lastTimesArr = [lastModel.createDate componentsSeparatedByString:@"+"];
                NSString *lastTime = [NSString stringWithFormat:@"%@ %@",lastTimesArr[0],lastTimesArr[1]];
                
                d1.xMin = [[formatter dateFromString:firstTime] timeIntervalSince1970];
                d1.xMax = [[formatter dateFromString:lastTime] timeIntervalSince1970];
                
            }else if (self.dataSource.count == 1){
                
                EarnDetailModel *firstModel = self.dataSource[0];
                NSArray *firstTimesArr = [firstModel.createDate componentsSeparatedByString:@"+"];
                NSString *firstTime = [NSString stringWithFormat:@"%@ %@",firstTimesArr[0],firstTimesArr[1]];
                
                d1.xMin = [[formatter dateFromString:firstTime] timeIntervalSince1970];
                d1.xMax = [[formatter dateFromString:firstTime] timeIntervalSince1970];
                
            }else{
                d1.xMin = 0;
                d1.xMax = 0;
            }
            
            
            d1.title = @"收益记录";
            d1.color = [UIColor whiteColor];
            
            d1.itemCount = self.dataSource.count;
            NSMutableArray *arr = [NSMutableArray array];
            
            for(NSUInteger i = 0; i < self.dataSource.count; ++i) {
                
                EarnDetailModel *earnDetailModel = (EarnDetailModel *)self.dataSource[i];
                NSArray *timesArr = [earnDetailModel.createDate componentsSeparatedByString:@"+"];
                NSString *timeStr = [NSString stringWithFormat:@"%@ %@",timesArr[0],timesArr[1]];
                
                [arr addObject:@([[formatter dateFromString:timeStr] timeIntervalSince1970])];
            }
            NSMutableArray *arr2 = [NSMutableArray array];
            for(NSUInteger i = 0; i < self.dataSource.count; ++i) {
                
                EarnDetailModel *earnDetailModel = (EarnDetailModel *)self.dataSource[i];
                [arr2 addObject:@([earnDetailModel.rate floatValue])];
            }
            d1.getData = ^(NSUInteger item) {
                
                float x = [arr[item] floatValue];
                
                float y = [arr2[item] floatValue];
                NSString *label1 = [formatter stringFromDate:[[formatter dateFromString:firstTime] dateByAddingTimeInterval:0]];
                NSString *label2 = [NSString stringWithFormat:@"%f", y];
                
                NSString *timeStr = [label1 componentsSeparatedByString:@" "][0];
                NSArray *times = [timeStr componentsSeparatedByString:@"-"];
                timeStr = [NSString stringWithFormat:@"%@-%@",times[1],times[2]];
                
                return [LCLineChartDataItem dataItemWithX:x y:y xLabel:timeStr dataLabel:label2];
            };
            
            d1;
        });
        
        _chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 220)];
        _chartView.yMin = 6;
        _chartView.yMax = 16;
        _chartView.ySteps = @[@"6.00%",@"8.00%",@"10.00%",@"12.00%",@"14.00%",@"16.00%"];
        _chartView.data = @[d1x];
        _chartView.selectedItemCallback = ^(LCLineChartData *dat, NSUInteger item, CGPoint pos) {
            if(dat == d1x && item == 2) {
                NSLog(@"User selected item 1 in 1st graph at position %@ in the graph view", NSStringFromCGPoint(pos));
            }
        };
        
    }
    return _chartView;
    
}

- (EarnDetailAPICmd *)earnDetailAPICmd {
    if (!_earnDetailAPICmd) {
        _earnDetailAPICmd = [[EarnDetailAPICmd alloc] init];
        _earnDetailAPICmd.delegate = self;
        _earnDetailAPICmd.path = API_product;
    }
    
    _earnDetailAPICmd.reformParams = @{@"id":[Tool getUserInfo][@"id"],@"pageNum":[NSString stringWithFormat:@"%d",(int)self.index]};
    return _earnDetailAPICmd;
}

@end
