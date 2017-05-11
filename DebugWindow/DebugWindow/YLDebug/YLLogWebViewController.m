//
//  YLLogWebViewController.m
//  YLLanJiQuan
//
//  Created by TK-001289 on 2017/5/8.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "YLLogWebViewController.h"
#import "YLLogTool.h"
#import "UIWebView+SearchWebView.h"

@interface YLLogWebViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UIWebView *myWebView;
@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property(nonatomic,copy)NSString *content;
@end

@implementation YLLogWebViewController
- (instancetype)initWithFile:(NSString *)name
{
    if(self = [super init]){
        self.title = name;
        NSString *path = [YLLogTool pathForFile:name];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *htmlStr = [NSString stringWithFormat:
                             @"<HTML>"
                             "<head>"
                             "<title>%@</title>"
                             "</head>"
                             "<BODY width=\"100\">"
                             "<pre style=\"font-size:20px;>\""
                             "%@"
                             "</pre>"
                             "</BODY>"
                             "</HTML>",
                             name,str];
        self.content = htmlStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    [self.view addSubview:self.myWebView];
    [self.myWebView loadHTMLString:_content baseURL:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)myWebView
{
    if(!_myWebView){
        _myWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
        _myWebView.delegate = self;
    }
    return _myWebView;
}

- (UIActivityIndicatorView *)indicator
{
    if(!_indicator){
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = self.view.center;
    }
    return _indicator;
}

#pragma mark---UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载：%@",webView.request.URL);
    [self.view addSubview:self.indicator];
    [self.indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"结束加载：%@",webView.request.URL);
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    
    CGFloat height = webView.scrollView.contentSize.height;
    if(height > CGRectGetHeight(self.view.frame)){
        height -= CGRectGetHeight(self.view.frame);
        [webView.scrollView setContentOffset:CGPointMake(0, height)];
    }
}

#pragma mark---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex){
        NSString *keywords = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(keywords.length > 0){
            [self.myWebView yl_highlightAllOccurencesOfString:keywords];
        }
    }
}

#pragma mark---other methods
- (void)search
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入关键字"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"搜索", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)orientationChanged
{
    self.myWebView.frame = self.view.frame;
    self.indicator.center = self.view.center;
}

@end
