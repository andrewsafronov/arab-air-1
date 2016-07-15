//
//  ASTResults.m
//  AviasalesSDKTemplate
//
//  Created by Seva Billevich on 28.10.13.
//  Copyright (c) 2013 Go Travel Un Limited. All rights reserved.
//

#import "ASTResults.h"

#import "ASTResultsTicketCell.h"

#import "JRFilter.h"
#import "JRNavigationController.h"

#import "ASTSearchParams.h"

#import "JRTicketVC.h"

#import "ASTSearchResultsList.h"
#import "ASTAdvertisementManager.h"
#import "ASTTableManagerUnion.h"
#import "ASTAdvertisementTableManager.h"
#import <Appodeal/AppodealNativeAdView.h>
#import "JRViewController+JRScreenScene.h"
#import "JRScreenScene.h"
#import "UIViewController+JRScreenSceneController.h"
#import "Constants.h"
#import "JRSearchInfoUtils.h"

static const NSInteger kAppodealAdIndex = 3;
static const NSInteger kAviasalesAdIndex = 0;
static const CGFloat kBottomTableInset = 44;
static NSString *fullDirectionIATAStringForSearchInfo(id<JRSDKSearchInfo> searchInfo);

@interface ASTResults () <ASTSearchResultsListDelegate, JRFilterDelegate>

@property (strong, nonatomic) ASTSearchResultsList *resultsList;
@property (strong, nonatomic) ASTAdvertisementTableManager *ads;
@property (strong, nonatomic) ASTTableManagerUnion *tableManager;
@property (strong, nonatomic) id<JRSDKSearchInfo> searchInfo;
@property (strong, nonatomic) id<JRSDKSearchResult> response;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (assign, nonatomic) BOOL appodealAdLoaded;

- (void)updateCurrencyButton;

@end

@implementation ASTResults {
    NSArray *_currencies;
}

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo response:(id<JRSDKSearchResult>)response {
    if (self = [super init]) {
        _searchInfo = searchInfo;
        _response = response;
        
        _filter = [[JRFilter alloc] initWithSearchResults:response withSearchInfo:searchInfo];
        _filter.delegate = self;

        _currencies = [[AviasalesSDK sharedInstance].availableCurrencyCodes sortedArrayUsingSelector:@selector(compare:)];

        _resultsList = [[ASTSearchResultsList alloc] initWithCellNibName:[ASTResultsTicketCell nibFileName]];
        _resultsList.delegate = self;

        _ads = [[ASTAdvertisementTableManager alloc] init];

        _tableManager = [[ASTTableManagerUnion alloc] initWithFirstManager:_resultsList secondManager:_ads secondManagerPositions:[NSIndexSet indexSet]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self.tableManager;
    self.tableView.delegate = self.tableManager;
    [self updateResultTableViewAppearance];

    [_filters setTitle:AVIASALES_(@"AVIASALES_FILTERS")];
    [_emptyLabel setText:AVIASALES_(@"AVIASALES_FILTERS_EMPTY")];
    
    [self updateTitle];
    [self updateCurrencyButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.appodealAdLoaded) {
        self.appodealAdLoaded = YES;
        __weak typeof(self) bself = self;
        
        [[ASTAdvertisementManager sharedInstance] viewController:self loadNativeAdWithSize:(CGSize){self.view.bounds.size.width, [ASTAdvertisementTableManager appodealAdHeight]} ifNeededWithCallback:^(AppodealNativeAdView *adView) {
            [bself didLoadAd:adView];
        }];

        [[ASTAdvertisementManager sharedInstance] loadAviasalesAdWithSearchInfo:self.searchInfo ifNeededWithCallback:^(UIView *adView) {
            [bself didLoadAviasalesAd:adView];
        }];
    }

    NSIndexPath *const selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
    
    if (self.response.strictSearchTickets.count == 0 && self.response.searchTickets.count > 0) {
        [self alertUserAboutFullResultsDisplay];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.emptyView.hidden = !(self.filter.filteredTickets.count == 0);
}

#pragma mark - <ASTSearchResultsListDelegate>

- (NSArray<id<JRSDKTicket>> *)tickets {
    return self.filter.filteredTickets.array;
}

- (void)didSelectTicketAtIndex:(NSInteger)index {
    JRTicketVC *const ticketVC = [[JRTicketVC alloc] initWithNibName:@"JRTicketVC" bundle:AVIASALES_BUNDLE];
    ticketVC.ticket = [[self tickets] objectAtIndex:index];
    ticketVC.searchId = self.response.searchID;
    ticketVC.searchInfo = self.searchInfo;

    UIBarButtonItem *const backButton = [[UIBarButtonItem alloc] initWithTitle:AVIASALES_(@"AVIASALES_BACK") style:UIBarButtonItemStylePlain target:nil action:nil];
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:AVIASALES_(@"AVIASALES_CURRENCY") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    for (JRSDKCurrency currency in _currencies) {
        [sheet addButtonWithTitle:[NSString stringWithFormat:@"%@ - %@", [currency uppercaseString], [currentLocale displayNameForKey:NSLocaleCurrencyCode value:currency]]];
    }
    
    [sheet addButtonWithTitle:AVIASALES_(@"AVIASALES_CANCEL")];
    sheet.cancelButtonIndex = [_currencies count];
    [sheet showInView:self.view];
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
    
    NSString *code = [_currencies objectAtIndex:buttonIndex];
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
    [_currencyButton setTitle:[NSString stringWithFormat:@"%@: %@", AVIASALES_(@"AVIASALES_CURRENCY"), [[[AviasalesSDK sharedInstance] currencyCode] uppercaseString]]];
}

- (void)updateTitle {
    id<JRSDKTravelSegment> const firstTravelSegment = _searchInfo.travelSegments.firstObject;
    JRSDKIATA const firstIATA = firstTravelSegment.originAirport.iata;
    JRSDKIATA const lastIATA = _searchInfo.travelSegments.count == 1 ? firstTravelSegment.destinationAirport.iata : _searchInfo.travelSegments.lastObject.originAirport.iata;
    NSString *const formattedDates = [JRSearchInfoUtils formattedDatesForSearchInfo:_searchInfo];
    self.title = [NSString stringWithFormat:@"%@ – %@, %@", firstIATA, lastIATA, formattedDates];
}

- (void)updateResultTableViewAppearance {
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, kBottomTableInset, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomTableInset, 0);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0, 10}];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRect){0, 0, 0, 9}];
    self.tableView.sectionHeaderHeight = 9;
    self.tableView.sectionFooterHeight = 1;
}

#pragma mark - JRFilterDelegate

- (void)filterDidUpdateFilteredObjects {
    [self.tableView reloadData];
}

#pragma mark - Advertisement

- (void)didLoadAd:(UIView *)adView {
    if (adView == nil) {
        return;
    }

    NSArray<UIView *> *ads = self.ads.ads ?: @[];
    ads = [ads arrayByAddingObject:adView];

    NSMutableIndexSet *const indexSet = [[NSMutableIndexSet alloc] initWithIndex:kAppodealAdIndex];
    if (ads.count > 1) {
        [indexSet addIndex:kAviasalesAdIndex];
    }

    [self updateAdsTableWithAds:ads atIndexes:[indexSet copy]];
}

- (void)didLoadAviasalesAd:(UIView *)adView {
    if (adView == nil) {
        return;
    }
    NSMutableArray<UIView *> *const ads = [self.ads.ads ?: @[] mutableCopy];
    [ads insertObject:adView atIndex:0];

    NSMutableIndexSet *const indexSet = [[NSMutableIndexSet alloc] initWithIndex:kAviasalesAdIndex];
    if (ads.count > 1) {
        [indexSet addIndex:kAppodealAdIndex];
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
                                          cancelButtonTitle:NSLS(@"ALERT_DEFAULT_BUTTON")
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
