//
//  ASTResults.m
//  AviasalesSDKTemplate
//
//  Created by Seva Billevich on 28.10.13.
//  Copyright (c) 2013 Go Travel Un Limited. All rights reserved.
//

#import "ASTResults.h"

#import "ASTResultsTicketCell.h"

#import "JRTicketVC.h"
#import "ASTFilters.h"
#import <AviasalesSDK/AviasalesFilter.h>

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

@interface ASTResults () <ASTSearchResultsListDelegate, ASTFiltersDelegate>

@property (strong, nonatomic) ASTSearchResultsList *resultsList;
@property (strong, nonatomic) ASTAdvertisementTableManager *ads;
@property (strong, nonatomic) ASTTableManagerUnion *tableManager;
@property (assign, nonatomic) BOOL appodealAdLoaded;
@property (strong, nonatomic) id<JRSDKSearchInfo> searchInfo;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) id<JRSDKSearchResult> response;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKTicket>> *searchResult;

- (void)updateCurrencyButton;
- (NSArray *)filteredTickets;

@end

@implementation ASTResults {
    NSArray *_currencies;
    ASTFilters *_filtersVC;
    UINavigationController *_filtersNavigationVC;
    AviasalesFilter *_filter;
    NSArray *_tickets;
}

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                          response:(id<JRSDKSearchResult>)response {
    self = [self initWithSearchInfo:searchInfo response:response filterVC:nil];
    return self;
}

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                          response:(id<JRSDKSearchResult>)response
                          filterVC:(ASTFilters *)filterVC {
    if (self = [super init]) {
        _searchInfo = searchInfo;
        _response = response;
        _searchResult = response.strictSearchTickets;
        _filtersVC = filterVC;
        _currencies = [[AviasalesSDK sharedInstance].availableCurrencyCodes sortedArrayUsingSelector:@selector(compare:)];

        _resultsList = [[ASTSearchResultsList alloc] initWithCellNibName:[ASTResultsTicketCell nibFileName]];
        _resultsList.delegate = self;

        _ads = [[ASTAdvertisementTableManager alloc] init];

        _tableManager = [[ASTTableManagerUnion alloc] initWithFirstManager:_resultsList secondManager:_ads secondManagerPositions:[NSIndexSet indexSet]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self.tableManager;
    self.tableView.delegate = self.tableManager;
    [self updateResultTableViewAppearance];

    
    [_filters setTitle:AVIASALES_(@"AVIASALES_FILTERS")];
    [_emptyLabel setText:AVIASALES_(@"AVIASALES_FILTERS_EMPTY")];
    
    [self updateTitle];
    [self updateCurrencyButton];
    [self updateTableWithTickets:self.searchResult];
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
    
    if (self.searchResult.count == 0 && self.response.searchTickets.count > 0) {
        [self alertUserAboutFullResultsDisplay];
        self.searchResult = self.response.searchTickets;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateToolbar];
    
    if (_filter.needFiltering && [self.filteredTickets count] == 0) {
        [_emptyView setHidden:NO];
    } else {
        [_emptyView setHidden:YES];
    }
}

- (void)setSearchResult:(NSOrderedSet<id<JRSDKTicket>> *)searchResult {
    _searchResult = searchResult;
    [self updateTableWithTickets:searchResult];
}

- (void)updateTableWithTickets:(NSOrderedSet<id<JRSDKTicket>> *)searchResult {
    _tickets = nil;
    [self.tableView reloadData];

    _filter = [[AviasalesFilter alloc] init];
//    [_filter setResponse:_response]; //FIXME:
    [_filter setDelegate:self];

    if (_filtersVC == nil) {
        NSString *xibName = @"ASTFilters";
        if (AVIASALES_VC_GRANDPA_IS_TABBAR) {
            xibName = @"ASTFiltersTabBar";
        }

        _filtersVC = [[ASTFilters alloc] initWithNibName:xibName bundle:AVIASALES_BUNDLE];
    }

    _filtersVC.delegate = self;
    
    [_filtersVC setFilter:_filter];
//    [_filtersVC setTickets:[self filteredTickets]];//FIXME:
}

#pragma mark - <ASTSearchResultsListDelegate>


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
    if ([self scene]) {
        JRScreenScene *const currentScene = self.scene;
        [currentScene attachAccessoryViewController:_filtersVC portraitWidth:kViewControllerWidthIPadPortraitHalfScreen landscapeWidth:kViewControllerWidthIPadLandscapeHalfScreen exclusiveFocus:NO animated:YES];
    } else {
        if (_filtersNavigationVC == nil) {
            _filtersNavigationVC = [[UINavigationController alloc] initWithRootViewController:_filtersVC];
        }
        [self presentViewController:_filtersNavigationVC animated:YES completion:nil];
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

- (NSArray *)filteredTickets {
    return _filter.needFiltering && !_filter.filteringInProgress ? _filter.filteredTickets : [self.searchResult array];
}

- (NSArray*) tickets {
    if (_tickets) {
        return _tickets;
    }
    
    return _tickets = [self filteredTickets];
}

#pragma mark - AviasalesFilter delegate

- (void)filteringProccessFinished {
    _tickets = nil;
    [_tableView reloadData];
    [_filtersVC setTickets:[self filteredTickets]];
}

- (void)needReloadFilter {
    [_filtersVC buildTable];
    [_filtersVC.tableView reloadData];
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
                                          otherButtonTitles: nil];
    [alert show];
}

#pragma mark - <ASTFiltersDelegate>
- (void)filtersDidFinishFiltering:(ASTFilters *)filters {
    if (filters != _filtersVC) {
        return;
    }

    if (![self scene]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // no need to remove filters from screen
    }
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
