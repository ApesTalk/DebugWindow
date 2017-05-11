//
//  YLSandboxCell.h
//  DebugWindow
//
//  Created by TK-001289 on 2017/5/10.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLSandboxCell : UITableViewCell
@property(nonatomic,strong)UILabel *keyLabel;
@property(nonatomic,strong)UITextField *valueField;

- (void)refreshWithTitle:(NSObject *)title value:(NSObject *)obj;

+ (CGFloat)height;

@end
