//
//  JRTicketVC.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTicketVC.h"

#import "JRFlightCell.h"
#import "JRTransferCell.h"
#import "JRFlightsSegmentHeaderView.h"

#import "JRSearchInfoUtils.h"

#import "JRInfoPanelView.h"
#import "JRGateBrowserVC.h"
#import "JRPurchaseInCreditAlert.h"
#import "JRPriceUtils.h"

#import "NSLayoutConstraint+JRConstraintMake.h"

static const CGFloat kFlightCellHeight = 180.0;
static const CGFloat kTransforCellHeight = 56.0;
static const CGFloat kFlightsSegmentHeaderHeight = 55.0;

static const CGFloat kOffsetLimit = 40.0;
static const CGFloat kInfoPanelViewMaxHeightConstraint = 120.0;


@interface JRTicketVC () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, JRPurchaseInCreditAlertDelegate>

@property (nonatomic, strong) JRInfoPanelView *infoPanelView;

@property (nonatomic, weak) IBOutlet UIView *infoPanelContainerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *infoPanelViewHeightConstraint;

@end


@implementation JRTicketVC

#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINib *flightCellNib = [UINib nibWithNibName:@"JRFlightCell" bundle:AVIASALES_BUNDLE];
    UINib *transferCellNib = [UINib nibWithNibName:@"JRTransferCell" bundle:AVIASALES_BUNDLE];
    UINib *flightsSegmentHeaderNib = [UINib nibWithNibName:@"JRFlightsSegmentHeaderView" bundle:AVIASALES_BUNDLE];
    [self.tableView registerNib:flightCellNib forCellReuseIdentifier:@"JRFlightCell"];
    [self.tableView registerNib:transferCellNib forCellReuseIdentifier:@"JRTransferCell"];
    [self.tableView registerNib:flightsSegmentHeaderNib forHeaderFooterViewReuseIdentifier:@"JRFlightsSegmentHeaderView"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self updateTitle];

    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

    typeof(self) __weak weakSelf = self;
    self.infoPanelView = LOAD_VIEW_FROM_NIB_NAMED(@"JRInfoPanelView");
    self.infoPanelView.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoPanelView.buyHandler = ^() {
        [weakSelf buyTicketWithPrice:weakSelf.ticket.prices.firstObject];
    };
    self.infoPanelView.showOtherAgencyHandler = ^() {
        [weakSelf showOtherAgencies];
    };
    self.infoPanelView.buyInCreditHandler = ^() {
        [weakSelf purchaseTicketInCredit];
    };
    [self.infoPanelContainerView addSubview:self.infoPanelView];
    [self.infoPanelContainerView addConstraints:JRConstraintsMakeScaleToFill(self.infoPanelView, self.infoPanelContainerView)];

    [self updateContent];
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - Public methods

- (void)updateContent {
    self.infoPanelView.ticket = self.ticket;
    [self.tableView reloadData];
}

- (void)setSearchInfo:(id<JRSDKSearchInfo>)searchInfo {
    _searchInfo = searchInfo;
    [self updateTitle];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ticket.flightSegments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger const flightsCount = self.ticket.flightSegments[section].flights.count;
    
    return (flightsCount > 0) ? 2 * flightsCount - 1 : flightsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<JRTicketCellProtocol> *cell;
    NSInteger flightIndex = indexPath.row;
    
    if (indexPath.row % 2 == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JRFlightCell" forIndexPath:indexPath];
        flightIndex -= flightIndex / 2;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"JRTransferCell" forIndexPath:indexPath];
        flightIndex = (flightIndex + 1) / 2;
    }
    
    id<JRSDKFlight> const flight = self.ticket.flightSegments[indexPath.section].flights[flightIndex];
    [cell applyFlight:flight];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    JRFlightsSegmentHeaderView *header = (JRFlightsSegmentHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JRFlightsSegmentHeaderView"];
    header.flightSegment = self.ticket.flightSegments[section];
    
    return header;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        return kFlightCellHeight;
    } else {
        return kTransforCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kFlightsSegmentHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

#pragma mark - Private

- (void)updateTitle {
    NSString *const formattedIATAs = [JRSearchInfoUtils formattedIatasForSearchInfo:_searchInfo];
    NSString *const formattedDates = [JRSearchInfoUtils formattedDatesForSearchInfo:_searchInfo];
    self.title = [NSString stringWithFormat:@"%@, %@", formattedIATAs, formattedDates];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((object == self.tableView) && [keyPath isEqualToString:@"contentOffset"]) {
        CGPoint newOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        CGPoint oldOffset = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue];
        CGFloat contentHeightLimit = self.view.bounds.size.height - 102.0;

        if ((newOffset.y != oldOffset.y) && (self.tableView.contentSize.height > contentHeightLimit)) {
            [self updateInfoPanelViewWithOffset:newOffset.y];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)showOtherAgencies {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:AVIASALES_(@"JR_TICKET_BUY_IN_THE_AGENCY_BUTTON") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    for (id<JRSDKPrice> price in self.ticket.prices) {
        if ([JRSDKModelUtils priceSupportsPaymentInCredit:price]) {
            continue;
        }
        
        NSString *buttonTitle = [NSString stringWithFormat:@"%@ — %@", price.gate.label, [JRPriceUtils formattedPriceInUserCurrency:price]];
        [sheet addButtonWithTitle:buttonTitle];
    }

    sheet.cancelButtonIndex = self.ticket.prices.count;
    [sheet addButtonWithTitle:AVIASALES_(@"JR_CANCEL_TITLE")];
    [sheet showInView:self.view];
}

- (void)purchaseTicketInCredit {
    id<JRSDKPrice> creditPrice = [JRSDKModelUtils ticketCreditPrice:self.ticket];
    if (creditPrice != nil) {
        [self buyTicketWithPrice:creditPrice];
    }
}

- (void)updateInfoPanelViewWithOffset:(CGFloat)offset {
    CGFloat delta = MIN(kOffsetLimit, MAX(offset, 0.0));
    CGFloat percent = delta / kOffsetLimit;

    self.infoPanelViewHeightConstraint.constant = kInfoPanelViewMaxHeightConstraint - delta;
    self.infoPanelContainerView.layer.masksToBounds = !(percent > 0.0);

    [self.infoPanelContainerView setNeedsLayout];
    [self.infoPanelContainerView layoutIfNeeded];

    percent > 0.5 ? [self.infoPanelView collapse] : [self.infoPanelView expand];
}

- (void)buyTicketWithPrice:(id<JRSDKPrice>)price {
    if ([JRSDKModelUtils priceSupportsPaymentInCredit:price]) {
        JRPurchaseInCreditAlert *alert = [[JRPurchaseInCreditAlert alloc] initWithPrice:price searchId:self.searchId];
        alert.delegate = self;
        [alert show];
        return;
    }

    JRGateBrowserVC *browser = [[JRGateBrowserVC alloc] initWithNibName:@"JRBrowserVC" bundle:AVIASALES_BUNDLE];
    [browser setTicketPrice:price searchID:self.searchId];
    [browser presentBrowser];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.ticket.prices.count <= buttonIndex) { return; }

    id<JRSDKPrice> price = (id<JRSDKPrice>)[self.ticket.prices objectAtIndex:buttonIndex];
    [self buyTicketWithPrice:price];
}

#pragma mark - JRPurchaseInCreditAlertDelegate

- (void)purchaseInCreditAlert:(JRPurchaseInCreditAlert *)alert didTapPurchaseTicketWithPrice:(id <JRSDKPrice>)price purchaseURL:(NSURL *)purchaseURL {
    [[UIApplication sharedApplication] openURL:purchaseURL];
    [alert dismissAnimated:YES completion:nil];
}

@end
