//
//  JRSearchResultsVC.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchResultsVC.h"

#import "JRResultsTicketCell.h"

#import "JRFilter.h"
#import "JRNavigationController.h"

#import "JRTicketVC.h"

#import "JRSearchResultsList.h"
#import "JRAdvertisementManager.h"
#import "JRTableManagerUnion.h"
#import "JRAdvertisementTableManager.h"
#import "JRViewController+JRScreenScene.h"
#import "JRScreenScene.h"
#import "UIViewController+JRScreenSceneController.h"
#import "JRConstants.h"
#import "JRSearchInfoUtils.h"
#import "JRSearchResultsFlightSegmentCellLayoutParameters.h"
#import "JRNewsFeedNativeAdView.h"

static const NSInteger kJRAppodealAdIndex = 3;
static const NSInteger kJRAviasalesAdIndex = 0;
static const CGFloat kJRBottomTableInset = 44;

static NSString *fullDirectionIATAStringForSearchInfo(id<JRSDKSearchInfo> searchInfo);

@interface JRSearchResultsVC () <JRSearchResultsListDelegate, JRFilterDelegate>

@property (strong, nonatomic) JRSearchResultsList *resultsList;
@property (strong, nonatomic) JRAdvertisementTableManager *ads;
@property (strong, nonatomic) JRTableManagerUnion *tableManager;
@property (strong, nonatomic) id<JRSDKSearchInfo> searchInfo;
@property (strong, nonatomic) id<JRSDKSearchResult> response;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (assign, nonatomic) BOOL appodealAdLoaded;
@property (assign, nonatomic) BOOL needShowAlertUserAboutFullResults;

@property (strong, nonatomic) JRSearchResultsFlightSegmentCellLayoutParameters *flightSegmentLayoutParameters;

- (void)updateCurrencyButton;

@end

@implementation JRSearchResultsVC {
    NSArray *_currencies;
    NSArray *_pickerCurrencies;
}

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo response:(id<JRSDKSearchResult>)response {
    if (self = [super init]) {
        _searchInfo = searchInfo;
        _response = response;

        const BOOL strictMode =  response.strictSearchTickets.count != 0;
        _needShowAlertUserAboutFullResults = !strictMode && response.searchTickets.count > 0;

        if (strictMode) {
            _filter = [[JRFilter alloc] initWithTickets:response.strictSearchTickets searchInfo:searchInfo];
        } else {
            _filter = [[JRFilter alloc] initWithTickets:response.searchTickets searchInfo:searchInfo];
        }

        _filter.delegate = self;

        _currencies = [[AviasalesSDK sharedInstance].availableCurrencyCodes sortedArrayUsingSelector:@selector(compare:)];

        _resultsList = [[JRSearchResultsList alloc] initWithCellNibName:[JRResultsTicketCell nibFileName]];
        _resultsList.flightSegmentLayoutParameters = [JRSearchResultsFlightSegmentCellLayoutParameters parametersWithTickets:self.tickets font:[UIFont systemFontOfSize:12]];
        _resultsList.delegate = self;

        _ads = [[JRAdvertisementTableManager alloc] init];

        _tableManager = [[JRTableManagerUnion alloc] initWithFirstManager:_resultsList secondManager:_ads secondManagerPositions:[NSIndexSet indexSet]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self.tableManager;
    self.tableView.delegate = self.tableManager;
    [self updateResultTableViewAppearance];

    [_filters setTitle:AVIASALES_(@"JR_FILTER_BUTTON")];
    [_emptyLabel setText:AVIASALES_(@"JR_SEARCH_RESULTS_TICKET_PLACEHOLDER_TEXT")];
        
    if (iPad()) {
        NSMutableArray *items = [self.toolbar.items mutableCopy];
        [items removeObject:self.filters];
        self.toolbar.items = items;
    }
    
    [self updateTitle];
    [self updateCurrencyButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.emptyView.hidden = (self.filter.filteredTickets.count != 0);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.appodealAdLoaded) {
        self.appodealAdLoaded = YES;
        __weak typeof(self) bself = self;
        const CGSize adSize = (CGSize){self.view.bounds.size.width, [JRAdvertisementTableManager appodealAdHeight]};
        [[JRAdvertisementManager sharedInstance] viewController:self loadNativeAdWithSize:adSize ifNeededWithCallback:^(JRNewsFeedNativeAdView *adView) {
            [bself didLoadAd:adView];
        }];

        [[JRAdvertisementManager sharedInstance] loadAviasalesAdWithSearchInfo:self.searchInfo ifNeededWithCallback:^(UIView *adView) {
            [bself didLoadAviasalesAd:adView];
        }];
    }

    NSIndexPath *const selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
    
    if (self.needShowAlertUserAboutFullResults) {
        [self alertUserAboutFullResultsDisplay];
        
        self.needShowAlertUserAboutFullResults = NO;
    }
}

#pragma mark - <JRSearchResultsListDelegate>

- (NSArray<id<JRSDKTicket>> *)tickets {
    return self.filter.filteredTickets.array;
}

- (void)didSelectTicketAtIndex:(NSInteger)index {
    JRTicketVC *const ticketVC = [[JRTicketVC alloc] initWithNibName:@"JRTicketVC" bundle:AVIASALES_BUNDLE];
    ticketVC.ticket = [[self tickets] objectAtIndex:index];
    ticketVC.searchId = self.response.searchID;
    ticketVC.searchInfo = self.searchInfo;

    UIBarButtonItem *const backButton = [[UIBarButtonItem alloc] initWithTitle:AVIASALES_(@"JR_BACK_TITLE") style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    if (iPhone()) {
        [self.navigationController pushViewController:ticketVC animated:YES];
    } else {
        JRScreenScene *const scene = [JRScreenSceneController screenSceneWithMainViewController:ticketVC
                                                                                          width:[JRScreenSceneController screenSceneControllerWideViewWidth]
                                                                        accessoryViewController:nil
                                                                                          width:kNilOptions
                                                                                 exclusiveFocus:NO];
        [self.sceneViewController pushScreenScene:scene animated:YES];
    }
}

#pragma mark - Actions

- (void)showCurrenciesList:(id)sender {
    [self showCurrenciesListIncludingAdditionalCurrencies:NO];
}

- (void)showCurrenciesListIncludingAdditionalCurrencies:(BOOL)includeAdditionalCurrencies {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:AVIASALES_(@"CURRENCY") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    _pickerCurrencies = includeAdditionalCurrencies ? _currencies : [AVIASALES_CURRENCIES sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (JRSDKCurrency currency in _pickerCurrencies) {
        NSString *currencyName = [currentLocale displayNameForKey:NSLocaleCurrencyCode value:currency];
        
        // Workaround for BYN:
        if (currencyName == nil && [currency isEqualToString:@"byn"]) {
            currencyName = [currentLocale displayNameForKey:NSLocaleCurrencyCode value:@"byr"];
        }
        
        [sheet addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@", [currency uppercaseString], currencyName]];
    }
    
    if (includeAdditionalCurrencies) {
        [sheet addButtonWithTitle:AVIASALES_(@"JR_CANCEL_TITLE")];
        sheet.cancelButtonIndex = [_pickerCurrencies count];
    } else {
        [sheet addButtonWithTitle:AVIASALES_(@"JR_TICKET_OTHER_BUTTON")];
        [sheet addButtonWithTitle:AVIASALES_(@"JR_CANCEL_TITLE")];
        sheet.cancelButtonIndex = [_pickerCurrencies count] + 1;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sheet showInView:self.view];
    });
}

- (void)showFilters:(id)sender {
    if (iPhone()) {
        JRFilterMode mode = [JRSDKModelUtils isSimpleSearch:self.searchInfo] ? JRFilterSimpleSearchMode : JRFilterComplexMode;
        JRFilterVC *filterVC = [[JRFilterVC alloc] initWithFilter:self.filter forFilterMode:mode selectedTravelSegment:nil];
        JRNavigationController *filtersNavigationVC = [[JRNavigationController alloc] initWithRootViewController:filterVC];
        [self presentViewController:filtersNavigationVC animated:YES completion:nil];
    }
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:AVIASALES_(@"JR_TICKET_OTHER_BUTTON")]) {
        [self showCurrenciesListIncludingAdditionalCurrencies:YES];
        return;
    }
    
    NSString *code = [_pickerCurrencies objectAtIndex:buttonIndex];
    [[AviasalesSDK sharedInstance] updateCurrencyCode:code];
    
    [self.tableView reloadData];
    [self updateCurrencyButton];
}

#pragma mark - Private methods

- (void)updateToolbar {
    if ([self scene]) {
        UIBarButtonItem *const space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolbar.items = @[space, _currencyButton];
    }
}

- (void)updateCurrencyButton {
    [_currencyButton setTitle:[NSString stringWithFormat:@"%@: %@", AVIASALES_(@"CURRENCY"), [[[AviasalesSDK sharedInstance] currencyCode] uppercaseString]]];
}

- (void)updateTitle {
    NSString *const formattedIATAs = [JRSearchInfoUtils formattedIatasForSearchInfo:_searchInfo];
    NSString *const formattedDates = [JRSearchInfoUtils formattedDatesForSearchInfo:_searchInfo];
    self.title = [NSString stringWithFormat:@"%@, %@", formattedIATAs, formattedDates];
}

- (void)updateResultTableViewAppearance {
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kJRBottomTableInset, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kJRBottomTableInset, 0);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0, 10}];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0, 9}];
    self.tableView.sectionHeaderHeight = 9;
    self.tableView.sectionFooterHeight = 1;
}

#pragma mark - JRFilterDelegate

- (void)filterDidUpdateFilteredObjects {
    [self.tableView reloadData];
    self.tableView.contentOffset = CGPointZero;
}

#pragma mark - Advertisement

- (void)didLoadAd:(UIView *)adView {
    if (adView == nil) {
        return;
    }

    NSArray<UIView *> *ads = self.ads.ads ?: @[];
    ads = [ads arrayByAddingObject:adView];

    NSMutableIndexSet *const indexSet = [[NSMutableIndexSet alloc] initWithIndex:kJRAppodealAdIndex];
    if (ads.count > 1) {
        [indexSet addIndex:kJRAviasalesAdIndex];
    }

    [self updateAdsTableWithAds:ads atIndexes:[indexSet copy]];
}

- (void)didLoadAviasalesAd:(UIView *)adView {
    if (adView == nil) {
        return;
    }
    NSMutableArray<UIView *> *const ads = [self.ads.ads ?: @[] mutableCopy];
    [ads insertObject:adView atIndex:0];

    NSMutableIndexSet *const indexSet = [[NSMutableIndexSet alloc] initWithIndex:kJRAviasalesAdIndex];
    if (ads.count > 1) {
        [indexSet addIndex:kJRAppodealAdIndex];
    }

    [self updateAdsTableWithAds:ads atIndexes:[indexSet copy]];
}

- (void)updateAdsTableWithAds:(NSArray<UIView *> *)ads atIndexes:(NSIndexSet *)indexes {
    self.ads.ads = ads;
    self.tableManager.secondManagerPositions = indexes;

    [self.tableView reloadData];
}

- (void)alertUserAboutFullResultsDisplay {
    NSString *const iatas = fullDirectionIATAStringForSearchInfo(self.searchInfo);
    NSString *const alertMessage = [NSString stringWithFormat:NSLS(@"JR_SEARCH_RESULTS_NON_STRICT_MATCHED_ALERT_MESSAGE"), iatas];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"JR_BROWSER_ERROR_ALERT_TITLE")
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:NSLS(@"JR_OK_BUTTON")
                                          otherButtonTitles:nil];
    [alert show];
}

@end
    

static NSString *fullDirectionIATAStringForSearchInfo(id<JRSDKSearchInfo> searchInfo) {
    NSMutableString *directionString = [NSMutableString string];
    for (JRTravelSegment *travelSegment in searchInfo.travelSegments) {
        if (travelSegment != searchInfo.travelSegments.firstObject) {
            [directionString appendString:@"  "];
        }
        [directionString appendFormat:@"%@—%@", travelSegment.originAirport.iata, travelSegment.destinationAirport.iata];
    }
    return directionString;
}
