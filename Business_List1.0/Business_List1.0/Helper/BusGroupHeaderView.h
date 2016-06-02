//
//  BusGroupHeaderView.h
//  Business_List1.0
//
//  Created by 冀柳冲 on 16/6/2.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessGroupModel.h"

@class BusGroupHeaderView;
/**
 *  协议/代理
 */
@protocol BusGroupHeaderViewDelegate <NSObject>

- (void)busGroupViewDidClickBtn:(BusGroupHeaderView*)headerView;


@end


@interface BusGroupHeaderView : UITableViewHeaderFooterView

/**
 *  代理
 */
@property(nonatomic,assign) id<BusGroupHeaderViewDelegate>  delegate;

+ (instancetype)busGroupHeaderViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BusinessGroupModel *groupModel;

@end
