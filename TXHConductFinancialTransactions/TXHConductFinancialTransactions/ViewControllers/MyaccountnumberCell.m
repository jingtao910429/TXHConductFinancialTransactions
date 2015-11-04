//
//  MyaccountnumberCell.m
//  TXHConductFinancialTransactions
//
//  Created by 吴建良 on 15/11/4.
//  Copyright © 2015年 rongyu. All rights reserved.
//

#import "MyaccountnumberCell.h"

@implementation MyaccountnumberCell
@synthesize leftimageview,leftlable,rightlable;


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        textLabel=[[UILabel alloc] initWithFrame:CGRectMake(25, 10, screenWidth/2, 30)];
//        textLabel.textColor=[UIColor blackColor];
//        //        textLabel.backgroundColor=[UIColor redColor];
//        [self addSubview:textLabel];
        
        leftimageview=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self.contentView addSubview:leftimageview];
        
       
        
        
        leftlable=[[UILabel alloc] initWithFrame:CGRectMake(leftimageview.frame.size.width+8, 5, 160, 30)];
        
        [self.contentView addSubview:leftlable];
        
        rightlable=[[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140, 5, 135, 30)];
        
        rightlable.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:rightlable];
        
        
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
    // Configure the view for the selected state
}


@end
