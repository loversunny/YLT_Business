//
//  DataBaseTool.h
//  YLT-Business
//
//  Created by 冀柳冲 on 16/4/28.
//  Copyright © 2016年 冀柳冲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "BusinessModel.h"
@interface DataBaseTool : NSObject

//对外提供全部model类型的接口
@property(nonatomic,strong) NSMutableArray * allDataArray;

@property(nonatomic,strong) DataBaseTool * dbTool;
@property(nonatomic,strong) FMDatabaseQueue * queue;

@property(nonatomic,strong) BusinessModel  * resultModel;

@property(nonatomic,strong)NSMutableArray * infoArray;


+(DataBaseTool *)shareDBTool;

+(FMDatabaseQueue *)shareQueue;

-(void)creatTable;

/**
 *  接口提供
 *  根据当前用户的登录名来获取对应的model,展示商家信息
 */
-(void)searchCurrentBusinessWithUserID:(NSString *)userID;


//获取全部的数据
-(void)selectAllBusiness;

//添加商家的model
-(void)insertBusinessInfo:(BusinessModel *)model;
//判断表是否存在
- (BOOL) isTableOK:(NSString *)tableName;
//传进来数组
- (void)insertBusinessInfoArray:(NSArray *)infoArray Block:(void(^)(NSString * result))block;

@end
