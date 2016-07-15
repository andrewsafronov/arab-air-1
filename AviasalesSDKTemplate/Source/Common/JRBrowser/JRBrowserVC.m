//
//  JRBrowserVC.m
//  Aviasales iOS Apps
//
//  Created by Dmitry Ryumin on 01/04/14.
//
//

#import "JRBrowserVC.h"

#import "JRNavigationController.h"
#import "JRActivityIndicatorView.h"
#import "ColorScheme.h"

#import "NSLayoutConstraint+JRConstraintMake.h"


@interface JRBrowserVC ()

@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet UIView *bottomNavBar;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;

@property (nonatomic, assign) BOOL needDismiss;

@property (nonatomic, strong) JRActivityIndicatorView *activityIndicator;

@end


@implementation JRBrowserVC

#pragma mark - lifecycle methods

- (void)dealloc {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *closeItem = [UINavigationItem barItemWithImageName:@"JRCloseCross" target:self action:@selector(closeButtonAction:)];
    
    NSDictionary *titleTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:15.f] };
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
    self.navigationItem.leftBarButtonItems = @[closeItem];
    
    [self setupBottomNavBar];
    [self setupWebView];
    [self setupActivityIndicator];
    [self processLoading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView stopLoading];
}

#pragma mark - Public methods

- (void)presentBrowser {
    self.needDismiss = NO;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    JRNavigationController *navigationController = [[JRNavigationController alloc] initWithRootViewController:self];
    navigationController.allowedIphoneAutorotate = YES;
    
    __weak typeof(self) weakSelf = self;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:navigationController animated:YES completion:^{
        if (weakSelf.needDismiss) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            });
        }
    }];
}

- (void)dismissBrowser {
    if (self.isBeingPresented || !self.viewIsVisible) { return; }
    
    self.needDismiss = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setUrlRequest:(NSURLRequest *)urlRequest {
    _urlRequest = urlRequest;
    
    if (self.webView) {
        [self processLoading];
    }
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURL *webviewURL = nil;
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        webviewURL = [(UIWebView *)self.webView request].URL;
    } else {
        webviewURL = [self.webView URL];
    }
    if ([self.webView isLoading] && [webviewURL isEqual:url]) {
        return;
    }
    
    self.urlRequest = [[NSURLRequest alloc] initWithURL:url];
}

#pragma mark - Activity indicator

- (NSString *)activityIndicatorText {
    return NSLS(@"JR_BROWSER_ACTIVITY_OVERLAY_TITLE");
}

- (void)showActivityIndicator {
    [self.view bringSubviewToFront:self.activityIndicator];
    self.activityIndicator.hidden = NO;
}

- (void)hideActivityIndicator {
    self.activityIndicator.hidden = YES;
}

#pragma mark - Private methods

- (WKWebViewConfiguration *)wkWebViewConfiguration {
    return [WKWebViewConfiguration new];
}

- (void)setupActivityIndicator {
    self.activityIndicator = LOAD_VIEW_FROM_NIB_NAMED(@"JRActivityIndicatorView");
    self.activityIndicator.titleLabel.text = self.activityIndicatorText;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicator.hidden = YES;
    [self.view addSubview:self.activityIndicator];
    NSLayoutConstraint *horizontalCenterConstraint = [NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.view
                                                                                  attribute:NSLayoutAttributeCenterX
                                                                                 multiplier:1.f
                                                                                   constant:0.f];
    NSLayoutConstraint *verticalCenterConstraint = [NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                                                attribute:NSLayoutAttributeCenterY
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.view
                                                                                attribute:NSLayoutAttributeCenterY
                                                                               multiplier:1.f
                                                                                 constant:0.f];
    [self.view addConstraints:@[horizontalCenterConstraint, verticalCenterConstraint]];
    [self.activityIndicator layoutIfNeeded];
}

- (void)setupBottomNavBar {
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    
    [self.backButton setTitle:NSLS(@"JR_BROWSER_BACK_BTN_TITLE") forState:UIControlStateNormal];
    [self.forwardButton setTitle:NSLS(@"JR_BROWSER_FORWARD_BTN_TITLE") forState:UIControlStateNormal];
    
    [self.backButton setTitleColor:[ColorScheme lightTextColor] forState:UIControlStateNormal];
    [self.forwardButton setTitleColor:[ColorScheme lightTextColor] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[ColorScheme inactiveLightTextColor] forState:UIControlStateDisabled];
    [self.forwardButton setTitleColor:[ColorScheme inactiveLightTextColor] forState:UIControlStateDisabled];
    
    self.bottomNavBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"JRBrowserNavigationBg"]];
}

- (void)setupWebView {
    if (iOSVersionGreaterThanOrEqualTo(@"8.0") == YES && [self isKindOfClass:NSClassFromString(@"JRAdsBrowser")] == NO) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self wkWebViewConfiguration]];
        webView.navigationDelegate = self;
        _webView = webView;
    } else {
        UIWebView *webview = [[UIWebView alloc] init];
        webview.scalesPageToFit = YES;
        webview.delegate = self;
       _webView = webview;
    }
    
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.webViewContainer addSubview:self.webView];
    [self.webViewContainer addConstraints:JRConstraintsMakeScaleToFill(self.webView, self.webViewContainer)];
}

- (void)toggleBackForwardButtons {
    self.backButton.enabled = [self.webView canGoBack];
    self.forwardButton.enabled = [self.webView canGoForward];
}

- (void)processLoading {
    if (self.urlRequest == nil) { return; }
    
    [(UIWebView *)self.webView loadRequest:self.urlRequest];
}

- (void)webViewFrameDidLoad {
    NSString *titleFromPage;
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        titleFromPage = [(UIWebView *)self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    } else {
        titleFromPage = [self.webView title];
    }
    
    if (titleFromPage) {
        self.title = titleFromPage;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self toggleBackForwardButtons];
}

- (void)showAlertViewWithText:(NSString *)text {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLS(@"JR_BROWSER_ERROR_ALERT_TITLE")
                                                        message:text
                                                       delegate:self
                                              cancelButtonTitle:NSLS(@"JR_BROWSER_ERROR_ALERT_CANCEL_BUTTON_TITLE")
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)finishLoad {
    [self hideActivityIndicator];
    [self webViewFrameDidLoad];
}

- (void)didStartLoad {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self toggleBackForwardButtons];
}

#pragma mark - WKNavigationDelegate methds

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self finishLoad];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self didFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self didStartLoad];
}

#pragma mark - UIWebViewDelegate methds

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self finishLoad];
}

- (void)didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        [self hideActivityIndicator];
        
        typeof(self) __weak weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself showAlertViewWithText:error.description];
        });
    }
    
    [self toggleBackForwardButtons];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self didFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    MLOG(@"%@", request.URL.absoluteString);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self didStartLoad];
}

#pragma mark - Actions

- (IBAction)backButtonAction:(id)sender {
    [(UIWebView *)self.webView goBack];
    [self toggleBackForwardButtons];
}

- (IBAction)forwardButtonAction:(id)sender {
    [(UIWebView *)self.webView goForward];
    [self toggleBackForwardButtons];
}

- (void)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
