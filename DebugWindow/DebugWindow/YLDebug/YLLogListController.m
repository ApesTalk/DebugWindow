//
//  YLLogListController.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/4/27.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLLogListController.h"
#import "YLLogTool.h"
#import "YLSandboxObject.h"
#import "YLDebugWindow.h"
#import <QuickLook/QuickLook.h>
#import "YLLogWebViewController.h"
#import "YLSandboxPreViewController.h"

static NSString *cellIdentifier = @"cell";

@interface YLPreviewItem : NSObject<QLPreviewItem>
- (instancetype)initWithTitle:(NSString *)name;
@end

@implementation YLPreviewItem
@synthesize previewItemTitle = _previewItemTitle;
@synthesize previewItemURL = _previewItemURL;

- (instancetype)initWithTitle:(NSString *)name
{
    if(self = [super init]){
        _previewItemTitle = name;
        NSString *path = [YLLogTool pathForFile:name];
        _previewItemURL = [NSURL fileURLWithPath:path];
    }
    return self;
}


@end

@interface YLLogListController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *logList;
    NSMutableArray *sandboxValues;
}
@property(nonatomic,strong)UIDocumentInteractionController *docController;
@property(nonatomic,strong)UIButton *footer;

@end

@implementation YLLogListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Debug";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除全部" style:UIBarButtonItemStylePlain target:self action:@selector(clean)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.tableFooterView = self.footer;
    logList = [NSMutableArray arrayWithArray:[YLLogTool allLogFileNames]];
    sandboxValues = [NSMutableArray arrayWithArray:[YLSandboxObject fetchValues]];
}

- (UIButton *)footer
{
    if(!_footer){
        _footer = [UIButton buttonWithType:UIButtonTypeCustom];
        _footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _footer.frame = CGRectMake(0, 0, 0, 45);
        _footer.titleLabel.font = [UIFont systemFontOfSize:20];
        [_footer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_footer setTitle:@"添加键值对" forState:UIControlStateNormal];
        [_footer addTarget:self action:@selector(addKeyValue) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section == 0 ? @"日志文件" : @"沙盒值";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return logList.count;
    return sandboxValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section == 0){
        cell.textLabel.text = logList[indexPath.row];
    }else{
        YLSandboxObject *obj = sandboxValues[indexPath.row];
        cell.textLabel.text = obj.key;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if(indexPath.section == 0){
            [YLLogTool deleteLogFile:logList[indexPath.row]];
            [logList removeObjectAtIndex:indexPath.row];
        }else{
            YLSandboxObject *obj = sandboxValues[indexPath.row];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:obj.key];
            [userDefaults synchronize];
            [sandboxValues removeObjectAtIndex:indexPath.row];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark---UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        YLLogWebViewController *webController = [[YLLogWebViewController alloc]initWithFile:logList[indexPath.row]];
        [self.navigationController pushViewController:webController animated:YES];
//        QLPreviewController *preController = [[QLPreviewController alloc]init];
//        preController.dataSource = self;
//        preController.delegate = self;
//        preController.currentPreviewItemIndex = indexPath.row;
//        [self.navigationController pushViewController:preController animated:YES];
    }else{
        YLSandboxPreViewController *preController = [[YLSandboxPreViewController alloc]initWithSandboxObject:sandboxValues[indexPath.row]];
        [self.navigationController pushViewController:preController animated:YES];
    }
}

#pragma mark---QLPreviewControllerDataSource
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return logList.count;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    controller.title = logList[index];//注释此行无法正确设置标题。。。
    YLPreviewItem *item = [[YLPreviewItem alloc]initWithTitle:logList[index]];
    return item;
}

#pragma mark---QLPreviewControllerDelegate



#pragma mark---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != alertView.cancelButtonIndex){
        NSString *key = [[[alertView textFieldAtIndex:0] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *value = [[[alertView textFieldAtIndex:1] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(key.length > 0 && value.length > 0){
            NSObject *obj;
            NSString *tmpStr = [value stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            if(tmpStr.length == 0) {
                //都是数字
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                obj = [formatter numberFromString:value];
            } else {
                //不是数字
                obj = value;
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:obj forKey:key];
            [userDefaults synchronize];
            
            sandboxValues = [NSMutableArray arrayWithArray:[YLSandboxObject fetchValues]];
            [self.tableView reloadData];
        }
    }
}

#pragma mark---other methods
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [YLDebugWindow shareInstance].hidden = NO;
}

- (void)clean
{
    [YLLogTool deleteAllLogFiles];
    [logList removeAllObjects];
    [self.tableView reloadData];
}

- (void)addKeyValue
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请填写键值对信息" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[alert textFieldAtIndex:0] setPlaceholder:@"key"];
    [[alert textFieldAtIndex:1] setPlaceholder:@"value"];
    [[alert textFieldAtIndex:1] setSecureTextEntry:NO];
    [alert show];
}

@end
