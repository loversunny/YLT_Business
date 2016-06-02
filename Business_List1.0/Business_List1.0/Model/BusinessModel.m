//
//  BusinessModel.m
//  YLT-Business
//
//  Created by 冀柳冲 on 16/4/26.
//  Copyright © 2016年 冀柳冲. All rights reserved.
//

#import "BusinessModel.h"

@implementation BusinessModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.SName = [aDecoder decodeObjectForKey:@"SName"];
        self.SNo = [aDecoder decodeObjectForKey:@"SNo"];
        self.Phone = [aDecoder decodeObjectForKey:@"Phone"];
        self.City = [aDecoder decodeObjectForKey:@"City"];
        self.District = [aDecoder decodeObjectForKey:@"District"];
        self.Address = [aDecoder decodeObjectForKey:@"Address"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userID forKey:@"userID"];
    [aCoder encodeObject:self.SName forKey:@"SName"];
    [aCoder encodeObject:self.SNo forKey:@"SNo"];
    [aCoder encodeObject:self.Phone forKey:@"Phone"];
    [aCoder encodeObject:self.City forKey:@"City"];
    [aCoder encodeObject:self.District forKey:@"District"];
    [aCoder encodeObject:self.Address forKey:@"Address"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
}






- (NSString *)description
{
    return [NSString stringWithFormat:@"%@-%@-%@", _SName,_userID,_ID];
}

@end
