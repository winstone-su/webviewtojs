//
//  WBWebViewController+JSBridge.h
//  WebViewToJS
//
//  Created by swb on 16/8/22.
//  Copyright © 2016年 carl. All rights reserved.
//

#import "WBWebViewController.h"

@interface WBWebViewController (JSBridge)
- (void)executeJSBridge:(NSString *)url;

@end
