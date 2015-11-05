//
//  RecentdynamicsCell.m
//  TXHConductFinancialTransactions
//
//  Created by 吴建良 on 15/11/5.
//  Copyright © 2015年 rongyu. All rights reserved.
//

#import "RecentdynamicsCell.h"

@implementation RecentdynamicsCell
@synthesize bgview,bgimageview,textlable;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        bgview=[[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth-20, 150)];
        bgview.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:bgview];
        
        
        
        
        
        bgimageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, bgview.frame.size.width-20 , 100)];
        
        
        [bgview addSubview:bgimageview];
        
      
        
        textlable=[[UILabel alloc] initWithFrame:CGRectMake(10, bgimageview.frame.size.height+15, bgview.frame.size.width-20, 32)];
        
  
        [bgview addSubview:textlable];
        
        
        
        
        
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}


@end
