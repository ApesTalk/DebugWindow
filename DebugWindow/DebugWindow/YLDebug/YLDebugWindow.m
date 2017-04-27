//
//  YLDebugWindow.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/20.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLDebugWindow.h"
#import "YLLogTool.h"
#import "YLLogListController.h"

static CGFloat const kSize = 45.0;
static CGFloat const kActiveAlpha = 1.0;
static CGFloat const kInActiveAlpha = 0.5;
#define kFrameWidth [UIScreen mainScreen].bounds.size.width
#define kFrameHeight [UIScreen mainScreen].bounds.size.height

@interface YLDebugWindow ()

@end

@implementation YLDebugWindow
+ (instancetype)shareInstance
{
    static YLDebugWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[YLDebugWindow alloc]init];
    });
    return window;
}

- (instancetype)init
{
    if(self = [super init]){
        self.frame = CGRectMake(0, 0, kSize, kSize);
        self.center = CGPointMake(kSize * 0.5, kFrameHeight * 0.5);
        self.layer.cornerRadius = kSize * 0.5;
        self.layer.masksToBounds = YES;
        self.windowLevel = UIWindowLevelAlert + 1;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        self.rootViewController = [UIViewController new];//必须的
        [self makeKeyAndVisible];
        
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Log";
        [self addSubview:label];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

+ (void)startDebug
{
    [YLDebugWindow shareInstance];
    [YLLogTool logConfig];
}

- (void)tapAction
{
    YLLog(@"点击Log按钮，打开预览");
    self.hidden = YES;
    YLLogListController *logListController = [[YLLogListController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logListController];
    UIViewController *rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootVc presentViewController:nav animated:YES completion:nil];
    //打开预览
//    [self.docController presentPreviewAnimated:YES];
    
//    UIViewController *rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
//    [rootVc presentViewController:self.quickController animated:YES completion:nil];
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    YLLog(@"拖动事件");
    CGPoint point = [panGesture locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(panGesture.state == UIGestureRecognizerStateBegan){
        self.alpha = kActiveAlpha;
    }
    if(panGesture.state == UIGestureRecognizerStateChanged){
        self.center = point;
    }else if(panGesture.state == UIGestureRecognizerStateEnded){
        CGFloat centerX;
        if(point.x <= kFrameWidth / 2.0){
            centerX = kSize * 0.5;
            
        }else{
            centerX = kFrameWidth - kSize * 0.5;
        }
        CGFloat centerY = MIN(MAX(kSize * 0.5, point.y), kFrameHeight - kSize * 0.5);
        [UIView animateWithDuration:0.5 animations:^{
            self.center = CGPointMake(centerX, centerY);
        }completion:^(BOOL finished) {
            self.alpha = kInActiveAlpha;
            YLLog(@"停止拖动后位置确定");
        }];
    }
}


@end
