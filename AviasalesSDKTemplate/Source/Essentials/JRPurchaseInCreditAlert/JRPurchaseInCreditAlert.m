//
//  JRPurchaseInCreditAlert.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRPurchaseInCreditAlert.h"
#import "JROverlayView.h"
#import "CAAnimation+JRPopup.h"
#import "UIWindow+TopMostViewController.h"
#import "DateUtil.h"

@interface JRPurchaseInCreditAlert () <UIAlertViewDelegate, AviasalesSDKPurchasePerformerDelegate, UIWebViewDelegate>
@property (nonatomic, strong) UIWindow *prevKeyWindow;
@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, weak) IBOutlet UIView *alertContainerView;
@property (nonatomic, weak) IBOutlet UIView *alertInnerView;
@property (nonatomic, strong) JROverlayView *overlayView;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *gateLabel;
@property (nonatomic, weak) IBOutlet UILabel *conditionsLabel;
@property (nonatomic, weak) IBOutlet UIButton *buyInCreditButton;

@property (nonatomic, weak) IBOutlet UIView *creditInfoContainer;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *purchaseActivityIndicatorView;

@property (nonatomic, weak) IBOutlet UILabel *paymentsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *paymentsLabel;
@property (nonatomic, weak) IBOutlet UILabel *creditDurationTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *creditDurationLabel;
@property (nonatomic, weak) IBOutlet UILabel *overpaymentTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *overpaymentLabel;
@property (nonatomic, weak) IBOutlet UILabel *gracePeriodTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *gracePeriodLabel;
@end


@implementation JRPurchaseInCreditAlert {
    id <JRSDKPrice> _price;
    NSString *_searchId;
    AviasalesSDKPurchasePerformer *_purchasePerformer;
    NSURL *_purchaseURL;
    UIWebView *_hiddenWebView;
    BOOL _foundURLToOpen;
    UIAlertView *_alertView;
}

- (instancetype)initWithPrice:(id <JRSDKPrice>)price searchId:(NSString *)searchId {
    if (self = [super init]) {
        _price = price;
        _searchId = searchId;
    }

    return self;
}

- (void)dealloc {
    _alertView.delegate = nil;
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    
    self.buyInCreditButton.alpha = 1;
    self.purchaseActivityIndicatorView.alpha = 0;
}

#pragma mark - UI

- (void)setupViews {
    [self mimicJRAlert];

    NSNumber *priceNumber = [JRSDKModelUtils creditPaymentInUserCurrencyForPrice:_price];
    _priceLabel.text = [AviasalesNumberUtil formatPrice:priceNumber];
    _conditionsLabel.text = NSLS(@"JR_TICKET_CREDIT_ALERT_CONDITIONS");
    _gateLabel.text = [NSString stringWithFormat:@"%@ %@", NSLS(@"JR_SEARCH_RESULTS_TICKET_IN_THE"), _price.gate.label];
    
    [self showCreditInfo];
}

- (void)mimicJRAlert {
    self.alertInnerView.layer.cornerRadius = 6;
    self.alertInnerView.layer.masksToBounds = YES;
    self.alertContainerView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.alertContainerView.layer.shadowOpacity = 0.5f;
    self.alertContainerView.layer.shadowRadius = JRPixel() * 2;
    self.alertContainerView.layer.shadowOffset = CGSizeMake(0, 1);
    self.alertContainerView.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.alertInnerView.bounds cornerRadius:6.f] CGPath];
}

- (void)showCreditInfo {
    NSString *paymentTitle = NSLSP(@"JR_TICKET_CREDIT_ALERT_PAYMENTS", _price.creditPaymentsCount.integerValue);
    self.paymentsTitleLabel.text = [NSString stringWithFormat:@"%d %@", _price.creditPaymentsCount.intValue, paymentTitle];

    NSNumber *priceNumber = [JRSDKModelUtils creditPaymentInUserCurrencyForPrice:_price];

    self.paymentsLabel.text = [NSString stringWithFormat:@"%@ / %@", [AviasalesNumberUtil formatPrice:priceNumber], NSLS(@"JR_TICKET_CREDIT_ALERT_MONTH")];

    self.creditDurationTitleLabel.text = NSLS(@"JR_TICKET_CREDIT_ALERT_DURATION");

    NSString *monthKey = [NSString stringWithFormat:@"JR_TICKET_CREDIT_MONTH_%lu", (long)[DateUtil monthNumber:_price.creditLastPaymentDate]];
    self.creditDurationLabel.text = [NSString stringWithFormat:@"%@ %lu %@", NSLS(@"JR_TICKET_CREDIT_ALERT_TILL"), (long)[DateUtil dayOfMonthNumber:_price.creditLastPaymentDate], NSLS(monthKey)];

    self.overpaymentTitleLabel.text = NSLS(@"JR_TICKET_CREDIT_ALERT_OVERPAYMENT");
    self.overpaymentLabel.text = [NSString stringWithFormat:@"%g%% %@", _price.creditOverpaymentPercent.floatValue, NSLS(@"JR_TICKET_CREDIT_ALERT_OVERPAYMENT_SUFFIX")];

    self.gracePeriodTitleLabel.text = NSLS(@"JR_TICKET_CREDIT_ALERT_GRACE_PERIOD");

    NSString *gracePeriodDays = NSLSP(@"JR_TICKET_CREDIT_ALERT_DAYS", _price.creditGracePeriod.integerValue);
    self.gracePeriodLabel.text = [NSString stringWithFormat:@"%ld %@", (long)_price.creditGracePeriod.integerValue, gracePeriodDays];
}

#pragma mark - Public Actions

- (void)show {
    if (_alertWindow) {
        return;
    }

    UIApplication *application = [UIApplication sharedApplication];
    _prevKeyWindow = [application keyWindow];
    if (!_prevKeyWindow) {
        _prevKeyWindow = [[application windows] firstObject];
        [_prevKeyWindow makeKeyAndVisible];
    }

    _alertWindow = [[UIWindow alloc] initWithFrame:_prevKeyWindow.frame];
    _alertWindow.backgroundColor = [UIColor clearColor];
    _alertWindow.rootViewController = self;
    [_alertWindow setWindowLevel:UIWindowLevelAlert];

    self.overlayView = [JROverlayView showInView:self.view];
    self.overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view insertSubview:self.alertContainerView aboveSubview:self.overlayView];

    self.overlayView.hidden = NO;

    _alertWindow.hidden = NO;
    [_alertWindow makeKeyAndVisible];

    [self attachPopUpAnimation];

    self.view.alpha = 0;
    [UIView animateWithDuration:0.225 animations:^{
        self.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        if (UIAccessibilityIsVoiceOverRunning()) {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, self.alertContainerView);
        }
    }];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (!_alertWindow) {
        return;
    }

    if (animated) {
        [self detachPopUpAnimation];
    }

    [UIView animateWithDuration:animated ? 0.225 : 0 animations:^{
        self.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.overlayView hide];

        self.alertWindow.hidden = YES;
        [self.prevKeyWindow makeKeyAndVisible];

        self.alertWindow = nil;
        self.prevKeyWindow = nil;
        self.overlayView = nil;

        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Actions

- (IBAction)dismissAction {
    [_hiddenWebView stopLoading];
    _hiddenWebView.delegate = nil;

    [self dismissAnimated:YES completion:nil];
}

- (IBAction)buyAction {
    self.buyInCreditButton.alpha = 0;
    self.purchaseActivityIndicatorView.alpha = 1;

    [self requestBuyUrl];
}

#pragma mark - Rotations

- (BOOL)shouldAutorotate {
    return [[_prevKeyWindow topMostController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [[_prevKeyWindow topMostController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[_prevKeyWindow topMostController] preferredInterfaceOrientationForPresentation];
}

#pragma mark - Animations

- (void)attachPopUpAnimation {
    [self.alertContainerView.layer addAnimation:[CAAnimation attachPopUpAnimation] forKey:@"popup"];
}

- (void)detachPopUpAnimation {
    [self.alertContainerView.layer addAnimation:[CAAnimation detachPopUpAnimation] forKey:@"popup"];
}

#pragma mark - Network

- (void)requestBuyUrl {
    _purchasePerformer = [[AviasalesSDKPurchasePerformer alloc] initWithPrice:_price searchId:_searchId];
    [_purchasePerformer performWithDelegate:self];
}

- (void)purchasePerformer:(AviasalesSDKPurchasePerformer *)performer didFinishWithURLRequest:(NSURLRequest *)URLRequest {
    _purchaseURL = URLRequest.URL;
    
    if (!_hiddenWebView) {
        _hiddenWebView = [[UIWebView alloc] init];
        _hiddenWebView.delegate = self;
    }
    
    [_hiddenWebView loadRequest:[[NSURLRequest alloc] initWithURL:_purchaseURL]];
}

- (void)purchasePerformer:(AviasalesSDKPurchasePerformer *)performer didFailWithError:(NSError *)error {
    [self gotError:error];
}

- (void)gotError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLS(@"JR_ERROR_TITLE")
                                                        message:error.localizedDescription
                                                       delegate:self
                                              cancelButtonTitle:NSLS(@"JR_CANCEL_TITLE")
                                              otherButtonTitles:NSLS(@"JR_TRY_AGAIN_TITLE"), nil];
    
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    [self requestBuyUrl];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (_foundURLToOpen) {
        return NO;
    }

    if ([request.URL.scheme rangeOfString:@"http"].length) {
        return YES;
    }

    if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
        _foundURLToOpen = YES;

        [self dismissAnimated:YES completion:^{
            [self.delegate purchaseInCreditAlert:self didTapPurchaseTicketWithPrice:_price purchaseURL:request.URL];
        }];

        return NO;
    }

    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error.domain isEqualToString:NSURLErrorDomain]) {
        [self gotError:error];

        self.buyInCreditButton.alpha = 1;
        self.purchaseActivityIndicatorView.alpha = 0;
    }
}

@end