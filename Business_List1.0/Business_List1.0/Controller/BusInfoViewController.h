//
//  BusInfoViewController.h
//  Business_List1.0
//
//  Created by 冀柳冲 on 16/6/2.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessModel.h"

@interface BusInfoViewController : UIViewController

@property(nonatomic,strong) BusinessModel * infoModel;
//根据ID获取该店铺所有的手机
@property(nonatomic,strong)NSMutableArray *PhoneArray;
/**
 *  界面传值
 */
@property(nonatomic,strong)NSString * userID;

@end
