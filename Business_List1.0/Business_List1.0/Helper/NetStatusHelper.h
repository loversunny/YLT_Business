//
//  NetStatusHelper.h
//  YLT
//   实时检测网络状态
//  Created by Chaungciy on 16/5/28.
//  Copyright © 2016年 Chaungciy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetStatusHelper : NSObject
@property(nonatomic,strong)NetStatusHelper *statusHelper;
@property(nonatomic,assign)AFNetworkReachabilityStatus status;
@property(nonatomic,assign)BOOL isHave;

+(instancetype)shareStatusHelper;
-(void)netWorkStatus:(void(^)(AFNetworkReachabilityStatus))block;
@end
