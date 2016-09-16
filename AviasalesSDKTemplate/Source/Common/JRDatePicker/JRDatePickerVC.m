//
//  JRDatePickerVC.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRDatePickerVC.h"
#import "JRDatePickerMonthItem.h"
#import "JRDatePickerDayCell.h"
#import "JRDatePickerMonthHeaderReusableView.h"
#import "DateUtil.h"
#import "UIView+JRFadeAnimation.h"
#import "JRViewController+JRScreenScene.h"
#import "JRColorScheme.h"

static const NSInteger kDatePickerCollectionHeaderHeight = 65;
static const NSInteger kDatePickerToolbarHeight = 87;

static NSString * const kDayCellIdentifier = @"JRDatePickerDayCell";
static NSString * const kMonthReusableHeaderViewIdentifier = @"JRDatePickerMonthHeaderReusableView";


@interface JRDatePickerVC ()<UITableViewDataSource, UITableViewDelegate, JRDatePickerStateObjectActionDelegate>

@property (assign, nonatomic) BOOL shouldShowSearchToolbar;
@property (strong, nonatomic) JRDatePickerStateObject *stateObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchButtonToolbar;

@end


@implementation JRDatePickerVC

- (instancetype)initWithSearchInfo:(JRSearchInfo *)searchInfo
                     travelSegment:(JRTravelSegment *)travelSegment
                              mode:(JRDatePickerMode)mode
           shouldShowSearchToolbar:(BOOL)shouldShowSearchToolbar {
    self = [self initWithSearchInfo:searchInfo travelSegment:travelSegment mode:mode];
    if (self) {
        [self setShouldShowSearchToolbar:shouldShowSearchToolbar];
    }
    return self;
}

- (instancetype)initWithSearchInfo:(JRSearchInfo *)searchInfo
                     travelSegment:(JRTravelSegment *)travelSegment
                              mode:(JRDatePickerMode)mode {
	self = [super init];
	if (self) {
		_stateObject = [[JRDatePickerStateObject alloc] initWithDelegate:self];
		[_stateObject setSearchInfo:searchInfo];
		[_stateObject setTravelSegment:travelSegment];
		[_stateObject setMode:mode];
		[self buildTable];
	}
	return self;
}

- (void)registerNibs {
	[_tableView registerClass:[JRDatePickerDayCell class] forCellReuseIdentifier:kDayCellIdentifier];
    
	UINib *headerNib = [UINib nibWithNibName:kMonthReusableHeaderViewIdentifier bundle:nil];
	[_tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:kMonthReusableHeaderViewIdentifier];
}

- (void)setupTitle {
	if (_stateObject.mode == JRDatePickerModeReturn) {
		if (_shouldShowSearchToolbar) {
            [self setTitle:NSLS(@"JR_DATE_PICKER_TRAVEL_DATES_TITLE")];
        } else {
            [self setTitle:NSLS(@"JR_DATE_PICKER_RETURN_DATE_TITLE")];
        }
	} else {
		[self setTitle:NSLS(@"JR_DATE_PICKER_DEPARTURE_DATE_TITLE")];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	[self registerNibs];
	[self setupTitle];
    
	[_tableView setBackgroundColor:[JRColorScheme mainBackgroundColor]];
    [self setSearchButtonToolbarHidden:_shouldShowSearchToolbar ? NO : YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[_tableView reloadData];
	[_tableView scrollToRowAtIndexPath:_stateObject.indexPathToScroll atScrollPosition:UITableViewScrollPositionTop animated:NO];}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	[_tableView flashScrollIndicators];
}

- (void)setSearchButtonToolbarHidden:(BOOL)searchButtonToolbarHidden {
    [_searchButtonToolbar setHidden:searchButtonToolbarHidden];
    if (_searchButtonToolbar.hidden == YES) {
        [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    } else {
        [_tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, kDatePickerToolbarHeight, 0)];
        [_tableView setContentInset:UIEdgeInsetsMake(0, 0, kDatePickerToolbarHeight, 0)];
    }
}

- (void)buildTable {
	NSMutableArray *datesToRepresent = [NSMutableArray new];
    
	NSUInteger prevIndex = [_stateObject.searchInfo.travelSegments indexOfObject:_stateObject.travelSegment] - 1;
	if (_stateObject.mode != JRDatePickerModeDeparture && _stateObject.searchInfo.travelSegments.count > prevIndex) {
		JRTravelSegment *segment = (_stateObject.searchInfo.travelSegments)[prevIndex];
		[_stateObject setBorderDate:segment.departureDate];
	}
	if (!_stateObject.borderDate) {
		[_stateObject setBorderDate:[DateUtil firstAvalibleForSearchDate]];
	}
    
	NSDate *firstMonth = [DateUtil firstDayOfMonth:[DateUtil resetTimeForDate:[DateUtil today]]];
	[datesToRepresent addObject:firstMonth];
	for (NSUInteger i = 1; i <= 12; i++) {
		NSDate *prevMonth = datesToRepresent[i - 1];
		[datesToRepresent addObject:[DateUtil nextMonthForDate:prevMonth]];
	}
    
    
	for (NSDate *date in datesToRepresent) {
		[_stateObject.monthItems addObject:[JRDatePickerMonthItem monthItemWithFirstDateOfMonth:date stateObject:_stateObject]];
	}
	[_stateObject updateSelectedDatesRange];
}

- (void)dateWasSelected:(NSDate *)date {
	if (_stateObject.mode == JRDatePickerModeDefault) {
		_stateObject.firstSelectedDate = date;
	} else {
		if (_stateObject.travelSegment == _stateObject.searchInfo.travelSegments.firstObject) {
			_stateObject.firstSelectedDate = date;
		} else {
			_stateObject.secondSelectedDate = date;
		}
	}
	[_stateObject.travelSegment setDepartureDate:date];
	[_stateObject updateSelectedDatesRange];
	[_tableView reloadData];
    
    if (_searchButtonToolbar.hidden == YES) {
        [self performSelector:@selector(popAction) withObject:nil afterDelay:0.15];
    }
    
    if ([_delegate respondsToSelector:@selector(datePicker:didSelectDepartDate:inTravelSegment:)]) {
        [_delegate datePicker:self didSelectDepartDate:date inTravelSegment:_stateObject.travelSegment];
    }
}

- (void)popAction {
	[super popAction];
    
    [self detachAccessoryViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return _stateObject.monthItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	JRDatePickerMonthItem *monthItem = (_stateObject.monthItems)[section];
	return monthItem.weeks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	JRDatePickerDayCell *cell = [tableView dequeueReusableCellWithIdentifier:kDayCellIdentifier];
	JRDatePickerMonthItem *monthItem = (_stateObject.monthItems)[indexPath.section];
	NSArray *dates = (monthItem.weeks)[indexPath.row];
	[cell setDatePickerItem:monthItem dates:dates];
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	JRDatePickerMonthHeaderReusableView *sectionHeaderView = [tableView
	                                                          dequeueReusableHeaderFooterViewWithIdentifier:kMonthReusableHeaderViewIdentifier];
	[sectionHeaderView setMonthItem:(_stateObject.monthItems)[section]];
	return sectionHeaderView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.view.frame.size.width / 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return kDatePickerCollectionHeaderHeight;
}

- (IBAction)searchButtonAction:(id)sender {
    [_stateObject.searchInfo clipSearchInfoForSimpleSearchIfNeeds];
    // TODO: start new search
//    [[JRMenuManager sharedInstance] startNewSearchWithSearchInfo:_stateObject.searchInfo andSearchSource:JRSearchSourcePriceCalendar];
    [_parentPopoverController dismissPopoverAnimated:YES];
}

@end
