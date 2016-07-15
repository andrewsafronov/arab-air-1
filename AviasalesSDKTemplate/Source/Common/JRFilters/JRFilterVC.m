//
//  JRFilterVC.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 30/03/14.
//
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

#import "ColorScheme.h"
#import "JRSearchInfoUtils.h"

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

    self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.resetButton.frame = CGRectMake(0.0, 0.0, 100.0, 44.0);
    self.resetButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.resetButton setTitleColor:[ColorScheme lightTextColor] forState:UIControlStateNormal];
    [self.resetButton setTitle:NSLS(@"JR_FILTER_BUTTON_RESET") forState:UIControlStateNormal];
    [self.resetButton addTarget:self.filter action:@selector(resetAllBounds) forControlEvents:UIControlEventTouchUpInside];
    
    self.cellsFactory = [[JRFilterCellsFactory alloc] initWithTableView:self.tableView withFilterMode:self.filterMode];
    
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
        UIFont *numbersFont = [UIFont systemFontOfSize:18.0 weight: UIFontWeightSemibold];
        NSInteger priceValue = [JRSDKModelUtils priceInUserCurrency:self.filter.minFilteredPrice].integerValue;
        NSString *minPriceString = [NSString stringWithFormat:@"%ld", (long)priceValue];
        NSString *foundTicketsCountString = @(self.filter.filteredTickets.count).stringValue;
        NSString *text = [NSString stringWithFormat:@"%@ %@ %@", foundTicketsCountString, NSLS(@"JR_FILTER_FLIGHTS_FOUND_MIN_PRICE"), minPriceString];
        toolbarLabelText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
        [toolbarLabelText addAttribute:NSFontAttributeName value:numbersFont range:[toolbarLabelText.string rangeOfString:foundTicketsCountString]];
        [toolbarLabelText addAttribute:NSFontAttributeName value:numbersFont range:[toolbarLabelText.string rangeOfString:minPriceString]];
        
        NSString *currencyCode = [AviasalesSDK sharedInstance].currencyCode.uppercaseString;
        NSString *currencyString = [NSString stringWithFormat:@"\u00A0%@", currencyCode];
        NSAttributedString *currencyAttributedString = [[NSAttributedString alloc] initWithString:currencyString attributes:nil];
        [toolbarLabelText appendAttributedString:currencyAttributedString];
       
        NSRange currencyRange = [toolbarLabelText.string rangeOfString:currencyString];
        if (currencyRange.location != NSNotFound) {
            UIFont *currencyFont = [UIFont systemFontOfSize:8.0];
            [toolbarLabelText addAttribute:NSFontAttributeName value:currencyFont range:currencyRange];
            [toolbarLabelText addAttribute:NSBaselineOffsetAttributeName value:@7 range:currencyRange];
        }
    }
    
    NSString *oldString = self.toolbarLabel.attributedText.string;
    if (![toolbarLabelText.string isEqualToString:oldString]) {
        self.toolbarLabel.attributedText = toolbarLabelText;
    }
}

- (void)setupNavigationBar {
    UIBarButtonItem *resetItem = [[UIBarButtonItem alloc] initWithCustomView:self.resetButton];
    
    self.navigationItem.rightBarButtonItems = @[resetItem];
    
    if (self.filterMode == JRFilterTravelSegmentMode) {
        self.title = [NSString stringWithFormat:@"%@ – %@", self.selectedTravelSegment.originAirport.iata, self.selectedTravelSegment.destinationAirport.iata];
    } else {
        UIBarButtonItem *closeItem = [UINavigationItem barItemWithImageName:@"JRCloseCross" target:self action:@selector(closeButtonAction:)];
        self.navigationItem.leftBarButtonItems = @[closeItem];
        self.title = NSLS(@"JR_FILTER_VC_TITLE");
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
    return [self.sections[section] count];
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
    footerView.backgroundColor = [ColorScheme separatorLineColor];
    
    return footerView;
}

@end
