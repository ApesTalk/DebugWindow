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

/*
 获取本地沙盒保存的值 这里只返回自己保存的，不返回系统保存的
 返回包含YLSandboxObject对象的数组
 */
+ (NSArray *)fetchValues;

@end
