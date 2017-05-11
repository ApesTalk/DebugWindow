//
//  YLTestObject.h
//  DebugWindow
//
//  Created by TK-001289 on 2017/5/10.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLTestObject : NSObject<NSCoding>
@property(nonatomic,copy)NSString *key;
@property(nonatomic,copy)NSString *value;

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value;

@end
