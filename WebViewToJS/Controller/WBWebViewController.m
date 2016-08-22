//
//  WBWebViewController.m
//  WebViewToJS
//
//  Created by swb on 16/8/22.
//  Copyright © 2016年 carl. All rights reserved.
//

#import "WBWebViewController.h"
#import "WBWebViewController+JSBridge.h"

static NSString *WBWebViewLightAppScheme = @"wbweb:";

@interface WBWebViewController ()
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSURL *webUrl;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *localPathURL;
@end

@implementation WBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.webView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.webView];
    
    [self loadRequest];
    
}

-(NSURL *)localPathURL
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    return url;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.type = WBWebViewTypeNormal;
        if (url.length > 0) {
            if ([url hasPrefix:@"www."]) {
                url = [@"http://" stringByAppendingString:url];
            }
            self.url = url;
            self.webUrl = [NSURL URLWithString:url];
        }
    }
    return self;
}

- (void)dismissSelf
{
    if ([self.navigationController.viewControllers count] == 1) { //是prensent 的方式
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else { // push
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)loadRequest
{
    switch (self.type) {
        case WBWebViewTypeNormal:
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.webUrl]];
            break;
        case WBWebViewTypeLocal:
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.localPathURL]];
        default:
            break;
    }
}

#pragma UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:WBWebViewLightAppScheme]) {
        [self executeJSBridge:requestString];
    }
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.title) {
        self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}



@end
