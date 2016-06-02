//
//  NetStatusHelper.m
//  YLT
//
//  Created by Chaungciy on 16/5/28.
//  Copyright © 2016年 Chaungciy. All rights reserved.
//

#import "NetStatusHelper.h"
@implementation NetStatusHelper

+(instancetype)shareStatusHelper{
  static NetStatusHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[NetStatusHelper alloc]init];
    });
    return helper;
}
-(void)netWorkStatus:(void(^)(AFNetworkReachabilityStatus))block{
    _statusHelper = [NetStatusHelper shareStatusHelper];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        _statusHelper.status = status;
        block(status);
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
@end
