//
//  BusinessGroupModel.h
//  Business_List1.0
//  商家列表模型
//  Created by 冀柳冲 on 16/6/2.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BusinessGroupModel : NSObject

/**
 *  分组名称
 */
@property(nonatomic,strong) NSString * name;

/**
 *  分组数组
 */
@property(nonatomic,strong) NSArray * businesses;
/**
 *  是否展开列表 默认不展开
 */
@property(nonatomic,assign,getter=isExpend) BOOL  expend;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

+(instancetype)businessModelWithDictionary:(NSDictionary *)dic;

//+ (NSArray *)businessGroupList;




@end
