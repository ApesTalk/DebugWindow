//
//  UIWebView+SearchWebView.h
//  DebugWindow
//
//  Created by TK-001289 on 2017/5/9.
//  Copyright © 2017年 TK-001289. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (SearchWebView)

- (NSInteger)yl_highlightAllOccurencesOfString:(NSString*)str;
- (void)yl_removeAllHighlights;

@end
