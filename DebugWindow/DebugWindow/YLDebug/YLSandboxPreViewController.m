//
//  YLSandboxPreViewController.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/27.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLSandboxPreViewController.h"
#import "YLSandboxObject.h"

@interface YLSandboxPreViewController ()
@property(nonatomic,strong)YLSandboxObject *obj;
@property(nonatomic,strong)UITextView *textView;
@end

@implementation YLSandboxPreViewController
- (instancetype)initWithSandboxObject:(YLSandboxObject *)obj
{
    if(self = [super init]){
        self.obj = obj;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _obj.key;
    _textView = [[UITextView alloc]initWithFrame:self.view.frame];
    _textView.editable = NO;
    [self.view addSubview:_textView];
    _textView.text = _obj.value.description;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
