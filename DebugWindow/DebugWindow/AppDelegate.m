//
//  AppDelegate.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/20.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "AppDelegate.h"
#import "YLDebugWindow.h"
#import "YLLogTool.h"
#import "YLTestObject.h"


@interface AppDelegate ()
{
//    YLDebugWindow *debugWindow;//必须设置为全局的，否则显示不出来
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [YLDebugWindow startDebug];
    
    YLLog(@"哈哈哈哈哈哈哈哈😄%d",1);
    for(NSInteger i = 0; i < 50; i++){
        YLLog(@"test log %li%li00",i,i);
    }
    
    //测试沙盒的值
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(YES) forKey:@"kYLBOOLKey"];
    [userDefaults setObject:@(8888) forKey:@"kYLIntegerKey"];
    [userDefaults setObject:@(88.88) forKey:@"kYLFloatKey"];
    [userDefaults setObject:@(8.888088) forKey:@"kYLDoubleKey"];
    [userDefaults setObject:@"test string" forKey:@"kYLStringKey"];
    [userDefaults setObject:@[@"测试",@1,@2,@"https://github.com/lqcjdx",@"我是Mr Lu"] forKey:@"kYLArrayKey"];
    [userDefaults setObject:@{@"key1":@"value1",@"key2":@200,@"key3":@[@1,@2,@3]} forKey:@"kYLDictionaryKey"];
    YLTestObject *obj = [[YLTestObject alloc] initWithKey:@"testKey" value:@"testValue"];
    [userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:obj] forKey:@"kYLCustomObjectKey"];
    [userDefaults synchronize];

    //反序列化
//    NSData *data = [userDefaults objectForKey:@"kYLCustomObjectKey"];
//    NSObject *custom = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    /*在这里检查launcchOptions中以下key来监测其他APP分享过来的文件
     UIApplicationLaunchOptionsURLKey  该文件的NSURL
     UIApplicationLaunchOptionsSourceApplicationKey 发送请求的应用程序的 Bundle ID
     UIApplicationLaunchOptionsAnnotationKey 源程序向目标程序传递的与该文件相关的属性列表对象
     */
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// <iOS9
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}

// >= iOS9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return YES;
}
@end
