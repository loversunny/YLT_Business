//
//  Account.m
//  YLT
//
//  Created by Chaungciy on 16/4/24.
//  Copyright © 2016年 Chaungciy. All rights reserved.
//

#import "Account.h"

@implementation Account

+(Account *)shareAccount{
    static Account *account = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[Account alloc]init];
    });

    return account;
}
@end
