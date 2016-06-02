//
//  BusinessTableViewCell.m
//  Business_List
//
//  Created by 冀柳冲 on 16/6/1.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import "BusinessTableViewCell.h"
#include "Masonry.h"


#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height/8

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation BusinessTableViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addCustomCell];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addCustomCell];
    }
    return self;
}




- (void)addCustomCell{
    self.backgroundColor = [UIColor clearColor];
    self.accessoryType = UITableViewCellStateShowingEditControlMask;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Kwidth, Kheight)];
    
    backView.backgroundColor = UIColorFromRGB(237943);
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, (Kheight-30)/2)];
    _numberLabel.font = [UIFont systemFontOfSize:12];
    _numberLabel.text = @"门牌号:";
    [self addSubview:backView];
    [backView addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, (Kheight-30)/2));
        make.left.equalTo(backView.mas_left).with.offset(10);
        make.top.equalTo(backView.mas_top).with.offset(15);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"商   家:";
    [backView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_numberLabel);
        make.centerX.equalTo(_numberLabel);
        make.top.equalTo(_numberLabel.mas_bottom).with.offset(10);
    }];
    
    _numberInfo = [[UILabel alloc]init];
    _numberInfo.textAlignment = NSTextAlignmentLeft;
    [_numberInfo setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [backView addSubview:_numberInfo];
    [_numberInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(Kwidth-60, (Kheight-30)/2));
        //与商家:水平对齐
        make.centerY.equalTo(_numberLabel);
        make.left.equalTo(_numberLabel.mas_rightMargin).with.offset(10);
        
    }];
    self.nameInfo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame)+10, CGRectGetMaxY(_numberLabel.frame)+10, Kwidth-60, (Kheight-30)/2)];
    self.nameInfo.textAlignment = NSTextAlignmentLeft;
    _nameInfo.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [backView addSubview:_nameInfo];
    [_nameInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_numberInfo);
        //与商家:水平对齐
        make.centerX.equalTo(_numberInfo);
        make.top.equalTo(_numberInfo.mas_bottom).with.offset(10);
    }];
    _nameInfo.text = @"名称测试";
    _numberInfo.text = @"门牌号测试";
}


-(void)setModel:(BusinessModel *)model{
    _model = model;
    _nameInfo.text = model.SName;
    _numberInfo.text = model.SNo;
}


@end
