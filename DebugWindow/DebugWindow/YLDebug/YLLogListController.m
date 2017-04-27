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

@interface YLLogListController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    NSMutableArray *logList;
    NSArray *sandboxValues;
}
@property(nonatomic,strong)UIDocumentInteractionController *docController;

@end

@implementation YLLogListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Debug";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除全部" style:UIBarButtonItemStylePlain target:self action:@selector(clean)];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    logList = [NSMutableArray arrayWithArray:[YLLogTool allLogFileNames]];
    sandboxValues = [YLSandboxObject fetchValues];
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
    return indexPath.section == 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [YLLogTool deleteLogFile:logList[indexPath.row]];
        [logList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark---UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        QLPreviewController *preController = [[QLPreviewController alloc]init];
        preController.dataSource = self;
        preController.delegate = self;
        preController.currentPreviewItemIndex = indexPath.row;
        [self.navigationController pushViewController:preController animated:YES];
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

@end
