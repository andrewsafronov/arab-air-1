//
//  JRAirportPickerCellWithAirport.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRAirportPickerCellWithAirport.h"
#import "JRSearchInfoUtils.h"
#import "JRColorScheme.h"
#import "JRAirport+LocalizedName.h"

static const CGFloat kIATAFontSize = 15;

@interface JRAirportPickerCellWithAirport ()

@property (weak, nonatomic) IBOutlet UILabel *cityAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *iataCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end

@implementation JRAirportPickerCellWithAirport

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cityAirportLabel.textColor = [JRColorScheme darkTextColor];
    self.iataCodeLabel.textColor = [JRColorScheme darkTextColor];
}

- (void)setAirport:(id<JRSDKAirport>)airport
{
    _airport = airport;
    
    [self setupAirportLabel];
    [self setupIataCodeLabel];
}

- (void)setupIataCodeLabel
{
    NSString *iataString = [_airport.iata uppercaseString];
    
    NSRange anyAirportRange = [self.iataCodeLabel.attributedText.string.uppercaseString
                               rangeOfString:NSLS(@"JR_ANY_AIRPORT").uppercaseString options:NSCaseInsensitiveSearch];
    
    UIColor *iataLabelColor = anyAirportRange.location != NSNotFound ? [JRColorScheme darkTextColor] : [JRColorScheme lightTextColor];
    
    NSMutableAttributedString *attIataString;
    
    if (iataString) {
        attIataString = [[NSMutableAttributedString alloc] initWithString:iataString];
        
        NSRange range = NSMakeRange(0, iataString.length);
        
        [attIataString addAttribute:NSForegroundColorAttributeName
                              value:iataLabelColor
                              range:range];
        
        
        
        NSArray *searchStringsArray = [_searchString componentsSeparatedByString:@" "];
        
        for (NSString *searchStringComponent in searchStringsArray) {
            
            NSRange iataRangeOfSearchString = [searchStringComponent rangeOfString:iataString
                                                                           options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch ];
            UIFont *font = iataRangeOfSearchString.location != NSNotFound ? [UIFont boldSystemFontOfSize:kIATAFontSize] : [UIFont systemFontOfSize:kIATAFontSize];
            
            [attIataString addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    
    [_iataCodeLabel setAttributedText:attIataString];
    
}

- (void)setupAirportLabel {
    NSString *cityString = _airport.city;
    NSString *airportNameString = [JRAirport localizedNameForAirport:_airport];
    NSString *countryNameString = _airport.country;
    
    NSMutableString *airportCountryString = [[NSMutableString alloc] init];
    if (airportNameString.length > 0) {
        [airportCountryString appendString:airportNameString];
    }
    if (countryNameString.length > 0) {
        if (airportCountryString.length > 0) {
            [airportCountryString appendString:@", "];
        }
        [airportCountryString appendString:countryNameString];
    }

    self.cityAirportLabel.text = cityString;
    self.countryLabel.text = airportCountryString;
}

@end
