//
//  ViewController.m
//  WebViewToJS
//
//  Created by swb on 16/8/22.
//  Copyright © 2016年 carl. All rights reserved.
//

#import "ViewController.h"
#import "WBWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupNavigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupNavigation
{
    [self.navigationController.navigationBar setTranslucent:NO];
    self.title = @"Root View";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc ]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightButtonClick:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

- (void)rightButtonClick:(id)sender
{
    WBWebViewController *webViewControlelr = [[WBWebViewController alloc]initWithUrl:@"www.baidu.com"];
    webViewControlelr.type = WBWebViewTypeLocal;
    [self.navigationController pushViewController:webViewControlelr animated:YES];
}



@end
