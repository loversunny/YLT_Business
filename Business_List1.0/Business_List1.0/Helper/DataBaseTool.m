//
//  DataBaseTool.m
//  YLT-Business
//
//  Created by 冀柳冲 on 16/4/28.
//  Copyright © 2016年 冀柳冲. All rights reserved.
//

#import "DataBaseTool.h"

@implementation DataBaseTool

+(DataBaseTool *)shareDBTool{
    static DataBaseTool *dbTool = nil;
    //GCD创建单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbTool = [[DataBaseTool alloc]init];
    });
    return dbTool;
}

+(FMDatabaseQueue *)shareQueue{
    static FMDatabaseQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = filePath.lastObject;
        NSLog(@"%@",documentPath);
        NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"business.sqlite"];
        
        queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    });
    return queue;
}

- (BOOL)isTableOK:(NSString *)tableName
{
    FMDatabaseQueue *queue = [DataBaseTool shareQueue];
   __block int count;
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", @"businessInfo"];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            count = [rs intForColumn:@"count"];
            NSLog(@"isTableOK %d", count);
        }
    }];
    
    if (count == 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
    return NO;
}



//创建表
-(void)creatTable{

    FMDatabaseQueue *queue = [DataBaseTool shareQueue];
    [queue inDatabase:^(FMDatabase *db) {
        //为数据库设置缓存，提高查询效率
        [db setShouldCacheStatements:YES];
        BOOL result = [db tableExists:@"businessInfo"];
        if(result == YES){
            //用来清除表格
            BOOL resul = [db executeUpdate:@"drop table businessInfo"];;
            if(resul == YES){
                NSLog(@"create table success");
               [db executeUpdate:@"create table if not exists businessInfo(UserID text primary key,SName text,SNo text,City text,District text,Address text,Phone text,data BLOB)"];
            }else{
                
            }
        }else{
            BOOL resul = [db executeUpdate:@"create table if not exists businessInfo(UserID text primary key,SName text,SNo text,City text,District text,Address text,Phone text,data BLOB)"];
            if (resul) {
                NSLog(@"create table success");
            }else{
                NSLog(@"create table error");
            }
        }
    }
     ];
}

- (void)insertBusinessInfoArray:(NSArray *)infoArray Block:(void(^)(NSString * result))block{
    
    FMDatabaseQueue *queue = [DataBaseTool shareQueue];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db setShouldCacheStatements:YES];
            for (BusinessModel *model in infoArray) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                [db executeUpdate:@"insert into businessInfo(UserID,SName,SNo,City,District,Address,Phone,data) values(?,?,?,?,?,?,?,?)",model.userID,model.SName,model.SNo,model.City,model.District,model.Address,model.Phone,data];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *success = @"加载完毕";
            block(success);
        });
        
    });
    
    
}




-(void)insertBusinessInfo:(BusinessModel *)model{
    FMDatabaseQueue *queue = [DataBaseTool shareQueue];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [queue inDatabase:^(FMDatabase *db) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            [db executeUpdate:@"insert into businessInfo(UserID,SName,SNo,City,District,Address,Phone,data) values(?,?,?,?,?,?,?,?)",model.userID,model.SName,model.SNo,model.City,model.District,model.Address,model.Phone,data];
        }];
    });
    
    
    
    
    
//    [self creatTable];
//
//       [queue inDatabase:^(FMDatabase *db) {
//           NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
//           
//           //判断数据是否存在,存在的话,就更新数据
//           FMResultSet *result = [db executeQuery:@"select * from businessInfo where UserID = ?",[NSString stringWithFormat:@"%@",model.userID]];
//          if([result next]){
//              //更新数据
//              [db executeUpdate:@"update businessInfo set SName = ?,SNo = ?,City = ?,District = ?,Address = ?,Phone = ?,data = ? where UserID = ?",model.SName,model.SNo,model.City,model.District,model.Address,model.Phone,data,model.userID];
//           
//          }else{
//              //插入数据
//              [db executeUpdate:@"insert into businessInfo(UserID,SName,SNo,City,District,Address,Phone,data) values(?,?,?,?,?,?,?,?)",model.userID,model.SName,model.SNo,model.City,model.District,model.Address,model.Phone,data];
//          }
//           //切记关闭
//           [result close];
//       }];

    
    
}

-(void)selectAllBusiness{
    _allDataArray = [[NSMutableArray alloc]init];
    FMDatabaseQueue *queue = [DataBaseTool shareQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"select *from businessInfo"];
        while ([result next]) {
            NSData *data = [result dataForColumn:@"data"];
            BusinessModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_allDataArray addObject:model];
        }
    }];

}


-(void)searchCurrentBusinessWithUserID:(NSString *)userID {
    FMDatabaseQueue *queue = [DataBaseTool shareQueue];
    [queue inDatabase:^(FMDatabase *db) {
        _infoArray = [NSMutableArray array];
        FMResultSet *res = [db executeQuery:@"select * from businessInfo where userID = '?'",userID];
        if([res next]) {
            NSData *data = [res dataForColumn:@"data"];
            BusinessModel * model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_infoArray addObject:model];
        }else{
            NSLog(@"%@",res);
        }
    }];
}

@end
