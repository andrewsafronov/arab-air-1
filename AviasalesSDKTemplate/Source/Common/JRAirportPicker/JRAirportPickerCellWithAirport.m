//
//  JRAirportPickerCellWithAirport.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/01/14.
//
//

#import "JRAirportPickerCellWithAirport.h"
#import "JRSearchInfoUtils.h"
#import "ColorScheme.h"
#import "JRAirport+LocalizedName.h"

@interface JRAirportPickerCellWithAirport ()
@property (weak, nonatomic) IBOutlet UILabel *cityAirportLabel;
@property (weak, nonatomic) IBOutlet UILabel *iataCodeLabel;

@end

@implementation JRAirportPickerCellWithAirport

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setAirport:_airport];
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
    
    NSRange anyAirportRange = [_cityAirportLabel.attributedText.string.uppercaseString
                               rangeOfString:NSLS(@"JR_ANY_AIRPORT").uppercaseString options:NSCaseInsensitiveSearch];
    
    UIColor *iataLabelColor = anyAirportRange.location != NSNotFound ? [ColorScheme darkTextColor] : [ColorScheme lightTextColor];
    
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
            
            NSString *fontName = iataRangeOfSearchString.location != NSNotFound ? @"HelveticaNeue-Bold" : @"HelveticaNeue-Medium";
            UIFont *font = [UIFont fontWithName:fontName size:15];
            
            [attIataString addAttribute:NSFontAttributeName value:font range:range];
        }
        
        
    }
    
    [_iataCodeLabel setAttributedText:attIataString];
    
}

- (void)setupAirportLabel
{
    NSString *cityString = [_airport.city uppercaseString];
    NSString *airportNameString = [JRAirport localizedNameForAirport:_airport];
    NSString *countryNameString = [_airport.country uppercaseString];
    
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
    
    NSMutableAttributedString *airportCountryAttString = [[NSMutableAttributedString alloc]
                                                          initWithString:airportCountryString];
    
    NSMutableAttributedString *labelAttributedString = [NSMutableAttributedString new];
    if (cityString.length > 0) {
        NSMutableAttributedString *cityAttributedString = [[NSMutableAttributedString alloc]
                                                           initWithString:cityString];
        NSRange range = NSMakeRange(0, cityString.length);
        UIColor *color = [ColorScheme darkTextColor];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        [cityAttributedString addAttribute:NSFontAttributeName value:font range:range];
        [cityAttributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        [labelAttributedString appendAttributedString:cityAttributedString];
    }
    if (airportCountryAttString.length && labelAttributedString.length > 0) {
        NSAttributedString *nString = [[NSAttributedString alloc] initWithString:@"\n"];
        [labelAttributedString appendAttributedString:nString];
    }
    if (airportCountryAttString.length) {
        NSRange range = NSMakeRange(0, airportCountryAttString.length);
        UIColor *color = [ColorScheme darkTextColor];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:9];
        [airportCountryAttString addAttribute:NSFontAttributeName value:font range:range];
        [airportCountryAttString addAttribute:NSForegroundColorAttributeName value:color range:range];
        [labelAttributedString appendAttributedString:airportCountryAttString];
    }
    
    NSString *labelString = [labelAttributedString string];
    NSArray *searchStringsArray = [_searchString componentsSeparatedByString:@" "];
    for (NSString *searchStringComponent in searchStringsArray) {
        NSRange range = [labelString rangeOfString:[searchStringComponent uppercaseString] options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch ];
        [labelAttributedString addAttribute:NSForegroundColorAttributeName value:[ColorScheme darkTextColor] range:range];
    }
    [_cityAirportLabel setAttributedText:labelAttributedString];
}

@end
