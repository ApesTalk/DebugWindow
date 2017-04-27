//
//  ViewController.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/20.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"测试程序奔溃日志" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 150, 40);
    [btn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSLog(@"测试程序中已有的NSLog输出日志！！！");
    NSLog(@"测试程序中已有的NSLog输出日志！！！");
    NSLog(@"测试程序中已有的NSLog输出日志！！！");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    NSLog(@"测试程序中已有的NSLog输出日志sfasfa！！！");
    NSArray *array = @[];
    NSString *item = array[2];
}

@end
