//
//  YLSandboxCell.m
//  DebugWindow
//
//  Created by TK-001289 on 2017/5/10.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import "YLSandboxCell.h"

@implementation YLSandboxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        CGFloat frameWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat leftWidth = frameWidth / 3.0;
        _keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, leftWidth - 25, 35)];
        _keyLabel.font = [UIFont systemFontOfSize:10];
        _keyLabel.adjustsFontSizeToFitWidth = YES;
        _keyLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_keyLabel];
        
        _valueField = [[UITextField alloc]initWithFrame:CGRectMake(leftWidth + 5, 10, frameWidth - leftWidth - 10, 35)];
        _valueField.borderStyle = UITextBorderStyleRoundedRect;
        _valueField.font = [UIFont systemFontOfSize:13];
        _valueField.textColor = [UIColor blackColor];
        [self.contentView addSubview:_valueField];
    }
    return self;
}

- (void)refreshWithTitle:(NSObject *)title value:(NSObject *)obj
{
    _keyLabel.text = title.description;
    if([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]){
        _valueField.borderStyle = UITextBorderStyleRoundedRect;
        _valueField.text = obj.description;
        _valueField.enabled = YES;
        _valueField.keyboardType = [obj isKindOfClass:[NSString class]] ? UIKeyboardTypeDefault : UIKeyboardTypeDecimalPad;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }else if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]){
        _valueField.borderStyle = UITextBorderStyleNone;
        _valueField.text = NSStringFromClass([obj class]);
        _valueField.enabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        //other data
        if([obj isKindOfClass:[NSData class]]){
            //反序列化
            NSObject *customObj = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)obj];
            _valueField.text = customObj.description;
        }else{
            _valueField.text = obj.description;
        }
        _valueField.borderStyle = UITextBorderStyleNone;
        _valueField.enabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

+ (CGFloat)height
{
    return 55;
}

@end
