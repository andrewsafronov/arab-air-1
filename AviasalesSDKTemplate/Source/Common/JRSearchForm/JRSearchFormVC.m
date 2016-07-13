//
//  JRSearchFormVC.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchInfo.h"
#import "JRAirport.h"
#import "NSLayoutConstraint+JRConstraintMake.h"
#import "JRDatePickerVC.h"
#import "JRSearchFormComplexSearchTableView.h"
#import "JRSearchFormPassengerPickerVC.h"
#import "JRSearchFormSimpleSearchTableView.h"
#import "JRSearchFormTravelClassPickerVC.h"
#import "JRSearchFormVC.h"
#import "JRSegmentedControl.h"
#import "JRSimplePopoverController.h"
#import "UIImage+JRUIImage.h"
#import "UIView+JRFadeAnimation.h"
#import "JRNavigationController.h"
#import "JRScreenScene.h"
#import "JRScreenSceneController.h"
#import "JRViewController+JRScreenScene.h"
#import "JRAirportPickerVC.h"
#import "ColorScheme.h"
#import "JRWaitingViewController.h"
#import "ASTResults.h"
#import "UINavigationController+Additions.h"
#import "ASTFilters.h"
#import "Constants.h"
#import "UIViewController+JRScreenSceneController.h"
#import "JRFPPopoverController.h"

#define kJRSearchFormLastUsedSearchInfoStorageKey                   @"kJRSearchFormLastUsedSearchInfoStorageKey"
#define kJRSearchFormSegmentLabelFontiPhone                         [UIFont fontWithName:@"HelveticaNeue-Medium" size:18]
#define kJRSearchFormAirportsFraction                               (160.0 / 440.0)
#define kJRSearchFormAnimationAnimationInitialSpringVelocity        1
#define kJRSearchFormAnimationAnimationUsingSpringWithDamping       0.8
#define kJRSearchFormAnimationDuration                              0.35
#define kJRSearchFormReloadingAnimationDuration                     0.6
#define kJRSearchFormTableViewAddCellHeight                           (iPhone() ? 73 : 74)
#define kJRSearchFormTableViewComplexCellHeightIPHONE                 60
#define kJRSearchFormTableViewComplexCellHeightIPAD                   62
#define kJRSearchFormDatesFraction                                  (150.0 / 440.0)
#define kJRSearchFormCellFromTableInCellFraction                    0.5
#define kJRSearchFormPassengersPopoverSize                          CGSizeMake(280, 236)

typedef NS_ENUM (NSUInteger, JRSearchFormMode) {
    JRSearchFormModeNotConfigured = 0,
	JRSearchFormModeSimple,
    JRSearchFormModeComplex
};

@interface JRSearchFormVC () <JRSearchFormItemDelegate, FPPopoverControllerDelegate, JRSearchFormPassengerPickerViewDelegate, JRSearchFormTravelClassPickerDelegate, JRWaitingViewControllerDelegate>

@property (assign, nonatomic) JRSearchFormMode searchFormMode;
@property (strong, nonatomic) JRFPPopoverController *popover;
@property (strong, nonatomic) JRSearchInfo *searchInfo;
@property (strong, nonatomic) JRTravelSegment *savedTravelSegment;
@property (strong, nonatomic) NSLayoutConstraint *simpleSearchTableLeadingConstaint;
@property (strong, nonatomic) NSLayoutConstraint *travelClassAndPassengersLeadingTableViewConstraint;
@property (strong, nonatomic) NSLayoutConstraint *travelClassAndPassengersLeadingViewConstraint;
@property (weak, nonatomic) IBOutlet JRSearchFormComplexSearchTableView *complexSearchTable;
@property (weak, nonatomic) IBOutlet JRSearchFormSimpleSearchTableView *simpleSearchTable;
@property (weak, nonatomic) IBOutlet JRSearchFormSimpleSearchTableView *travelClassAndPassengersTable;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *complexTableFooter;
@property (weak, nonatomic) IBOutlet UIView *passengerPopoverFromView;
@property (weak, nonatomic) IBOutlet UIButton *simpleFormButton;
@property (weak, nonatomic) IBOutlet UIButton *complexFormButton;
@property (strong, nonatomic) JRWaitingViewController *waitingScreen;

@end

@implementation JRSearchFormVC

#pragma mark - ViewController Setup

void * JRComplexTableSizeChangeContext = &JRComplexTableSizeChangeContext;

- (IBAction)startSearchAction:(id)sender
{
    UIAlertView *errorAlert = [self getErrorAlert];
    if (errorAlert) {
        [errorAlert show];
        return;
    }
    
	[self clipSearchInfoIfNeeds];
    [self performSearchWithInfo:_searchInfo];
}

- (void)startSearchWithSearchInfo:(JRSearchInfo *)searchInfo {
    self.searchInfo = searchInfo;
    [self startSearchAction:nil];
}

- (UIAlertView *)getErrorAlert {
    UIAlertView *emptyOriginErrorAlert = [[UIAlertView alloc] initWithTitle:nil message:NSLS(@"JR_SEARCH_FORM_AIRPORT_EMPTY_ORIGIN_ERROR") delegate:nil cancelButtonTitle:NSLS(@"ALERT_DEFAULT_BUTTON") otherButtonTitles:nil, nil];
    
    if (_searchInfo.travelSegments.count == 0) {
        return emptyOriginErrorAlert;
    }
    
    for (JRTravelSegment *travelSegment in _searchInfo.travelSegments) {
        if (_searchFormMode == JRSearchFormModeSimple && [_searchInfo.travelSegments indexOfObject:travelSegment] == 1) {
            return nil;
        }
        if (travelSegment.originAirport == nil) {
            return emptyOriginErrorAlert;
        } else if (travelSegment.destinationAirport == nil) {
            return [[UIAlertView alloc] initWithTitle:nil message:NSLS(@"JR_SEARCH_FORM_AIRPORT_EMPTY_DESTINATION_ERROR") delegate:nil cancelButtonTitle:NSLS(@"ALERT_DEFAULT_BUTTON") otherButtonTitles:nil, nil];
        } else if ([[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:travelSegment.originAirport.iata]
                    isEqualToString:[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:travelSegment.destinationAirport.iata]]) {
            return [[UIAlertView alloc] initWithTitle:nil message:NSLS(@"JR_SEARCH_FORM_AIRPORT_EMPTY_SAME_CITY_ERROR") delegate:nil cancelButtonTitle:NSLS(@"ALERT_DEFAULT_BUTTON") otherButtonTitles:nil, nil];
        } else if (travelSegment.departureDate == nil) {
            return [[UIAlertView alloc] initWithTitle:nil message:NSLS(@"JR_SEARCH_FORM_AIRPORT_EMPTY_DEPARTURE_DATE") delegate:nil cancelButtonTitle:NSLS(@"ALERT_DEFAULT_BUTTON") otherButtonTitles:nil, nil];
        }
    }
    return nil;
}

- (void)clipSearchInfoIfNeeds
{
	if (_searchFormMode == JRSearchFormModeSimple) {
		[_searchInfo clipSearchInfoForSimpleSearchIfNeeds];
	} else if (_searchFormMode == JRSearchFormModeComplex) {
		[_searchInfo clipSearchInfoForComplexSearchIfNeeds];
	}
	[self reloadSearchFormAnimated:NO];
}

- (void)setupTableViews
{
	JRSearchFormItem *airports = [[JRSearchFormItem alloc] initWithType:JRSearchFormTableViewItemAirportsType itemDelegate:self];
	JRSearchFormItem *dates = [[JRSearchFormItem alloc] initWithType:JRSearchFormTableViewItemDatesType itemDelegate:self];
	[_simpleSearchTable setItems:@[airports, dates]];
	[_simpleSearchTable reloadData];
    
	JRSearchFormItem *travelClassAndPassengers = [[JRSearchFormItem alloc] initWithType:JRSearchFormTableViewItemTravelClassAndPassengersType itemDelegate:self];
	[_travelClassAndPassengersTable setItems:@[travelClassAndPassengers]];
	[_travelClassAndPassengersTable reloadData];
    
	_travelClassAndPassengersLeadingViewConstraint = JRConstraintMake(_travelClassAndPassengersTable, NSLayoutAttributeLeft, NSLayoutRelationEqual, self.view, NSLayoutAttributeLeft, 1, 0);
	_travelClassAndPassengersLeadingTableViewConstraint = JRConstraintMake(_travelClassAndPassengersTable, NSLayoutAttributeLeft, NSLayoutRelationEqual, _simpleSearchTable, NSLayoutAttributeLeft, 1, 0);
	[_travelClassAndPassengersLeadingViewConstraint setPriority:UILayoutPriorityRequired];
	[_travelClassAndPassengersLeadingTableViewConstraint setPriority:UILayoutPriorityDefaultHigh];
	[self.view addConstraint:_travelClassAndPassengersLeadingViewConstraint];
	[self.view addConstraint:_travelClassAndPassengersLeadingTableViewConstraint];
    
	[_complexSearchTable setTravelClassAndPassengers:_travelClassAndPassengersTable];
	[_complexSearchTable setTravelClassAndPassengersConstraint:_travelClassAndPassengersLeadingViewConstraint];
	[_complexSearchTable setItemDelegate:self];
    
	UIImageView *footer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JRBasePatternedGradient"]];
	[footer setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_complexTableFooter addSubview:footer];
	[_complexTableFooter addConstraints:JRConstraintsMakeScaleToFill(footer, _complexTableFooter)];
	[_complexTableFooter setTransform:CGAffineTransformMakeScale(1,-1)];
}

- (void)setSearchInfo:(JRSearchInfo *)searchInfoToCopy
{
    if (searchInfoToCopy == nil) {
        return;
    }
    JRSearchInfo *searchInfo = [searchInfoToCopy copyWithTravelSegments];
    [searchInfo setAdjustSearchInfo:YES];
	_searchInfo = searchInfo;
    while (_searchInfo.travelSegments.count <= 1) {
        JRTravelSegment *travelSegment = [JRTravelSegment new];
        [_searchInfo addTravelSegment:travelSegment];
    }
	[self reloadSearchFormAnimated:NO];
    [self adjustSearchFormMode];
}

- (void)updateDeparureDatesIfNeeds {
    [_searchInfo cleanUp];
}

- (void)adjustSearchFormMode {
    if (_searchInfo.isComplexSearch) {
        [self setSearchFormMode:JRSearchFormModeComplex];
    } else {
        [self setSearchFormMode:JRSearchFormModeSimple];
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if (iPad()) {
        NSAssert(self.navigationController != nil || [self scene] != nil, @"You need to embed root view controller to UINavigationController or use wide layout");
    } else {
        NSAssert(self.navigationController != nil, @"You need to embed root view controller to UINavigationController");
    }

    if (iPhone()) {
        [self.view setBackgroundColor:[ColorScheme mainBackgroundColor]];
    } else {
        [self.view setBackgroundColor:[ColorScheme darkBackgroundColor]];
    }
    
	NSString *titleString = NSLS(@"JR_SEARCH_FORM_TITLE");
	[self setTitle:titleString];
    
	[self setupTableViews];
    
	if (_searchInfo) {
        [self adjustSearchFormMode];
	} else {
        JRSearchInfo *searchInfoFromUserSettings = [self lastUsedSearchInfo];
		JRSearchInfo *searchInfo = searchInfoFromUserSettings ? searchInfoFromUserSettings : [JRSearchInfo new];
		[self setSearchInfo:searchInfo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeChange:) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newAirportsParsed:) name:kAviasalesAirportsStorageNewAirportsParsedNotificationName object:nil];
}

- (void)newAirportsParsed:(NSNotification *)note {
    [self reloadSearchFormAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	[self reloadSearchFormAnimated:YES];
}

- (BOOL)shouldShowNavigationBar {
    return !iPhone();
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];

	if ([self scene]) {
		[self detachAccessoryViewControllerAnimated:NO];
	}
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)timeChange:(NSNotification *)note {
    dispatch_async(dispatch_get_main_queue(), ^{
       [self reloadSearchForm];
    });
}

- (void)reloadSearchForm {
    if ([NSThread isMainThread]) {
        [self reloadSearchFormAnimated:NO];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadSearchFormAnimated:NO];
        });
    }
}

- (void)reloadSearchFormAnimated:(BOOL)animated
{
    [self updateDeparureDatesIfNeeds];
    
	[_simpleSearchTable reloadData];
	[_travelClassAndPassengersTable reloadData];
	[_complexSearchTable reloadData];
    
	if (animated) {
		NSTimeInterval duration = kJRSearchFormReloadingAnimationDuration;
		[UIView addTransitionFadeToView:_simpleSearchTable
                               duration:duration];
		[UIView addTransitionFadeToView:_travelClassAndPassengersTable
                               duration:duration];
		[UIView addTransitionFadeToView:_complexSearchTable
                               duration:duration];
	}
}

#pragma mark - Search Form Mode Selecting

- (void)setSearchFormMode:(JRSearchFormMode)searchFormMode
{
	[self setSearchFormMode:searchFormMode animated:NO];
}

- (void)setSearchFormMode:(JRSearchFormMode)searchFormMode animated:(BOOL)animated
{
    if (searchFormMode == _searchFormMode) {
        return;
    }
    
	_searchFormMode = searchFormMode;
    
    self.simpleFormButton.selected = _searchFormMode == JRSearchFormModeSimple;
    self.complexFormButton.selected = _searchFormMode == JRSearchFormModeComplex;
    
	if (_searchFormMode == JRSearchFormModeSimple) {
		[self selectSimpleSearchModeAnimated:animated];
	} else if (_searchFormMode == JRSearchFormModeComplex) {
		[self selectComplexSearchModeAnimated:animated];
	}
}

- (void)selectSimpleSearchModeAnimated:(BOOL)animated
{
	[_simpleSearchTable reloadData];
	[_travelClassAndPassengersTable reloadData];
	[self addLeadingConstraintToSimpleSearchTable:NO animated:animated];
    
    _simpleSearchTable.accessibilityElementsHidden = NO;
    _complexSearchTable.accessibilityElementsHidden = YES;
}

- (void)selectComplexSearchModeAnimated:(BOOL)animated
{
	[_complexSearchTable reloadData];
	[self addLeadingConstraintToSimpleSearchTable:YES animated:animated];
    
    _complexSearchTable.accessibilityElementsHidden = NO;
    _simpleSearchTable.accessibilityElementsHidden = YES;
}

#pragma mark - Search Form Mode Selecting Animators

- (void)addLeadingConstraintToSimpleSearchTable:(BOOL)addConstraint animated:(BOOL)animated
{
	void (^animations)(void) = ^{
		if (!_simpleSearchTableLeadingConstaint) {
			_simpleSearchTableLeadingConstaint = JRConstraintMake(_simpleSearchTable, NSLayoutAttributeRight, NSLayoutRelationEqual, self.view, NSLayoutAttributeLeft, 1, 0);
		}
		BOOL containtConstraint = [self.view.constraints containsObject:_simpleSearchTableLeadingConstaint];
		if (addConstraint && !containtConstraint) {
			[self.view addConstraint:_simpleSearchTableLeadingConstaint];
		} else if (!addConstraint && containtConstraint) {
			[self.view removeConstraint:_simpleSearchTableLeadingConstaint];
		}
        if (animated) {
            [self.view layoutIfNeeded];
        }
	};
	if (animated) {
		[UIView animateWithDuration:kJRSearchFormAnimationDuration delay:kNilOptions
             usingSpringWithDamping:kJRSearchFormAnimationAnimationUsingSpringWithDamping
              initialSpringVelocity:kJRSearchFormAnimationAnimationInitialSpringVelocity
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionOverrideInheritedOptions
                         animations:animations completion:NULL];
        
	} else {
		animations();
	}
}

#pragma mark - Actions

- (IBAction)formTypeButtonDidTap:(UIButton *)sender
{
	if (sender == self.simpleFormButton) {
		[self setSearchFormMode:JRSearchFormModeSimple animated:YES];
	} else if (sender == self.complexFormButton) {
		[self setSearchFormMode:JRSearchFormModeComplex animated:YES];
	} else {
        [self setSearchFormMode:self.searchFormMode animated:NO];
    }
}

- (void)selectOriginIATAForTravelSegment:(JRTravelSegment *)travelSegment itemType:(JRSearchFormItemType)type
{
    if (!travelSegment) {
        travelSegment = [JRTravelSegment new];
        [_searchInfo addTravelSegment:travelSegment];
    }
    
	JRAirportPickerVC *airportPicker = [[JRAirportPickerVC alloc] initWithMode:JRAirportPickerOriginMode travelSegment:travelSegment];
	if ([self scene]) {
        [self attachAccessoryViewController:airportPicker width:[JRScreenSceneController screenSceneControllerTallViewWidth] exclusiveFocus:YES animated:YES];
	} else {
		[self.navigationController pushViewController:airportPicker animated:YES];
	}
}

- (void)selectDestinationIATAForTravelSegment:(JRTravelSegment *)travelSegment itemType:(JRSearchFormItemType)type
{
    if (!travelSegment) {
        travelSegment = [JRTravelSegment new];
        [_searchInfo addTravelSegment:travelSegment];
    }
    
	JRAirportPickerVC *airportPicker = [[JRAirportPickerVC alloc] initWithMode:JRAirportPickerDestinationMode travelSegment:travelSegment];
	if ([self scene]) {
		[self attachAccessoryViewController:airportPicker width:[JRScreenSceneController screenSceneControllerTallViewWidth] exclusiveFocus:YES animated:YES];
	} else {
        [self.navigationController pushViewController:airportPicker animated:YES];
	}
}

- (void)travelClassDidSelect
{
	[self reloadSearchFormAnimated:YES];
}

- (void)showPassengerPicker {
    if (_popover) {
        return;
    }
    
    [self reloadSearchFormAnimated:YES];
    
    JRSearchFormPassengerPickerVC *passengerPickerVC = [[JRSearchFormPassengerPickerVC alloc] init];
    [passengerPickerVC.pickerView setSearchInfo:_searchInfo];
    [passengerPickerVC.pickerView setDelegate:self];
    
	_popover = [[JRFPPopoverController alloc] initWithViewController:passengerPickerVC
                                                                      delegate:self
                                                                underlyingView:nil];
    [_popover setArrowDirection:FPPopoverArrowDirectionUp];
	[_popover setContentSize:kJRSearchFormPassengersPopoverSize];
	[_popover presentPopoverFromView:_passengerPopoverFromView];
}

- (void)classPickerDidSelectTravelClass {
    [self popoverDismiss];
    [self reloadSearchFormAnimated:YES];
}

- (void)showTravelClassPickerFromView:(UIView *)view {
    if (_popover) {
        return;
    }
    
    JRSearchFormTravelClassPickerVC *travelClassPickerVC = [[JRSearchFormTravelClassPickerVC alloc] initWithDelegate:self searchInfo:_searchInfo];
    
    _popover = [[JRFPPopoverController alloc] initWithViewController:travelClassPickerVC
                                                                      delegate:self
                                                                underlyingView:self.navigationController.view];
    [_popover setArrowDirection:FPPopoverArrowDirectionDown];
    [_popover setBlurTintColor:[ColorScheme popoverTintColor]];
    [_popover setContentSize:travelClassPickerVC.contentSize];
    [_popover presentPopoverFromView:view];
}

- (void)passengerViewDidChangePassengers {
    [self reloadSearchFormAnimated:NO];
}

- (void)passengerViewExceededTheAllowableNumberOfInfants {
    [[[UIAlertView alloc] initWithTitle:nil message:NSLS(@"JR_SEARCH_FORM_EXCEEDED_THE_ALLOWABLE_NUMBER_OF_INFANTS") delegate:nil cancelButtonTitle:NSLS(@"ALERT_DEFAULT_BUTTON") otherButtonTitles:nil, nil] show];
}

- (void)passengerViewDismiss {
    [self popoverDismiss];
}

- (void)popoverDismiss {
    
    [_popover dismissPopoverAnimated:YES completion:^{
        _popover = nil;
    }];
}

- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController
{
    _popover = nil;
}

- (void)saveReturnFlightTravelSegment
{
	NSUInteger objectAtIndex = 1;
    
	JRTravelSegment *travelSegment = self.searchInfo.travelSegments.count > objectAtIndex ?
    (self.searchInfo.travelSegments)[objectAtIndex] : nil;
	if (travelSegment) {
		_savedTravelSegment = travelSegment;
		[_searchInfo removeTravelSegmentsStartingFromTravelSegment:_savedTravelSegment];
		[self reloadSearchFormAnimated:NO];
	}
}

- (void)restoreReturnFlightTravelSegment
{
	NSUInteger objectAtIndex = 1;
    
	JRTravelSegment *firstTravelSegment  = _searchInfo.travelSegments.firstObject;
	JRTravelSegment *travelSegment = self.searchInfo.travelSegments.count > objectAtIndex ?
    (self.searchInfo.travelSegments)[objectAtIndex] : nil;
    
	if (firstTravelSegment && _savedTravelSegment) {
		BOOL shouldRestoreDate = [firstTravelSegment.departureDate compare:_savedTravelSegment.departureDate] != NSOrderedDescending;
        
		if (shouldRestoreDate) {
			JRTravelSegment *newTravelSegment = travelSegment;
			if (!newTravelSegment) {
				newTravelSegment = [JRTravelSegment new];
			}
			[newTravelSegment setDepartureDate:_savedTravelSegment.departureDate];
			BOOL shouldRestoreOrigin = [JRSDKModelUtils airport:firstTravelSegment.destinationAirport isEqualToAirport:_savedTravelSegment.destinationAirport];
			BOOL shouldRestoreDestination = [JRSDKModelUtils airport:firstTravelSegment.originAirport isEqualToAirport:_savedTravelSegment.destinationAirport];
            
			if (shouldRestoreOrigin) {
				[newTravelSegment setOriginAirport:_savedTravelSegment.originAirport];
			}
			if (shouldRestoreDestination) {
				[newTravelSegment setDestinationAirport:_savedTravelSegment.destinationAirport];
			}
			[_searchInfo addTravelSegment:newTravelSegment];
			[self reloadSearchFormAnimated:NO];
			return;
		}
        
	}
	[self selectDepartureDateForTravelSegment:travelSegment itemType:JRSearchFormTableViewReturnDateItem];
}

- (void)selectDepartureDateForTravelSegment:(JRTravelSegment *)travelSegment itemType:(JRSearchFormItemType)type
{
    if (!travelSegment) {
        travelSegment = [JRTravelSegment new];
        [_searchInfo addTravelSegment:travelSegment];
    }
    
	JRDatePickerMode mode = JRDatePickerModeDefault;
	if (type == JRSearchFormTableViewDirectDateItem) {
		mode = JRDatePickerModeDeparture;
	} else if (type == JRSearchFormTableViewReturnDateItem) {
        while (_searchInfo.travelSegments.count < 2) {
            travelSegment = [JRTravelSegment new];
            [_searchInfo addTravelSegment:travelSegment];
        }
		mode = JRDatePickerModeReturn;
	}
    
	JRDatePickerVC *datePicker = [[JRDatePickerVC alloc] initWithSearchInfo:_searchInfo
                                                              travelSegment:travelSegment
                                                                       mode:mode];
	if ([self scene]) {
        [self attachAccessoryViewController:datePicker width:[JRScreenSceneController screenSceneControllerTallViewWidth] exclusiveFocus:YES animated:YES];
	} else {
		[self.navigationController pushViewController:datePicker animated:YES];
	}
}

- (void)accessoryWillDetach {
    [super accessoryWillDetach];
    [self reloadSearchFormAnimated:YES];
}

#pragma mark - Other

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[_complexSearchTable flashScrollIndicators];
}

- (CGFloat)tableView:(UITableView *)tableView heightForItemWithType:(JRSearchFormItemType)type
{
	if (type == JRSearchFormTableViewItemAirportsType) {
		return tableView.frame.size.height * kJRSearchFormAirportsFraction;
	} else if (type == JRSearchFormTableViewItemDatesType) {
		return tableView.frame.size.height * kJRSearchFormDatesFraction;
	} else if (type == JRSearchFormTableViewItemTravelClassAndPassengersType) {
		return _travelClassAndPassengersTable.frame.size.height;
	} else if (type == JRSearchFormTableViewComplexSegmentItem && iPhone()) {
		return kJRSearchFormTableViewComplexCellHeightIPHONE;
	} else if (type == JRSearchFormTableViewComplexSegmentItem && iPad()) {
		return kJRSearchFormTableViewComplexCellHeightIPAD;
	} else if (type == JRSearchFormTableViewComplexAddSegmentItem) {
		return kJRSearchFormTableViewAddCellHeight;
	} else {
		return tableView.frame.size.height * kJRSearchFormCellFromTableInCellFraction;
	}
	return 44;
}

#pragma mark Perform search

- (void)performSearchWithInfo:(JRSearchInfo *)searchInfo {
	if (self.navigationController.viewControllers.lastObject != self && self.navigationController.viewControllers.lastObject != self.scene) {
		return;
	}

    JRWaitingViewController *const waitingVC = [[JRWaitingViewController alloc] initWithSearchInfo:searchInfo];
	waitingVC.delegate = self;
    if ([self scene]) {
        JRScreenScene *scene = [JRScreenSceneController screenSceneWithMainViewController:waitingVC
                                                                                    width:[JRScreenSceneController screenSceneControllerWideViewWidth]
                                                                  accessoryViewController:nil
                                                                                    width:kNilOptions
                                                                           exclusiveFocus:NO];
        [self.sceneViewController pushScreenScene:scene animated:YES];
    } else {
        [self.navigationController pushViewController:waitingVC animated:YES];
    }
    
    [waitingVC performSearch];
	self.waitingScreen = waitingVC;
    [self saveLastUsedSearchInfo:_searchInfo];
}

- (void)showSearchResults:(id<JRSDKSearchResult>)result withSearchInfo:(JRSearchInfo *)searchInfo {
    
    NSString *xibName = @"ASTResults";
    if (AVIASALES_VC_GRANDPA_IS_TABBAR) {
        xibName = @"ASTResultsTabBar";
    }
    

    if ([self scene]) {
        NSString *xibName = @"ASTFilters";
        if (AVIASALES_VC_GRANDPA_IS_TABBAR) {
            xibName = @"ASTFiltersTabBar";
        }
        
        ASTFilters *const filtersVC = [[ASTFilters alloc] initWithNibName:xibName bundle:AVIASALES_BUNDLE];
        ASTResults *const resultsVC = [[ASTResults alloc] initWithSearchInfo:searchInfo
                                                                    response:result
                                                                    filterVC:filtersVC];
        
        [resultsVC addPopButtonToNavigationItem];
        
        JRScreenScene *const scene = [[JRScreenScene alloc] initWithViewController:resultsVC
                                                                     portraitWidth:kViewControllerWidthIPadPortraitHalfScreen
                                                                    landscapeWidth:kViewControllerWidthIPadLandscapeHalfScreen];
        
        [scene attachAccessoryViewController:filtersVC
                               portraitWidth:kViewControllerWidthIPadPortraitHalfScreen
                              landscapeWidth:kViewControllerWidthIPadLandscapeHalfScreen
                              exclusiveFocus:NO
                                    animated:NO];
        
        [self.sceneViewController replaceTopScreenSceneWith:scene];
    } else {
        ASTResults *const resultsVC = [[ASTResults alloc] initWithSearchInfo:searchInfo
                                                                    response:result];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:AVIASALES_(@"AVIASALES_BACK") style:UIBarButtonItemStylePlain target:nil action:nil];
        
        self.navigationItem.backBarButtonItem = backButton;
        
        self.navigationController.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController replaceTopViewControllerWith:resultsVC];
    }
}

- (void)cancelSearchWithError:(NSError *)error {
    [self.navigationController popViewControllerAnimated:YES];
    NSString *errorDescription;
    if (error.code == JRSDKServerAPIErrorSearchNoTickets) {
        errorDescription = NSLS(@"JR_WAITING_ERROR_NOT_FOUND_MESSAGE");
    } else if (error.code == JRSDKServerAPIErrorConnectionFailed) {
        errorDescription = NSLS(@"JR_WAITING_ERROR_CONNECTION_ERROR");
    } else {
        errorDescription = NSLS(@"JR_WAITING_ERROR_NOT_AVALIBLE_MESSAGE");
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AVIASALES_(@"AVIASALES_ALERT_ERROR_TITLE") message:errorDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - <JRWaitingViewControllerDelegate>
- (void)waitingViewController:(JRWaitingViewController *)viewController
      didFinishSearchWithInfo:(id<JRSDKSearchInfo>)searchInfo
                       result:(id<JRSDKSearchResult>)searchResult {
    [self showSearchResults:searchResult withSearchInfo:self.searchInfo];
}

- (void)waitingViewController:(JRWaitingViewController *)viewController didFinishSearchWithError:(NSError *)error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelSearchWithError:error];
    });
}

- (void)saveLastUsedSearchInfo:(JRSearchInfo *)searchInfo {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:searchInfo] forKey:kJRSearchFormLastUsedSearchInfoStorageKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (JRSearchInfo *)lastUsedSearchInfo {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kJRSearchFormLastUsedSearchInfoStorageKey];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([object isKindOfClass:[JRSearchInfo class]]) {
        return (JRSearchInfo *)object;
    }
    return nil;
}
@end
