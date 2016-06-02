//
//  AFNtool.m
//  YLT
//
//  Created by Chaungciy on 16/4/23.
//  Copyright © 2016年 Chaungciy. All rights reserved.
//

#import "AFNtool.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation AFNtool

+(void)JSwithUrl:(NSString *)url sucess:(void (^)(id obj))success faile:(void (^)(id obj))failure{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //NSDictionary *parame = @{@"where":@"IsAudit=1 and ISValid=1 and DCode='410104'"};
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    //get请求不需要这句代码
    //manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manger GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *result =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *phone = [result stringByReplacingOccurrencesOfString : @"\r\n" withString : @""];
        NSData *data = [phone dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        success(dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+(BOOL)isNetworkLinked{
   __block  BOOL  stat = YES;
    
  
    return stat;
}



@end
