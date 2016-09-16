//
//  JRFilterVC_ipad.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//
#import "JRFilterVC_ipad.h"

#import "JRFilter.h"
#import "JRSearchInfoUtils.h"
#import "JRScreenSceneController.h"
#import "JRColorScheme.h"

#import "UIViewController+JRScreenSceneController.h"


@interface JRFilterVC (Protected)

@property (weak, nonatomic) IBOutlet UILabel     *toolbarLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView      *toolbarView;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (strong, nonatomic, readonly) JRFilter *filter;
@property (assign, nonatomic, readonly) JRFilterMode filterMode;


- (void)setupNavigationBar;
- (void)updateToolbar;
- (void)showFiltersForTravelSegment:(id<JRSDKTravelSegment>)travelSegment;
- (void)setupResetButton;
- (IBAction)resetButtonAction:(UIButton *)sender;

@end


@interface JRFilterVC_ipad ()

@property (weak, nonatomic) IBOutlet UILabel *datesIntervalString;
@property (weak, nonatomic) IBOutlet UILabel *passengersInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarDividerLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarTopDividerHeightConstraint;

@end


@implementation JRFilterVC_ipad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datesIntervalString.text = [JRSearchInfoUtils formattedDatesForSearchInfo:self.filter.searchInfo];
    self.passengersInfoLabel.text = [JRSearchInfoUtils passengersCountAndTravelClassStringWithSearchInfo:self.filter.searchInfo];
    self.directionInfoLabel.text = [JRSearchInfoUtils formattedIatasForSearchInfo:self.filter.searchInfo];
    
    self.topBarDividerLineHeightConstraint.constant = JRPixel();
    self.toolBarTopDividerHeightConstraint.constant = JRPixel();
}

#pragma mark - Override

- (void)setupResetButton {
    [self.resetButton setTitle:NSLS(@"JR_FILTER_RESET") forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[JRColorScheme inactiveLightTextColor] forState:UIControlStateDisabled];
}

- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)showFiltersForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterVC_ipad *segmentFilterVC = [[JRFilterVC_ipad alloc] initWithFilter:self.filter
                                                                 forFilterMode:JRFilterTravelSegmentMode
                                                         selectedTravelSegment:travelSegment];
    [self.navigationController pushViewController:segmentFilterVC animated:YES];
}

@end
