//
//  JRBrowserVC.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRViewController.h"
#import <WebKit/WebKit.h>

@interface JRBrowserVC : JRViewController <UIWebViewDelegate, WKNavigationDelegate>

- (WKWebViewConfiguration *)wkWebViewConfiguration;

- (void)presentBrowser;
- (void)dismissBrowser;
- (void)showAlertViewWithText:(NSString *)text;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;

@property (nonatomic, copy, readonly) NSString *activityIndicatorText;

@property (nonatomic, strong, readonly) id webView;

@property (nonatomic, strong) NSURLRequest *urlRequest;
@property (nonatomic, strong) NSString *urlString;

@end
