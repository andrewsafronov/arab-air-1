//
//  JRFilterVC_ipad.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 22/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterVC_ipad.h"

#import "JRFilter.h"
#import "JRSearchInfoUtils.h"
#import "JRScreenSceneController.h"

#import "UIViewController+JRScreenSceneController.h"


@interface JRFilterVC (Protected)

@property (weak, nonatomic) IBOutlet UILabel     *toolbarLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView      *toolbarView;

@property (strong, nonatomic, readonly) JRFilter *filter;
@property (assign, nonatomic, readonly) JRFilterMode filterMode;

- (void)setupNavigationBar;
- (void)updateToolbar;
- (void)showFiltersForTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

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
    
    self.directionInfoLabel.text =
    self.datesIntervalString.text = [JRSearchInfoUtils formattedDatesForSearchInfo:self.filter.searchInfo];
    self.passengersInfoLabel.text = [JRSearchInfoUtils passengersCountAndTravelClassStringWithSearchInfo:self.filter.searchInfo];
    
    self.topBarDividerLineHeightConstraint.constant = JRPixel();
    self.toolBarTopDividerHeightConstraint.constant = JRPixel();
}

#pragma mark - Override

- (void)setupNavigationBar {
    [super setupNavigationBar];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)updateToolbar {
    [super updateToolbar];
}

- (void)showFiltersForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterVC_ipad *segmentFilterVC = [[JRFilterVC_ipad alloc] initWithFilter:self.filter
                                                                 forFilterMode:JRFilterTravelSegmentMode
                                                         selectedTravelSegment:travelSegment];
    [self.navigationController pushViewController:segmentFilterVC animated:YES];
}

@end
