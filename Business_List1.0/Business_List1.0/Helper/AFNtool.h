//
//  AFNtool.h
//  YLT
//
//  Created by Chaungciy on 16/4/23.
//  Copyright © 2016年 Chaungciy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BusinessModel.h"
@interface AFNtool : NSObject



+(void)JSwithUrl:(NSString *)url sucess:(void (^)(id obj))success faile:(void (^)(id obj))failure;






/**
 *  判断是否有网络
 *
 *  @return 是 返回YES
 */
+ (BOOL)isNetworkLinked;

@end
