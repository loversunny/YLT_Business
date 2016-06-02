//
//  Account.h
//  YLT
//  账户
//  Created by Chaungciy on 16/4/24.
//  Copyright © 2016年 Chaungciy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
@property(nonatomic,strong) NSString * UserID;
@property(nonatomic,strong) NSString * info;
@property(nonatomic,strong) NSString * gid;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * ValidDate;
@property(nonatomic,assign) NSInteger status;
@property(nonatomic,assign) NSString * kid;
+(Account *)shareAccount;
@end
