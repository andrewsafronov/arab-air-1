//
//  JRSearchFormAirportCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchFormAirportCell.h"
#import "UIImage+JRUIImage.h"
#import <AviasalesSDK/AviasalesSDK.h>
#import "JRColorScheme.h"
#import "JRAirport+LocalizedName.h"

@interface JRSearchFormAirportCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iataLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end


@implementation JRSearchFormAirportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // TODO: tinted image
    _pinImageView.image = [UIImage imageWithColor:[JRColorScheme buttonBackgroundColor]];
//    [_pinImageView setImage:[_pinImageView.image imageTintedWithColor:[JRC SF_CELL_IMAGES_TINT]]];
}


- (void)setupAirportLabelWithAirport:(id<JRSDKAirport>)airport item:(JRSearchFormItem *)item{
	NSString *placeholderString = nil;
	NSString *cityString = [airport.city uppercaseString];
	NSString *countryNameString = [airport.country uppercaseString];
	NSMutableString *airportCountryString = [[NSMutableString alloc] init];
    
	if (airport) {
		NSString *airportNameString = [JRAirport localizedNameForAirport:airport];

		if (airportNameString.length > 0 && airport.city) {
			[airportCountryString appendString:airportNameString];
		} else {
            [airportCountryString appendString:@"…"];
        }
        
		if (countryNameString.length > 0) {
			if (airportCountryString.length > 0) {
				[airportCountryString appendString:@", "];
			}
			[airportCountryString appendString:countryNameString];
		}
        
	} else {
		if (item.type == JRSearchFormTableViewOriginAirportItem) {
			placeholderString = NSLS(@"JR_SEARCH_FORM_AIRPORT_CELL_EMPTY_ORIGIN");
		} else if (item.type == JRSearchFormTableViewDestinationAirportItem) {
			placeholderString = NSLS(@"JR_SEARCH_FORM_AIRPORT_CELL_EMPTY_DESTINATION");
		}
		placeholderString = [placeholderString uppercaseString];
	}
    
	[_placeholderLabel setText:placeholderString];
	[_cityNameLabel setText:cityString];
    
    [_airportNameLabel setText:airportCountryString];
    [_airportNameLabel setHidden:_airportNameLabel.text.length > 0 ? NO : YES];
}


- (void)setupIataLabelForSearchInfo:(JRSearchInfo *)searchInfo item:(JRSearchFormItem *)item {
	id<JRSDKAirport> airport = nil;
    
	JRTravelSegment *travelSegment = [searchInfo.travelSegments firstObject];
	if (item.type == JRSearchFormTableViewOriginAirportItem) {
		airport = [travelSegment originAirport];
	} else if (item.type == JRSearchFormTableViewDestinationAirportItem) {
		airport = [travelSegment destinationAirport];
	}
	[_iataLabel setText:[[airport iata] uppercaseString]];
    
    [self setupAirportLabelWithAirport:airport item:item];
}

- (void)updateCell {
	[self setupIataLabelForSearchInfo:self.searchInfo item:self.item];
}

- (void)action {
	JRTravelSegment *travelSegment = [self.item.itemDelegate.searchInfo.travelSegments firstObject];
	if (self.item.type == JRSearchFormTableViewOriginAirportItem) {
		[self.item.itemDelegate selectOriginIATAForTravelSegment:travelSegment itemType:self.item.type];
	} else if (self.item.type == JRSearchFormTableViewDestinationAirportItem) {
		[self.item.itemDelegate selectDestinationIATAForTravelSegment:travelSegment itemType:self.item.type];
	}
}

@end
