//
//  YLSandboxObject.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/27.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLSandboxObject.h"

@implementation YLSandboxObject
- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value
{
    if(self = [super init]){
        self.key = key;
        self.value = value;
    }
    return self;
}

+ (NSArray *)fetchValues
{
    NSMutableArray *values = [NSMutableArray array];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSArray *keys = dic.allKeys;
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if([evaluatedObject isKindOfClass:[NSString class]]){
            NSString *key = (NSString *)evaluatedObject;
            return [key hasPrefix:@"kYL"];//注意：这里假设我们自己保存到沙盒的key都是以kYL开头的
        }
        return NO;
    }];
    keys = [keys filteredArrayUsingPredicate:predicate];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = (NSString *)obj;
        id value = dic[key];
        YLSandboxObject *var = [[YLSandboxObject alloc]initWithKey:key value:value];
        [values addObject:var];
    }];
    return values;
}

@end
