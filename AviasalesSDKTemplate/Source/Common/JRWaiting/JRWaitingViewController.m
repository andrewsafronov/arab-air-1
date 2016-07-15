#import "JRWaitingViewController.h"
#import "ASTVideoAdPlayer.h"
#import "ASTAdvertisementManager.h"
#import "ColorScheme.h"
#import "JRSearchInfo.h"
#import "NSTimer+WeakTarget.h"

static const NSTimeInterval kSearchTime = 40;
static const NSTimeInterval kProgressUpdateInterval = 0.1;

@interface JRWaitingViewController () <JRSDKSearchPerformerDelegate>
@property (nonatomic, weak) IBOutlet UIView *waitingView;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *progressLabel;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (strong, nonatomic) id<ASTVideoAdPlayer> waitingAdPlayer;
@property (strong, nonatomic) JRSDKSearchPerformer *searchPerformer;
@property (nonatomic, weak) IBOutlet UIView *adContainerView;
@property (nonatomic, strong) id <JRSDKSearchInfo> searchInfo;
@property (nonatomic, assign) BOOL didRequestAd;
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
    self.view.backgroundColor = iPhone() ? [ColorScheme mainBackgroundColor] : [ColorScheme lightBackgroundColor];
    self.waitingAdPlayer = [[ASTAdvertisementManager sharedInstance] presentVideoAdInViewIfNeeded:self.waitingView rootViewController:self];

    [self.progressLabel setText:AVIASALES_(@"AVIASALES_SEARCHING_PROGRESS")];
    [self.progressView setProgress:0];
    self.progressView.progressTintColor = [ColorScheme darkTextColor];

    self.progressTimer = [NSTimer timerWithTimeInterval:kProgressUpdateInterval weakTarget:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_progressTimer forMode:NSRunLoopCommonModes];

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
                                          knowEnglish:YES];
}

- (void)finish {
    [_progressView setProgress:1 animated:YES];

    [UIView animateWithDuration:0.5f animations:^{
        [_waitingView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.waitingAdPlayer stop];
        [_waitingView removeFromSuperview];
    }];
}

- (void)requestAdIfNeeded {
    if (self.didRequestAd) {
        return;
    }

    self.didRequestAd = YES;

    __weak typeof(self) weakSelf = self;
    [[AviasalesSDK sharedInstance].adsManager loadAdsViewForWaitingScreenWithSearchInfo:self.searchInfo
                                                                             completion:^(AviasalesSDKAdsView * _Nullable adsView, NSError * _Nullable error) {
                                                                                 [adsView placeIntoView:weakSelf.adContainerView];
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

- (void)searchPerformer:(JRSDKSearchPerformer *)searchPerformer didFailSearchWithError:(NSError *)error connection:(JRServerAPIConnection *)connection {
    [self.delegate waitingViewController:self didFinishSearchWithError:error];
}

- (void)searchPerformer:(JRSDKSearchPerformer *)searchPerformer didFinalizeSearchWithInfo:(id<JRSDKSearchInfo>)searchInfo error:(NSError *)error {
    NSLog(@"search did completely finished");
}
@end
