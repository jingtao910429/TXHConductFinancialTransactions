//
//  EarningsRecordViewController.m
//  TXHConductFinancialTransactions
//
//  Created by wwt on 15/11/7.
//  Copyright (c) 2015年 rongyu. All rights reserved.
//

#import "EarningsRecordViewController.h"
#import "EarnDetailAPICmd.h"

@interface EarningsRecordViewController () <APICmdApiCallBackDelegate>

@property (nonatomic, strong) EarnDetailAPICmd *earnDetailAPICmd;

@end

@implementation EarningsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - life cycle


#pragma mark - UITableViewDelegate

#pragma mark - APICmdApiCallBackDelegate

- (void)apiCmdDidSuccess:(RYBaseAPICmd *)baseAPICmd responseData:(id)responseData {
    
}

- (void)apiCmdDidFailed:(RYBaseAPICmd *)baseAPICmd error:(NSError *)error {
    
}

#pragma mark - event response
#pragma mark - private method
#pragma mark - getters and setters

- (EarnDetailAPICmd *)earnDetailAPICmd {
    if (!_earnDetailAPICmd) {
        _earnDetailAPICmd = [[EarnDetailAPICmd alloc] init];
        _earnDetailAPICmd.delegate = self;
        _earnDetailAPICmd.path = API_product;
    }
    
//    _earnDetailAPICmd.reformParams = @{@"pageNum":[NSString stringWithFormat:@"%d",(int)self.index]};
    return _earnDetailAPICmd;
}

@end
