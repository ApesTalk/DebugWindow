//
//  YLSandboxObject.h
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/27.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLSandboxObject : NSObject
@property(nonatomic,copy)NSString *key;
@property(nonatomic,strong)NSObject *value;
@property(nonatomic,weak)YLSandboxObject *preNode;///< 父节点
@property(nonatomic,copy)NSDictionary *dicOfValue;

- (instancetype)initWithKey:(NSString *)key value:(NSObject *)value preNode:(YLSandboxObject *)node;
/*
 获取本地沙盒保存的值 这里只返回自己保存的，不返回系统保存的
 返回包含YLSandboxObject对象的数组
 */
+ (NSArray *)fetchValues;

/*
 获取本地沙盒保存的值，传入你本地key的前缀进行筛选。
 返回包含YLSandboxObject对象的数组
 */
+ (NSArray *)fetchValuesWithPrefix:(NSString *)prefix;

@end
