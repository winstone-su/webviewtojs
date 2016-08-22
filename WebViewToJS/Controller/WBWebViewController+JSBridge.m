//
//  WBWebViewController+JSBridge.m
//  WebViewToJS
//
//  Created by swb on 16/8/22.
//  Copyright © 2016年 carl. All rights reserved.
//

#import "WBWebViewController+JSBridge.h"
#import <objc/runtime.h>

@interface WBWebViewController()

@property (nonatomic, assign) int callbackId; //
@property (nonatomic, strong) NSString *appUrl;

@end

@implementation WBWebViewController (JSBridge)

- (int)callbackId {
    return [objc_getAssociatedObject(self, @selector(callbackId)) intValue];
}

- (void)setCallbackId:(int)callbackId {
    objc_setAssociatedObject(self, @selector(callbackId), [NSNumber numberWithInt:callbackId], OBJC_ASSOCIATION_ASSIGN);
}

- (NSString *)appUrl {
    return objc_getAssociatedObject(self, @selector(appUrl));
}

- (void)setAppUrl:(NSString *)appUrl {
    objc_setAssociatedObject(self, @selector(appUrl), appUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)executeJSBridge:(NSString *)url
{
    NSArray *components = [url componentsSeparatedByString:@":"];
    if ([components count] >= 4) {
        //功能
        NSString *function = (NSString *)[components objectAtIndex:1];
        //回调方法ID
        int callbackId = [((NSString *)[components objectAtIndex:2])intValue];
        //参数
        NSString * argsAsString = [(NSString *)[components objectAtIndex:3] stringByRemovingPercentEncoding];
        NSDictionary *args = nil;
        if (argsAsString.length > 0) {
            args = [NSJSONSerialization JSONObjectWithData:[argsAsString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        }
        [self executeCall:function callbackID:callbackId args:args];
    }
}

- (void)executeCall:(NSString *)function callbackID:(int)callbackID args:(NSDictionary *)args
{
    self.callbackId = callbackID;
    if([function isEqualToString:@"closewindow"]){
//        NSLog(@"%@",args);
        [self dismissSelf];
    }
    
}

- (void)returnResult:(int)callbackId args:(NSDictionary *)resultDic {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *resultArrayString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [resultArrayString stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:[NSString stringWithFormat:@"WBNativeJSBridge.resultForCallback(%d,%@);", callbackId, resultArrayString] waitUntilDone:NO];
}





@end
