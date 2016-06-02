//
//  BusinessTableViewCell.h
//  Business_List
//
//  Created by 冀柳冲 on 16/6/1.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessModel.h"

@interface BusinessTableViewCell : UITableViewCell



/**
 *  用于赋值
 */
@property(nonatomic,strong)BusinessModel * model;

/**
 *  左边的label
 */
@property(nonatomic,strong) UILabel * nameLabel;
@property(nonatomic,strong) UILabel * numberLabel;


/**
 *  商家名称
 */
@property(nonatomic,strong) UILabel * nameInfo;
/**
 *  门牌号
 */
@property(nonatomic,strong) UILabel * numberInfo;



@end
