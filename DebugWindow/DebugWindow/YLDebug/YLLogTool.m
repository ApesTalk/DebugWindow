//
//  YLLogTool.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/21.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLLogTool.h"
#import <UIKit/UIKit.h>
#import <unistd.h>

static NSString *currentLogFileName;///< 当前日志文件名
static dispatch_queue_t writeLogQueue;


@interface YLLogTool ()
@end

@implementation YLLogTool

+ (BOOL)needRedirect
{
    //如果已经连接Xcode调试则不输出到文件
    //该函数用于检测输出 (STDOUT_FILENO) 是否重定向 是个 Linux 程序方法
    if(isatty(STDOUT_FILENO)) {
        return NO;
    }
    
    // 判断 当前是否在 模拟器环境 下 在模拟器不保存到文件中
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){
        return NO;
    }
    return YES;
}

+ (void)redirectNSLog
{
    if(![self needRedirect]) return;
    
    // 将log输入到文件
    //fopen()函数：打开一个文件并返回文件指针  http://c.biancheng.net/cpp/html/250.html
    //freopen()函数：文件流重定向，流替换     http://c.biancheng.net/cpp/html/2508.html
    //iOS学习笔记40-日志重定向              http://www.jianshu.com/p/aaf49d0d0d98
    NSString *path = [self logFilePath];
    freopen([path cStringUsingEncoding:NSUTF8StringEncoding], "a+", stdout);
    freopen([path cStringUsingEncoding:NSUTF8StringEncoding], "a+", stderr);
    
    
    //未捕获的Objective-C异常日志
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

+ (void)logConfig
{
    if(!writeLogQueue){
        writeLogQueue = dispatch_queue_create("com.lambert.log", DISPATCH_QUEUE_SERIAL);//串行队列
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [self logFilePath];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    //1.保存之前的log
    NSString *initialStr = [NSString stringWithFormat:@"\n---初始化---\n"];
    [self log:initialStr];
    //2.不保存之前的log，每次重新开始写入
//    [initialStr writeToFile:path atomically:YES encoding:NSUTF16StringEncoding error:nil];
    
    
    [self redirectNSLog];
}

void UncaughtExceptionHandler(NSException* exception)
{
    NSString *name = [exception name];
    NSString *reason = [exception reason];
    NSArray *symbols = [exception callStackSymbols]; // 异常发生时的调用栈
    NSMutableString *strSymbols = [[NSMutableString alloc] init]; //将调用栈拼成输出日志的字符串
    for(NSString *item in symbols)
    {
        [strSymbols appendString: item];
        [strSymbols appendString: @"\r\n"];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *crashString = [NSString stringWithFormat:@"<- %@ ->[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n", dateStr, name, reason, strSymbols];
    
    [YLLogTool log:crashString];
}

+ (NSString *)logDirectory
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *logDir = [docPath stringByAppendingPathComponent:@"Logs"];
    return logDir;
}

+ (NSString *)logFilePath
{
    if(!currentLogFileName){
        NSString *logDir = [self logDirectory];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:logDir]){
            NSError *error;
            [fileManager createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:&error];
            if(error){
                NSLog(@"%@",error);
            }
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [dateStr stringByAppendingString:@".txt"];
        currentLogFileName = [logDir stringByAppendingPathComponent:fileName];
    }
    return currentLogFileName;
}

+ (void)log:(NSString *)content
{
    if(!content){
        return;
    }
    if(![self needRedirect]){
        //同时输出到控制台
        NSLog(@"%@",content);
    }
    
    //这里以追加的形式写入文件
    dispatch_async(writeLogQueue, ^{
        //打开一个文件准备更新（读取或写入）
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[self logFilePath]];
        //将文件指针的当前位置（偏移量）放在文件末尾处
        [fileHandle seekToEndOfFile];
        //在文件指针的当前位置写入，写入完成后文件指针的当前位置自动更新
        //采用UTF8编码会导致在浏览器中正常，在真机上显示乱码
        [fileHandle writeData:[content dataUsingEncoding:NSUTF16StringEncoding]];
        [fileHandle closeFile];//关闭文件
    });
}

+ (NSArray *)allLogFileNames
{
    NSMutableArray *fileNames = [NSMutableArray array];
    NSString *logDir = [self logDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:logDir error:&error];
    NSLog(@"%@",error);
    if(contents){
        contents = [contents sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            NSComparisonResult result = [obj1 compare:obj2];
            if(result == NSOrderedAscending) return NSOrderedDescending;
            if(result == NSOrderedDescending) return NSOrderedAscending;
            return NSOrderedSame;
        }];
        [fileNames addObjectsFromArray:contents];
    }
    return fileNames;
}

+ (NSString *)pathForFile:(NSString *)fileName
{
    NSString *logDir = [self logDirectory];
    NSString *filePath = [logDir stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (void)deleteLogFile:(NSString *)fileName
{
    NSString *filePath = [self pathForFile:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]){
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        NSLog(@"%@",error);
    }
    
}

+ (void)deleteAllLogFiles
{
    NSString *logDir = [self logDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager removeItemAtPath:logDir error:&error];
    NSLog(@"%@",error);
}

@end
