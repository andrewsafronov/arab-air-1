//
//  JRGateBrowserVC.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRGateBrowserVC.h"

#import "JRNavigationController.h"

#define kJSCallbackHandlerName @"ASJSCallbackHandler"


@interface JRBrowserVC ()

- (void)webViewFrameDidLoad;
- (void)closeButtonAction:(id)sender;

@end


@interface JRGateBrowserVC () <WKScriptMessageHandler, AviasalesSDKPurchasePerformerDelegate>

@property (nonatomic, strong) AviasalesSDKPurchasePerformer *purchasePerformer;

@end


@implementation JRGateBrowserVC
@synthesize ticketPrice = _ticketPrice;

- (WKWebViewConfiguration *)wkWebViewConfiguration {
    WKWebViewConfiguration *wkConfiguration = [super wkWebViewConfiguration];
    WKUserContentController *wkContentController = [[WKUserContentController alloc] init];
    [wkContentController addScriptMessageHandler:[[JRLeakAvoider alloc] initWithDelegate:self] name:kJSCallbackHandlerName];
    [wkConfiguration setUserContentController:wkContentController];
    
    return wkConfiguration;
}

#pragma mark - lifecycle methods

- (void)dealloc {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        [((WKWebView *)self.webView).configuration.userContentController removeScriptMessageHandlerForName:kJSCallbackHandlerName];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = self.ticketPrice.gate.label;
}

#pragma mark - Public methods

- (void)setTicketPrice:(id<JRSDKPrice>)ticketPrice searchID:(NSString *)searchId {
    _ticketPrice = ticketPrice;
    self.purchasePerformer = [[AviasalesSDKPurchasePerformer alloc] initWithPrice:ticketPrice searchId:searchId];
    [self.purchasePerformer performWithDelegate:self];

    [self showActivityIndicator];
}

#pragma mark - AviasalesSDKPurchasePerformerDelegate methds

- (void)purchasePerformer:(AviasalesSDKPurchasePerformer *)performer didFinishWithURLRequest:(NSURLRequest *)URLRequest {
    self.urlRequest = URLRequest;
}

- (void)purchasePerformer:(AviasalesSDKPurchasePerformer *)performer didFailWithError:(NSError *)error {
    [self hideActivityIndicator];
    [self showAlertViewWithText:error.description];
}

#pragma mark - WKScriptMessageHandler methds

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
}

@end


@implementation JRLeakAvoider

- (id)initWithDelegate:(id<WKScriptMessageHandler>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - WKScriptMessageHandler methds

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
