//
//  JRFilterTravelSegmentCell.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterTravelSegmentCell.h"

#import "JRFilterTravelSegmentItem.h"


@implementation JRFilterTravelSegmentCell

- (void)setItem:(JRFilterTravelSegmentItem *)item {
    _item = item;
    
    self.flightDirectionLabel.text = [item tilte];
    self.deparureDateLabel.text = [item detailsTitle];
}

@end
