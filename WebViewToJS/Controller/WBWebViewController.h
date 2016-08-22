//
//  WBWebViewController.h
//  WebViewToJS
//
//  Created by swb on 16/8/22.
//  Copyright © 2016年 carl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WBWebViewType){
    WBWebViewTypeNormal = 0,
    WBWebViewTypeLocal
};

@interface WBWebViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic, strong, readonly) UIWebView *webView;
@property (nonatomic, assign) WBWebViewType type;

- (id)initWithUrl:(NSString *)url;

- (void)dismissSelf;

@end
