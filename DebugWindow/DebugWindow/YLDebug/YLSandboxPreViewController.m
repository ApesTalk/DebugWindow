//
//  YLSandboxPreViewController.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/27.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLSandboxPreViewController.h"
#import "YLSandboxObject.h"
#import "YLSandboxCell.h"

static NSString * const YLObjectChangedNotification = @"YLObjectChangedNotification";
static NSString *cellIdentifier = @"YLSandboxCell";

@interface YLSandboxPreViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSArray *keys;
    NSMutableDictionary *dataDic;
}
@property(nonatomic,strong)YLSandboxObject *obj;
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,weak)UITextField *activeField;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    [self.view addSubview:self.table];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNotification:) name:YLObjectChangedNotification object:nil];
}

- (void)reloadData
{
    NSDictionary *dicValue = [_obj dicOfValue];
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dicValue];
    keys = [dataDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if(obj1 < obj2) return NSOrderedAscending;
        if(obj1 > obj2) return NSOrderedDescending;
        return NSOrderedSame;
    }];
    [_table reloadData];
}

- (void)reloadNotification:(NSNotification *)notification
{
    if([notification.object isKindOfClass:[YLSandboxObject class]]){
        YLSandboxObject *otherObj = (YLSandboxObject *)notification.object;
        if(self.obj == otherObj){
            [self reloadData];
        }
    }
}

- (UITableView *)table
{
    if(!_table){
        _table = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        [_table registerClass:[YLSandboxCell class] forCellReuseIdentifier:cellIdentifier];
        _table.dataSource = self;
        _table.delegate = self;
        _table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;//拖动时释放键盘
        _table.tableFooterView = [UIView new];
    }
    return _table;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLSandboxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    NSObject *key = keys[row];
    NSObject *value = dataDic[key];
    [cell refreshWithTitle:key value:value];
    cell.valueField.tag = row;
    cell.valueField.delegate = self;
    return cell;
}

#pragma mark---UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YLSandboxCell height];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSString *key = keys[row];
    NSObject *value = dataDic[key];
    if([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]])
    {
        YLSandboxObject *obj = [[YLSandboxObject alloc]initWithKey:key value:value preNode:_obj];
        YLSandboxPreViewController *preController = [[YLSandboxPreViewController alloc]initWithSandboxObject:obj];
        [self.navigationController pushViewController:preController animated:YES];
    }
}

#pragma mark---UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSInteger row = textField.tag;
    if(keys.count > row){
        NSObject *key = keys[row];
        NSString *content = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *tmpStr = [content stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        if(tmpStr.length == 0) {
            //都是数字
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            NSNumber *number = [formatter numberFromString:content];
            dataDic[key] = number;
        } else {
            //不是数字
            dataDic[key] = content;
        }
    }
}

#pragma mark---other methods
- (void)save
{
    [self.view endEditing:YES];
    [self.obj setDicOfValue:dataDic];
    [[NSNotificationCenter defaultCenter] postNotificationName:YLObjectChangedNotification object:self.obj.preNode];
}

@end
