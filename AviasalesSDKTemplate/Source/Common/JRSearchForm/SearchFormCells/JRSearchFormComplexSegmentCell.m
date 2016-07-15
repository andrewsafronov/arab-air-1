//
//  JRSearchFormComplexSegmentCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchFormComplexSegmentCell.h"
#import "UIView+JRFadeAnimation.h"
#import "UIImage+JRUIImage.h"
#import "DateUtil.h"
#import "ColorScheme.h"

#define kJRSearchFormComplexSegmentCellBoldFontSize 22
#define kJRSearchFormComplexSegmentCellRegularFontSize 15

@interface JRSearchFormComplexSegmentCell ()
@property (weak, nonatomic) IBOutlet UIButton *originButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIButton *departureButton;
@property (weak, nonatomic) IBOutlet UILabel *originIATALabel;
@property (weak, nonatomic) IBOutlet UILabel *originAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationIATALabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@end


@implementation JRSearchFormComplexSegmentCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self updateCell];
}

- (void)setTravelSegment:(JRTravelSegment *)travelSegment
{
	_travelSegment = travelSegment;
	[self updateCell];
}

- (void)updateCell
{
	[super updateCell];
    
	[self setupLabels];
	[self updateButtons];
}

- (void)setupLabels
{
    JRTravelSegment *travelSegment = self.travelSegment;
	[self setupIataLabel:_originIATALabel iata:travelSegment.originAirport.iata];
	[self setupIataLabel:_destinationIATALabel iata:self.travelSegment.destinationAirport.iata];
	[self setupAirportLabel:_originAirportLabel iata:travelSegment.originAirport.iata];
	[self setupAirportLabel:_destinationAirportLabel iata:self.travelSegment.destinationAirport.iata];
	[self setupDateLabelWithDate:self.travelSegment.departureDate];
}

- (void)setupIataLabel:(UILabel *)iataLabel iata:(NSString *)iata
{
	[iataLabel setText:[iata uppercaseString]];
}

- (void)setupAirportLabel:(UILabel *)cityLabel iata:(NSString *)iata
{
    id <JRSDKAirport> airport = [[[AviasalesSDK sharedInstance] airportsStorage] findAnythingByIATA:iata];
	if (airport.city) {
        [cityLabel setText:[airport.city uppercaseString]];
    } else if (airport) {
        [cityLabel setText:@"…"];
    } else {
        [cityLabel setText:nil];
    }
}

- (void)setupDateLabelWithDate:(NSDate *)date
{
	NSString *yearString  = nil;
	NSString *dateString  = nil;
    
	if (date) {
		NSArray *dmy = [DateUtil dayMonthYearComponentsFromDate:date];
		NSString *day = [dmy firstObject];
		NSString *month = [dmy[1] uppercaseString];
		yearString = dmy[2];
        
        BOOL dayBeforeMonth = [[DateUtil dayMonthStringFromDate:date] rangeOfString:month options:NSCaseInsensitiveSearch].location > 0;
        if (dayBeforeMonth) {
            dateString = [NSString stringWithFormat:@"%@ %@", day, month];
        } else {
            dateString = [NSString stringWithFormat:@"%@ %@", month, day];
        }
	}
    
	[_dateLabel setText:dateString];
	[_yearLabel setText:yearString];
}

- (void)updateButtons
{
	UIImage *originImage = [[UIImage imageNamed:@"JRSearchFormAirportPin"] imageTintedWithColor:[ColorScheme buttonBackgroundColor]];
	if (_originIATALabel.text.length > 0) {
		[_originButton setImage:nil forState:UIControlStateNormal];
        [_originButton setImage:nil forState:UIControlStateHighlighted];
        _originButton.accessibilityLabel = [NSString stringWithFormat:@"%@: %@ – %@", NSLS(@"JR_SEARCH_FORM_COMPLEX_ORIGIN"), _originIATALabel.text, _originAirportLabel.text];
	} else {
		[_originButton setImage:originImage forState:UIControlStateNormal];
        [_originButton setImage:[originImage imageByApplyingAlpha:0.5] forState:UIControlStateHighlighted];
        _originButton.accessibilityLabel = [NSString stringWithFormat:@"%@: %@", NSLS(@"JR_SEARCH_FORM_COMPLEX_ORIGIN"), NSLS(@"JR_SEARCH_FORM_COMPLEX_PLACEHOLDER_AIRPORT_CELL_ACC")];
	}
    
	UIImage *destinationImage = [[UIImage imageNamed:@"JRSearchFormAirportPin"] imageTintedWithColor:[ColorScheme buttonBackgroundColor]];
	if (_destinationIATALabel.text.length > 0) {
		[_destinationButton setImage:nil forState:UIControlStateNormal];
        [_destinationButton setImage:nil forState:UIControlStateHighlighted];
        _destinationButton.accessibilityLabel = [NSString stringWithFormat:@"%@: %@ – %@", NSLS(@"JR_SEARCH_FORM_COMPLEX_DESTINATION"), _destinationIATALabel.text, _destinationAirportLabel.text];
	} else {
		[_destinationButton setImage:destinationImage forState:UIControlStateNormal];
        [_destinationButton setImage:[destinationImage imageByApplyingAlpha:0.5] forState:UIControlStateHighlighted];
        _destinationButton.accessibilityLabel = [NSString stringWithFormat:@"%@: %@", NSLS(@"JR_SEARCH_FORM_COMPLEX_DESTINATION"), NSLS(@"JR_SEARCH_FORM_COMPLEX_PLACEHOLDER_AIRPORT_CELL_ACC")];
	}
    
	UIImage *dapartureDateImage = [[UIImage imageNamed:@"JRSearchFormCalendarIcon"] imageTintedWithColor:[ColorScheme buttonBackgroundColor]];
	if (_dateLabel.text.length > 0) {
		[_departureButton setImage:nil forState:UIControlStateNormal];
        [_departureButton setImage:nil forState:UIControlStateHighlighted];
        _departureButton.accessibilityLabel = [NSString stringWithFormat:@"%@: %@", NSLS(@"JR_SEARCH_FORM_COMPLEX_DATE"), [DateUtil dayFullMonthYearStringFromDate:self.travelSegment.departureDate]];
	} else {
		[_departureButton setImage:dapartureDateImage forState:UIControlStateNormal];
        [_departureButton setImage:[dapartureDateImage imageByApplyingAlpha:0.5] forState:UIControlStateHighlighted];
        _departureButton.accessibilityLabel = [NSString stringWithFormat:@"%@: %@", NSLS(@"JR_SEARCH_FORM_COMPLEX_DATE"), NSLS(@"JR_SEARCH_FORM_COMPLEX_PLACEHOLDER_AIRPORT_CELL_ACC")];
	}
}

- (IBAction)selectOriginAirport:(id)sender
{
	[self.item.itemDelegate selectOriginIATAForTravelSegment:self.travelSegment itemType:self.item.type];
}

- (IBAction)selectDestinationAirport:(id)sender
{
	[self.item.itemDelegate selectDestinationIATAForTravelSegment:self.travelSegment itemType:self.item.type];
}

- (IBAction)selectDepartureDate:(id)sender
{
	[self.item.itemDelegate selectDepartureDateForTravelSegment:self.travelSegment itemType:self.item.type];
}

- (BOOL)shouldGroupAccessibilityChildren
{
    return NO;
}

@end
