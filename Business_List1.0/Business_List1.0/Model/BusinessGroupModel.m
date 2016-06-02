//
//  BusinessGroupModel.m
//  Business_List1.0
//
//  Created by 冀柳冲 on 16/6/2.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import "BusinessGroupModel.h"

@implementation BusinessGroupModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(instancetype)businessModelWithDictionary:(NSDictionary *)dic{
    return  [[self alloc] initWithDictionary:dic];
}





@end
