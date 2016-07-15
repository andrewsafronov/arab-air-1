//
//  JRAirportPickerVC.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 28/01/14.
//
//

#import "ColorScheme.h"
#import "JRAirportPickerCellWithAirport.h"
#import "JRAirportPickerCellWithInfo.h"
#import "JRAirportPickerItem.h"
#import "JRAirportPickerSectionTitle.h"
#import "JRAirportPickerVC.h"
#import "JRNavigationController.h"
#import "JRSearchedAirportsManager.h"
#import "JRViewController+JRScreenScene.h"

#define kJRAirportPickerMaxSearchedCount (iPhone() ? 5 : 10)
#define kJRAirportPickerHeightForTitledHeader   44
#define kJRAirportPickerHeightForUntitledHeader 10
#define kJRAirportPickerHeightForFooter  JRPixel()
#define kJRAirportPickerBottomLineOffset 20
#define kJRAirportPickerMaxSearchedAirportListSize (iPhone() ? 7 : 15)

static NSString * const kJRAirportPickerCellWithInfo = @"JRAirportPickerCellWithInfo";
static NSString * const kJRAirportPickerCellWithAirport = @"JRAirportPickerCellWithAirport";

@interface JRAirportPickerVC ()<UITableViewDataSource, UITableViewDelegate, AviasalesSearchPerformerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) JRAirportPickerMode mode;
@property (strong, nonatomic) JRTravelSegment *travelSegment;
@property (strong, nonatomic) NSMutableArray *mainSections;
@property (strong, nonatomic) NSMutableArray *searchSections;
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSMutableDictionary *mainSectionsTitles;
@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) AviasalesAirportsSearchPerformer *airportsSearchPerformer;
@property (nonatomic) BOOL searching;
@end

@implementation JRAirportPickerVC

- (id)initWithMode:(JRAirportPickerMode)mode
     travelSegment:(JRTravelSegment *)travelSegment
{
	self = [super init];
	if (self) {
		_mode = mode;
		_travelSegment = travelSegment;
        _airportsSearchPerformer = [[AviasalesAirportsSearchPerformer alloc] initWithDelegate:self];
	}
	return self;
}

- (NSArray *)sectionsForTableView:(UITableView *)tableView
{
	return self.tableView == tableView ? _mainSections : _searchSections;
}

- (void)setupTitle
{
	NSString *title = nil;
	if (_mode == JRAirportPickerOriginMode) {
		title = NSLS(@"JR_AIRPORT_PICKER_ORIGIN_MODE_TITLE");
	} else if (_mode == JRAirportPickerDestinationMode) {
		title = NSLS(@"JR_AIRPORT_PICKER_DESTINATION_MODE_TITLE");
	}
	[self setTitle:title];
}

- (void)setupSearchBar
{
	NSString *placeholder = NSLS(@"JR_AIRPORT_PICKER_PLACEHOLDER_TEXT");
	[self.searchDisplayController.searchBar setPlaceholder:placeholder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
	[self setupTitle];
	[self setupSearchBar];
    
	[self rebuildMainTable];
    
	if (_mode == JRAirportPickerOriginMode) {
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rebuildMainTable)
                                                     name:kAviasalesNearestAirportsManagerDidUpdateNotificationName object:nil];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:kJRNavigationControllerDefaultTextSize];
    NSDictionary *titleTextAttributes = @{ NSFontAttributeName : boldSystemFont };
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
}

-(void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNearestAirportsSection
{
	NSMutableArray *nearestAirportsSection = [NSMutableArray new];
    
	NSString *nearestAirportsSectionTitle = NSLS(@"JR_AIRPORT_PICKER_NEAREST_AIRPORTS");
	NSArray *nearestAirports = [[[AviasalesSDK sharedInstance] nearestAirportsManager] airports];
	AviasalesNearestAirportsManagerStatus status = [[[AviasalesSDK sharedInstance] nearestAirportsManager] state];
    
	if (status == AviasalesNearestAirportsManagerIdle && nearestAirports.count == 0) {
		JRAirportPickerItem *noNearbyItem = [JRAirportPickerItem new];
		[noNearbyItem setCellIdentifier:kJRAirportPickerCellWithInfo];
		[noNearbyItem setItemContent:NSLS(@"JR_AIRPORT_PICKER_NO_NEAREST_AIRPORTS")];
		[nearestAirportsSection addObject:noNearbyItem];
	} else if (status == AviasalesNearestAirportsManagerReadingAirportData) {
		JRAirportPickerItem *updatingItem = [JRAirportPickerItem new];
		[updatingItem setCellIdentifier:kJRAirportPickerCellWithInfo];
		[updatingItem setItemContent:NSLS(@"JR_AIRPORT_PICKER_UPDATING_NEAREST_AIRPORTS")];
		[nearestAirportsSection addObject:updatingItem];
	} else if (status == AviasalesNearestAirportsManagerReadingError) {
		JRAirportPickerItem *readingErrorItem = [JRAirportPickerItem new];
		[readingErrorItem setCellIdentifier:kJRAirportPickerCellWithInfo];
		[readingErrorItem setItemContent:NSLS(@"JR_AIRPORT_PICKER_NEAREST_AIRPORTS_READING_ERROR")];
		[nearestAirportsSection addObject:readingErrorItem];
	} else {
		for (id<JRSDKAirport> airport in nearestAirports) {
			JRAirportPickerItem *airportItem = [JRAirportPickerItem new];
			[airportItem setCellIdentifier:kJRAirportPickerCellWithAirport];
			[airportItem setItemContent:airport];
			[nearestAirportsSection addObject:airportItem];
		}
	}
    
	if (nearestAirportsSection.count > 0) {
		[_mainSections addObject:nearestAirportsSection];
		NSString *sectionKey = [NSString stringWithFormat:@"%@", @([_mainSections indexOfObject:nearestAirportsSection])];
		_mainSectionsTitles[sectionKey] = nearestAirportsSectionTitle;
	}
}

- (void)addSearchedAirportsSection
{
	NSArray *searchedAirports = [JRSearchedAirportsManager searchedAirports];
	
    NSMutableArray *searchedAirportsSection = [NSMutableArray new];
    
	NSString *searchedAirportsSectionTitle = NSLS(@"JR_AIRPORT_PICKER_SEARCHED_AIRPORTS");
    
    NSInteger numberOfSearchedAirports = 0;
	for (JRAirport *airport in searchedAirports) {
		JRAirportPickerItem *airportItem = [JRAirportPickerItem new];
		[airportItem setCellIdentifier:kJRAirportPickerCellWithAirport];
		[airportItem setItemContent:airport];
		[searchedAirportsSection addObject:airportItem];
        numberOfSearchedAirports++;
        if (numberOfSearchedAirports >= kJRAirportPickerMaxSearchedAirportListSize) {
            break;
        }
	}
    
	if (searchedAirportsSection.count > 0) {
		[_mainSections addObject:searchedAirportsSection];
		NSString *sectionKey = [NSString stringWithFormat:@"%@", @([_mainSections indexOfObject:searchedAirportsSection])];
		_mainSectionsTitles[sectionKey] = searchedAirportsSectionTitle;
	}
}

- (void)rebuildMainTable
{
	_mainSections = [NSMutableArray new];
	_mainSectionsTitles = [NSMutableDictionary new];
    
	if (_mode == JRAirportPickerOriginMode) {
		[self addNearestAirportsSection];
	}
    
	[self addSearchedAirportsSection];
    
	[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[self sectionsForTableView:tableView] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self sectionsForTableView:tableView][section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	JRAirportPickerItem *item = [self sectionsForTableView:tableView][indexPath.section][indexPath.row];
    
	id cell = [tableView dequeueReusableCellWithIdentifier:item.cellIdentifier];
    if (cell == nil) {
        cell = LOAD_VIEW_FROM_NIB_NAMED(item.cellIdentifier);
    }
    [cell setLeftOffset:kJRAirportPickerBottomLineOffset];
    [cell setBottomLineVisible:YES];
    
	if ([cell isKindOfClass:[JRAirportPickerCellWithInfo class]]) {
		[[cell locationInfoLabel] setText:[item.itemContent uppercaseString]];
		BOOL shouldHideActivityIndicator = self.tableView == tableView &&
        ![item.itemContent isEqualToString:NSLS(@"JR_AIRPORT_PICKER_UPDATING_NEAREST_AIRPORTS")];
        BOOL shouldEnableSelection = [item.itemContent isEqualToString:NSLS(@"JR_AIRPORT_PICKER_NEAREST_AIRPORTS_UPDATING_ERROR")];
        [cell setSelectionStyle:shouldEnableSelection ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone];
        shouldHideActivityIndicator ? [cell stopActivityIndicator] : [cell startActivityIndicator];
	}
	if ([cell isKindOfClass:[JRAirportPickerCellWithAirport class]]) {
		[cell setSearchString:_searchString];
		[cell setAirport:item.itemContent];
	}
    [cell updateBackgroundViewsForImagePath:indexPath inTableView:tableView];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	JRAirportPickerItem *item = [self sectionsForTableView:tableView][indexPath.section][indexPath.row];
    
	id object = item.itemContent;
    
    if ([object conformsToProtocol:@protocol(JRSDKAirport)]) {
		id<JRSDKAirport> airport = object;
        
		if (_mode == JRAirportPickerOriginMode) {
			[_travelSegment setOriginAirport:airport];
		} else if (_mode == JRAirportPickerDestinationMode) {
			[_travelSegment setDestinationAirport:airport];
		}
        
        [JRSearchedAirportsManager markSearchedAirport:airport];
        
        if (iPad()) {
            [self.view endEditing:YES];
        }
        
        [self detachAccessoryViewControllerAnimated:YES];
		[self popAction];
	}
}

- (UIView *)mainViewForHeaderInSection:(NSInteger)section
{
	NSString *sectionKey = [NSString stringWithFormat:@"%@", @(section)];
	NSString *title = _mainSectionsTitles[sectionKey];
	if (title) {
		JRAirportPickerSectionTitle *header = LOAD_VIEW_FROM_NIB_NAMED(@"JRAirportPickerSectionTitle");
		[header.titleLabel setText:title];
        header.backgroundColor = [UIColor clearColor];
		return header;
	} else {
        return [UIView new];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (self.tableView == tableView) {
		return [self mainViewForHeaderInSection:section];
	} else {
		return nil;
	}
}

- (UIView *)mainViewForFooterInSection:(NSInteger)section
{
	UIView *footer = [UIView new];
	[footer setBackgroundColor:[ColorScheme separatorLineColor]];
	return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (self.tableView == tableView) {
		return [self mainViewForFooterInSection:section];
	} else {
		return nil;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (self.tableView == tableView) {
		NSString *sectionKey = [NSString stringWithFormat:@"%@", @(section)];
		NSString *title = _mainSectionsTitles[sectionKey];
		return title ? kJRAirportPickerHeightForTitledHeader : kJRAirportPickerHeightForUntitledHeader;
	} else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return self.tableView == tableView ? kJRAirportPickerHeightForFooter : 0;
}

#pragma mark - Search Table

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self setSearchString:searchText];
}

#pragma mark - Start Search

- (void)setSearchString:(NSString *)searchString
{
	_searchString = searchString;
    
    _searchResults = [NSArray array];
    
    _searching = YES;
    
    [_airportsSearchPerformer searchAirportsWithString:_searchString];
}

#pragma mark - Complete Search

- (void)airportsSearchPerformer:(AviasalesAirportsSearchPerformer *)airportsSearchPerformer didFoundAirports:(NSArray<id<JRSDKAirport>> *)airports final:(BOOL)final {
    _searching = !final;
    
    _searchResults = [_searchResults arrayByAddingObjectsFromArray:airports];
    
    [self rebuildSearchTable];
}

- (void)rebuildSearchTable
{
	_searchSections = [NSMutableArray new];
    
	_searchResults = [[[NSMutableOrderedSet orderedSetWithArray:_searchResults] array] mutableCopy];
    
	NSMutableArray *searchedAirportsSection = [NSMutableArray new];
    
	for (JRAirport *airport in _searchResults) {
		JRAirportPickerItem *airportItem = [JRAirportPickerItem new];
		[airportItem setCellIdentifier:@"JRAirportPickerCellWithAirport"];
		[airportItem setItemContent:airport];
		[searchedAirportsSection addObject:airportItem];
	}
    
	if (_searching) {
		JRAirportPickerItem *serverSearchingItem = [JRAirportPickerItem new];
		[serverSearchingItem setCellIdentifier:@"JRAirportPickerCellWithInfo"];
		[serverSearchingItem setItemContent:NSLS(@"JR_AIRPORT_PICKER_SEARCHING_ON_SERVER_TEXT")];
		[searchedAirportsSection addObject:serverSearchingItem];
	}
    
	if (searchedAirportsSection.count > 0) {
		[_searchSections addObject:searchedAirportsSection];
	}
	[self.searchDisplayController.searchResultsTableView reloadData];
}

- (NSMutableArray *)newAirportsToAdd:(NSArray *)airportsToAdd
                       arrayToFilter:(NSArray *)arrayToFilter
{
	NSMutableArray *newAirports = [[NSMutableArray alloc] init];
    
	for (id<JRSDKAirport> newAirport in airportsToAdd) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"iata like %@", newAirport.iata];
		if (![[arrayToFilter filteredArrayUsingPredicate:predicate] count]) {
			[newAirports addObject:newAirport];
		}
	}
	return newAirports;
}
@end
