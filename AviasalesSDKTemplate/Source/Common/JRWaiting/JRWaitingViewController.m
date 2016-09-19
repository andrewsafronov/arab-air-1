//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//


#import "JRWaitingViewController.h"
#import "JRAdvertisementManager.h"
#import "JRColorScheme.h"
#import "JRSearchInfo.h"
#import "NSTimer+WeakTarget.h"

static const NSTimeInterval kSearchTime = 40;
static const NSTimeInterval kProgressUpdateInterval = 0.1;
static const NSTimeInterval kAviasalesAdsAnimationDuration = 0.3;

@interface JRWaitingViewController () <JRSDKSearchPerformerDelegate>

@property (nonatomic, weak) IBOutlet UIView *waitingView;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (strong, nonatomic) JRSDKSearchPerformer *searchPerformer;
@property (nonatomic, weak) IBOutlet UIView *aviasalesAdContainerView;
@property (nonatomic, weak) IBOutlet UIView *appodealAdContainerView;
@property (nonatomic, strong) id <JRSDKSearchInfo> searchInfo;
@property (nonatomic, assign) BOOL didRequestAd;

//Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *aviasalesAdsBottom;

@end

@implementation JRWaitingViewController

- (instancetype)initWithSearchInfo:(id <JRSDKSearchInfo>)searchInfo {
    if (self = [super init]) {
        _searchInfo = searchInfo;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.waitingView.backgroundColor = iPhone() ? [JRColorScheme mainBackgroundColor] : [JRColorScheme lightBackgroundColor];
    [[JRAdvertisementManager sharedInstance] presentVideoAdInViewIfNeeded:self.appodealAdContainerView rootViewController:self];

    [self.progressLabel setText:AVIASALES_(@"JR_WAITING_TITLE")];
    [self.progressView setProgress:0];
    self.progressView.progressTintColor = [JRColorScheme darkTextColor];

    self.progressTimer = [NSTimer timerWithTimeInterval:kProgressUpdateInterval weakTarget:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];

    [self.waitingView removeConstraint:self.aviasalesAdsBottom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self requestAdIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateProgress {
    self.progressView.progress += kProgressUpdateInterval / kSearchTime;
    if (_progressView.progress >= 1) {
        [_progressTimer invalidate];
    }
}

- (void)dealloc {
    [self.searchPerformer terminateSearch];
    [_progressTimer invalidate];
}

- (void)performSearch {
    NSAssert(self.searchPerformer == nil, @"Current waiting view controller already performing search");

    JRSDKSearchPerformer *const searchPerformer = [[AviasalesSDK sharedInstance] createSearchPerformer];
    self.searchPerformer = searchPerformer;
    searchPerformer.delegate = self;

    [self.searchPerformer performSearchWithSearchInfo:self.searchInfo
                              includeResultsInEnglish:YES];
}

- (void)finish {
    [_progressView setProgress:1 animated:YES];

    [UIView animateWithDuration:0.5f animations:^{
        [_waitingView setAlpha:0];
    } completion:^(BOOL finished) {
        [_waitingView removeFromSuperview];
    }];
}

- (void)requestAdIfNeeded {
    if (self.didRequestAd) {
        return;
    }

    self.didRequestAd = YES;

    __weak typeof(self) weakSelf = self;
    [[AviasalesSDK sharedInstance].adsManager loadAdsViewForWaitingScreenWithSearchInfo:self.searchInfo completion:^(AviasalesSDKAdsView * _Nullable adsView, NSError * _Nullable error) {
        typeof(self) sSelf = weakSelf;
        if (sSelf && !error && adsView) {
            [adsView placeIntoView:sSelf.aviasalesAdContainerView];
            [sSelf.waitingView addConstraint:sSelf.aviasalesAdsBottom];
            [UIView animateWithDuration:kAviasalesAdsAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [sSelf.waitingView layoutIfNeeded];
            } completion:nil];
        }
    }];
}

+ (NSString *)nibFileName {
    return @"JRWaitingViewController";
}

#pragma mark - <JRSDKSearchPerformerDelegate>
- (void)searchPerformer:(JRSDKSearchPerformer *)searchPerformer didFinishRegularSearch:(id<JRSDKSearchInfo>)searchInfo withResult:(id<JRSDKSearchResult>)result {
    [self.delegate waitingViewController:self
                 didFinishSearchWithInfo:searchInfo
                                  result:result];
}

- (void)searchPerformer:(JRSDKSearchPerformer *)searchPerformer didFailSearchWithError:(NSError *)error {
    [self.delegate waitingViewController:self didFinishSearchWithError:error];
}

- (void)searchPerformer:(JRSDKSearchPerformer *)searchPerformer didFinalizeSearchWithInfo:(id<JRSDKSearchInfo>)searchInfo error:(NSError *)error {
    NSLog(@"search did completely finished");
}
@end
