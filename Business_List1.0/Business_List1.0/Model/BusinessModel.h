//
//  BusinessModel.h
//  YLT-Business
//
//  Created by 冀柳冲 on 16/4/26.
//  Copyright © 2016年 冀柳冲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessModel : NSObject<NSCoding>
/**
 *  通讯地址
 */
@property(nonatomic,strong) NSString * Address;
//@property(nonatomic,strong) NSString * Bank;//银行
//@property(nonatomic,strong) NSString * BankCard;//银行卡号
/**
 *  城市
 */
@property(nonatomic,strong) NSString * City;
/**
 *  所在城区
 */
@property(nonatomic,strong) NSString * District;
/**
 *  GID
 */
@property(nonatomic,assign) NSInteger  GID;
/**
 *  ID
 */
@property(nonatomic,assign) NSString * ID;//ID
/**
 *  联系方式
 */
@property(nonatomic,strong) NSString * Phone;
/**
 *  商家名称
 */
@property(nonatomic,strong) NSString * SName;
/**
 *  商家门牌号
 */
@property(nonatomic,strong) NSString * SNo;
/**
 *  排序号
 */
@property(nonatomic,assign) NSInteger  SortID;

/**
 *  商家用户登录名
 */
@property(nonatomic,strong) NSString * userID;





@end
