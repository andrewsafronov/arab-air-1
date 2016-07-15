//
//  JRFilterCellsFactory.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 23/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterCellsFactory.h"

#import "JRFilterTravelSegmentItem.h"
#import "JRFilterOneThumbSliderItem.h"
#import "JRFilterTwoThumbSliderItem.h"
#import "JRFilterListHeaderItem.h"
#import "JRFilterCheckBoxItem.h"

#import "JRTableViewCell.h"
#import "JRFilterTravelSegmentCell.h"
#import "JRFilterCellWithOneThumbSlider.h"
#import "JRFilterCellWithTwoThumbsSlider.h"
#import "JRFilterCheckboxCell.h"
#import "JRFilterListHeaderCell.h"

#import "DateUtil.h"

static const CGFloat kDefaultCellHeight = 50.0f;
static const CGFloat kTravelSegmentCellHeight = 65.0f;
static const CGFloat kSlidersCellSmallHeight = 90.0f;
static const CGFloat kSlidersCellBigHeight = 120.0f;

static const CGFloat kHeaderHeight = 20.0;


@interface JRFilterCellsFactory ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) JRFilterMode mode;

@end


@implementation JRFilterCellsFactory

- (instancetype)initWithTableView:(UITableView *)tableView withFilterMode:(JRFilterMode)mode {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _mode = mode;
        
        [self registerNibs];
    }
    
    return self;
}

- (nonnull UITableViewCell *)cellByItem:(nonnull id<JRFilterItemProtocol>)item {
    UITableViewCell *cell;
    
    if ([item isKindOfClass:[JRFilterTravelSegmentItem class]]) {
        JRFilterTravelSegmentCell *travelSegmentCell = (JRFilterTravelSegmentCell *)[self.tableView dequeueReusableCellWithIdentifier:@"JRFilterTravelSegmentCell"];
        travelSegmentCell.item = (JRFilterTravelSegmentItem *)item;
       
        cell = travelSegmentCell;
    } else if ([item isKindOfClass:[JRFilterOneThumbSliderItem class]]) {
        JRFilterCellWithOneThumbSlider *oneThumbCell = (JRFilterCellWithOneThumbSlider *)[self.tableView dequeueReusableCellWithIdentifier:@"JRFilterCellWithOneThumbSlider"];
        oneThumbCell.item = (JRFilterOneThumbSliderItem *)item;
 
        cell = oneThumbCell;
    } else if ([item isKindOfClass:[JRFilterTwoThumbSliderItem class]]) {
        JRFilterCellWithTwoThumbsSlider *twoThumbCell = (JRFilterCellWithTwoThumbsSlider *)[self.tableView dequeueReusableCellWithIdentifier:@"JRFilterCellWithTwoThumbsSlider"];
        twoThumbCell.item = (JRFilterTwoThumbSliderItem *)item;
        
        cell = twoThumbCell;
    } else if ([item isKindOfClass:[JRFilterCheckBoxItem class]]) {
        JRFilterCheckboxCell *checkItem = (JRFilterCheckboxCell *)[self.tableView dequeueReusableCellWithIdentifier:@"JRFilterCheckboxCell"];
        checkItem.item = (JRFilterCheckBoxItem *)item;
        
        cell = checkItem;
    } else if ([item isKindOfClass:[JRFilterListHeaderItem class]]) {
        JRFilterListHeaderCell *headerItem = (JRFilterListHeaderCell *)[self.tableView dequeueReusableCellWithIdentifier:@"JRFilterListHeaderCell"];
        headerItem.item = (JRFilterListHeaderItem *)item;
        
        cell = headerItem;
    }
    
    return cell;
}

- (CGFloat)heightForCellByItem:(nonnull id<JRFilterItemProtocol>)item {
    CGFloat height = kDefaultCellHeight;
    
    if ([item isKindOfClass:[JRFilterTravelSegmentItem class]]) {
        height = kTravelSegmentCellHeight;
    } else if ([item isKindOfClass:[JRFilterOneThumbSliderItem class]]) {
        height = kSlidersCellSmallHeight;
    } else if ([item isKindOfClass:[JRFilterDelaysDurationItem class]]) {
        height = kSlidersCellSmallHeight;
    } else if ([item isKindOfClass:[JRFilterArrivalTimeItem class]]) {
        height = kSlidersCellSmallHeight;
    } else if ([item isKindOfClass:[JRFilterDepartureTimeItem class]]) {
        height = kSlidersCellBigHeight;
    }
    
    return height;
}

- (CGFloat)heightForHeder {
    return kHeaderHeight;
}

#pragma mark - Private methds 

- (void)registerNibs {
    UINib *oneThumbSliderNib = [UINib nibWithNibName:@"JRFilterCellWithOneThumbSlider" bundle:AVIASALES_BUNDLE];
    [self.tableView registerNib:oneThumbSliderNib forCellReuseIdentifier:@"JRFilterCellWithOneThumbSlider"];
    
    UINib *twoThumbSliderNib = [UINib nibWithNibName:@"JRFilterCellWithTwoThumbsSlider" bundle:AVIASALES_BUNDLE];
    [self.tableView registerNib:twoThumbSliderNib forCellReuseIdentifier:@"JRFilterCellWithTwoThumbsSlider"];
    
    UINib *checkboxNib = [UINib nibWithNibName:@"JRFilterCheckboxCell" bundle:AVIASALES_BUNDLE];
    [self.tableView registerNib:checkboxNib forCellReuseIdentifier:@"JRFilterCheckboxCell"];
    
    UINib *headerNib = [UINib nibWithNibName:@"JRFilterListHeaderCell" bundle:AVIASALES_BUNDLE];
    [self.tableView registerNib:headerNib forCellReuseIdentifier:@"JRFilterListHeaderCell"];
    
    UINib *travelSegmentNib = [UINib nibWithNibName:@"JRFilterTravelSegmentCell" bundle:AVIASALES_BUNDLE];
    [self.tableView registerNib:travelSegmentNib forCellReuseIdentifier:@"JRFilterTravelSegmentCell"];
}

@end
