//
//  ViewController.m
//  WKWebView_test
//
//  Created by 秦国华 on 2017/2/10.
//  Copyright © 2017年 秦国华. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#define  Width [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>
{
     WKUserContentController* userContentController;
}
@property(strong,nonatomic)WKWebView *webView;

@end

@implementation ViewController

 /*! @abstract A copy of the configuration with which the web view was
 initialized. */

//@property (nonatomic, readonly, strong) WKBackForwardList *backForwardList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backUp)];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
//    [self creatUI];
    [self loadCode];
    
}

- (void)backUp
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        NSLog(@"没有设置app返回事项");
    }
}

- (void)creatUI
{
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 20.f;
    config.preferences.javaScriptEnabled = YES; //The default value is YES
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;//The default value is NO in iOS and YES in OS X.
    //config.preferences.javaEnabled = NO ; //The default value is NO .不在iphone中使用的方法
    
    config.userContentController = [WKUserContentController new];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];//CGRectMake(50, 200, Width - 100, Height - 200)
    //两个协议
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self loadCode];
    
    [self.webView setAllowsBackForwardNavigationGestures:true];
    
    [self.view addSubview:self.webView];
}

#pragma mark - load method
- (void)loadCode
{
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [self.webView loadRequest:request];

    // 图片缩放的js代码
    NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=500;image.style.height=600;};window.alert('找到' + count + '张图');";
    // 根据JS字符串初始化WKUserScript对象
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:script];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [_webView loadHTMLString:@"<head></head><img src='http://og3hqoz3g.bkt.clouddn.com/%E5%B9%B8%E7%A6%8F%E9%82%AE%E5%B1%80.jpg' />"baseURL:nil];
    [self.view addSubview:_webView];
}


#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runOpenPanelWithParameters:(WKOpenPanelParameters *)parameters initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSArray<NSURL *> * _Nullable URLs))completionHandler
{
    NSLog(@"runOpenPanelWithParameters");
}
- (void)webView:(WKWebView *)webView commitPreviewingViewController:(UIViewController *)previewingViewController
{
     NSLog(@"commitPreviewingViewController");
}

- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
{
    NSLog(@"shouldPreviewElement");
    return NO;
    
}
//警告框

/**
 webView界面中有弹出警告框时调用

 @param webView             web视图调用委托方法
 @param message             警告框提示内容
 @param frame               主窗口
 @param completionHandler   警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    completionHandler();
    NSLog(@"警告框");
}
//输入框

/**
 web界面中弹出输入框时调用

 @param webView             web视图调用委托方法
 @param prompt              输入消息的显示
 @param defaultText         初始化时显示的输入文本
 @param frame               主窗口
 @param completionHandler   输入结束后调用
 */
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"输入框");
    completionHandler(@"http");
}
//确认框

/**
 显示一个JavaScript确认面板

 @param webView             web视图调用委托方法
 @param message             显示的信息
 @param frame               主窗口
 @param completionHandler   确认后完成处理程序调用
 */
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    NSLog(@"确认框");
    completionHandler(YES);
}

- (void)webViewDidClose:(WKWebView *)webView
{
    NSLog(@"webViewDidClose");
}

#pragma mark - WkNavigationDelegate
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"页面开始加载时调用。   2");
}

//内容返回时调用，得到请求内容时调用(内容开始加载) -> view的过渡动画可在此方法中加载
- (void)webView:(WKWebView *)webView didCommitNavigation:( WKNavigation *)navigation
{
    NSLog(@"内容返回时调用，得到请求内容时调用。 4");
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:( WKNavigation *)navigation
{
    NSLog(@"页面加载完成时调用。 5");
}

#pragma mark - error
//请求失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error1:%@",error);
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error2:%@",error);
}

//在请求发送之前，决定是否跳转 -> 该方法如果不实现，系统默认跳转。如果实现该方法，则需要设置允许跳转，不设置则报错。
//该方法执行在加载界面之前
//Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'Completion handler passed to -[ViewController webView:decidePolicyForNavigationAction:decisionHandler:] was not called'
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    
    //不允许跳转
//    decisionHandler(WKNavigationActionPolicyCancel);
    NSLog(@"在请求发送之前，决定是否跳转。  1");
}

//在收到响应后，决定是否跳转（同上）
//该方法执行在内容返回之前
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
//    decisionHandler(WKNavigationResponsePolicyCancel);
    NSLog(@"在收到响应后，决定是否跳转。 3");
    
}

//接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    NSLog(@"接收到服务器跳转请求之后调用");
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    NSLog(@"webViewWebContentProcessDidTerminate");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end











