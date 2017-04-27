//
//  YLLogTool.h
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/21.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLLogTool : NSObject

#define YLLog(s, ...) [YLLogTool log: [NSString stringWithFormat:@"<%p %@:(%d)> %@\n", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] ]]

+ (void)logConfig;

+ (NSString *)logFilePath;

+ (void)log:(NSString *)content;

+ (NSArray *)allLogFileNames;
+ (NSString *)pathForFile:(NSString *)fileName;
+ (void)deleteLogFile:(NSString *)fileName;
+ (void)deleteAllLogFiles;

@end
