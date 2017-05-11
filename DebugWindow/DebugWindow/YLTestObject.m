//
//  YLTestObject.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/5/10.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLTestObject.h"

@implementation YLTestObject
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value
{
    if(self = [super init]){
        self.key = key;
        self.value = value;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    self.key = [aDecoder decodeObjectForKey:@"key"];
    self.value = [aDecoder decodeObjectForKey:@"value"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_key forKey:@"key"];
    [aCoder encodeObject:_value forKey:@"value"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"key:%@, value:%@",_key,_value];
}

@end
