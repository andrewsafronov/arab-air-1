//
//  JRFilterVC.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterVC.h"

#import "JRFilter.h"
#import "JRFilterTravelSegmentBounds.h"

#import "JRFilterItemsFactory.h"
#import "JRFilterTravelSegmentItem.h"
#import "JRFilterCheckBoxItem.h"

#import "JRFilterCellsFactory.h"
#import "JRFilterListHeaderCell.h"
#import "JRFilterTravelSegmentCell.h"
#import "JRFilterCellWithTwoThumbsSlider.h"
#import "JRFilterCheckBoxCell.h"

#import "JRColorScheme.h"
#import "JRSearchInfoUtils.h"
#import "JRPriceUtils.h"

#import "NSLayoutConstraint+JRConstraintMake.h"


#define kJRFilterHeigthForHeader 20
#define kJRFilterCellBottomLineOffset 34

#define kkJRFilterResetButtonHiAlpha 0.75
#define kkJRFilterResetButtonDisabled 0.4


@interface JRFilterVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel     *toolbarLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView      *toolbarView;

@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) NSArray *sections;

@property (strong, nonatomic) JRFilterCellsFactory *cellsFactory;
@property (strong, nonatomic) JRFilterItemsFactory *itemsFactory;

@property (strong, nonatomic, readonly) id<JRSDKTravelSegment> selectedTravelSegment;
@property (strong, nonatomic, readonly) JRFilter *filter;
@property (assign, nonatomic, readonly) JRFilterMode filterMode;

@end


@implementation JRFilterVC

- (instancetype)initWithFilter:(JRFilter *)filter forFilterMode:(JRFilterMode)filterMode selectedTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    self = [super initWithNibName:@"JRFilterVC" bundle:AVIASALES_BUNDLE];
    if (self) {
        _filter = filter;
        _filterMode = filterMode;
        _selectedTravelSegment = travelSegment;
        _itemsFactory = [[JRFilterItemsFactory alloc] initWithFilter:filter];
        
        [self updateTableDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma merk - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellsFactory = [[JRFilterCellsFactory alloc] initWithTableView:self.tableView withFilterMode:self.filterMode];
    
    [self setupResetButton];
    [self setupNavigationBar];
    [self setupToolbarView];
    [self reloadViews];
    [self registerNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self.tableView flashScrollIndicators];
}

#pragma mark - Protected methds

- (void)setupResetButton {
    self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetButton.frame = CGRectMake(0.0, 0.0, 80.0, 44.0);
    self.resetButton.titleLabel.textAlignment = NSTextAlignmentRight;
    self.resetButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.resetButton setTitleColor:[JRColorScheme darkTextColor] forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[JRColorScheme inactiveLightTextColor] forState:UIControlStateDisabled];
    [self.resetButton setTitle:NSLS(@"JR_FILTER_RESET") forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *resetItem = [[UIBarButtonItem alloc] initWithCustomView:self.resetButton];
    self.navigationItem.rightBarButtonItems = @[resetItem];
}

- (IBAction)resetButtonAction:(UIButton *)sender {
    switch (self.filterMode) {
        case JRFilterTravelSegmentMode:
            [self.filter resetFilterBoundsForTravelSegment:self.selectedTravelSegment];
            break;
            
        default:
            [self.filter resetAllBounds];
            break;
    }
}

- (void)showFiltersForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterVC *segmentFilterVC = [[JRFilterVC alloc] initWithFilter:self.filter
                                                       forFilterMode:JRFilterTravelSegmentMode
                                               selectedTravelSegment:travelSegment];
    [self.navigationController pushViewController:segmentFilterVC animated:YES];
}

- (void)updateToolbar {
    NSMutableAttributedString *toolbarLabelText;
    
    if (self.filter.filteredTickets.count == 0) {
        toolbarLabelText = [[NSMutableAttributedString alloc] initWithString:NSLS(@"JR_FILTER_TICKETS_NOT_FOUND")];
    } else {
        NSInteger ticketsCount =  self.filter.filteredTickets.count;
        UIFont *numbersFont = [UIFont systemFontOfSize:18.0 weight: UIFontWeightSemibold];
        NSString *minPriceString = [JRPriceUtils formattedPriceInUserCurrency:self.filter.minFilteredPrice];
        NSString *foundTicketsCountString = @(self.filter.filteredTickets.count).stringValue;
        NSString *format = NSLSP(@"JR_FILTER_FLIGHTS_FOUND_MIN_PRICE", ticketsCount);
        NSString *text = [NSString stringWithFormat:format, ticketsCount, minPriceString];
        toolbarLabelText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
        [toolbarLabelText addAttribute:NSFontAttributeName value:numbersFont range:[toolbarLabelText.string rangeOfString:foundTicketsCountString]];
        [toolbarLabelText addAttribute:NSFontAttributeName value:numbersFont range:[toolbarLabelText.string rangeOfString:minPriceString]];
    }
    
    NSString *oldString = self.toolbarLabel.attributedText.string;
    if (![toolbarLabelText.string isEqualToString:oldString]) {
        self.toolbarLabel.attributedText = toolbarLabelText;
    }
}

- (void)setupNavigationBar {
    if (self.filterMode == JRFilterTravelSegmentMode) {
        self.title = [NSString stringWithFormat:@"%@ – %@", self.selectedTravelSegment.originAirport.iata, self.selectedTravelSegment.destinationAirport.iata];
    } else {
        UIBarButtonItem *closeItem = [UINavigationItem barItemWithImageName:@"JRCloseCross" target:self action:@selector(closeButtonAction:)];
        self.navigationItem.leftBarButtonItems = @[closeItem];
        self.title = NSLS(@"JR_FILTER_BUTTON");
    }
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterBoundsDidReset:)
                                                 name:kJRFilterBoundsDidResetNotificationName
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterBoundsDidChange:)
                                                 name:kJRFilterBoundsDidChangeNotificationName
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(filterMinPriceDidUpdate:)
                                                 name:kJRFilterMinPriceDidUpdateNotificationName
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currencyDidChange:)
                                                 name:kAviasalesCurrencyDidUpdateNotificationName
                                               object:nil];
}

- (void)filterBoundsDidReset:(NSNotification *)notification {
    [self reloadViews];
}

- (void)filterBoundsDidChange:(NSNotification *)notification {
    [self updateResetButton];
}

- (void)filterMinPriceDidUpdate:(NSNotification *)notification {
    [self updateToolbar];
}

- (void)currencyDidChange:(NSNotification *)notification {
    [self reloadViews];
}

#pragma mark - Private methods

- (void)updateTableDataSource {
    switch (self.filterMode) {
        case JRFilterComplexMode:
            _sections = [self.itemsFactory createSectionsForComplexMode];
            break;
            
        case JRFilterSimpleSearchMode:
            _sections = [self.itemsFactory createSectionsForSimpleMode];
            break;
            
        case JRFilterTravelSegmentMode:
            _sections = [self.itemsFactory createSectionsForTravelSegment:self.selectedTravelSegment];
            break;
            
        default:
            break;
    }
}

- (void)setupToolbarView {
}

- (void)reloadViews {
    [self updateTableDataSource];
    [self updateResetButton];
    [self updateToolbar];
    
    [self.tableView reloadData];
}

- (void)updateResetButton {
    switch (self.filterMode) {
        case JRFilterTravelSegmentMode:
            self.resetButton.enabled = ![self.filter isTravelSegmentBoundsResetedForTravelSegment:self.selectedTravelSegment];
            break;
            
        default:
            self.resetButton.enabled = ![self.filter isAllBoundsReseted];
            break;
    }
}

#pragma mark - Actions

- (void)closeButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray<id<JRFilterItemProtocol>> *const items = self.sections[section];
    NSInteger numberOfRows = items.count;
    
    JRFilterListHeaderItem *const headerItem = (JRFilterListHeaderItem *)items.firstObject;
    if (headerItem && [headerItem isKindOfClass:[JRFilterListHeaderItem class]]) {
        numberOfRows = headerItem.expanded ? items.count : 1;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<JRFilterItem *> *const items = self.sections[indexPath.section];
    JRFilterItem *const item = items[indexPath.row];
    UITableViewCell *const cell = [self.cellsFactory cellByItem:item];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<id<JRFilterItemProtocol>> *const items = self.sections[indexPath.section];
    id<JRFilterItemProtocol> const item = items[indexPath.row];
    
    if ([item isKindOfClass:[JRFilterTravelSegmentItem class]] && self.filterMode == JRFilterComplexMode) {
        JRFilterTravelSegmentItem *travelSegmentItem = (JRFilterTravelSegmentItem *)item;
        [self showFiltersForTravelSegment:travelSegmentItem.travelSegment];
    } else if ([item isKindOfClass:[JRFilterCheckBoxItem class]]) {
        JRFilterCheckboxCell *cell = (JRFilterCheckboxCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.checked = !cell.checked;
    } else if ([item isKindOfClass:[JRFilterListHeaderItem class]]) {
        JRFilterListHeaderCell *cell = (JRFilterListHeaderCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setExpanded:!cell.expanded animated:YES];
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<JRFilterItem *> *const items = self.sections[indexPath.section];
    JRFilterItem *const item = items[indexPath.row];
    
    return [self.cellsFactory heightForCellByItem:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return JRPixel();
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *const footerView = [UIView new];
    footerView.backgroundColor = [JRColorScheme separatorLineColor];
    
    return footerView;
}

@end
