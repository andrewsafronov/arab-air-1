//
//  JRFlightCell.m
//  AviasalesSDKTemplate
//

#import "JRFlightCell.h"
#import "UIImageView+WebCache.h"
#import "DateUtil.h"

@implementation JRFlightCell

+ (NSNumberFormatter *)flightNumberFormatter {
    static NSNumberFormatter *flightNumberFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        flightNumberFormatter = [NSNumberFormatter new];
        flightNumberFormatter.groupingSize = 0;
    });
    
    return flightNumberFormatter;
}

+ (NSDateFormatter *)timeFormatter {
    static NSDateFormatter *timeFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        timeFormatter = [NSDateFormatter new];
        timeFormatter.dateFormat = @"HH:mm";
        timeFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        timeFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    });
    
    return timeFormatter;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"d MMM, EE";
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:AVIASALES__(@"AVIASALES_LANG", [NSLocale currentLocale].localeIdentifier)];
    });
    
    return dateFormatter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.separatorInset = UIEdgeInsetsMake(0.0, self.bounds.size.width, 0.0, 0.0);
}

#pragma mark Private methods

- (void)downloadAndSetupImageForImageView:(__weak UIImageView *)logo forAirline:(id<JRSDKAirline>)airline {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeApplyAffineTransform(self.logoIcon.bounds.size, CGAffineTransformMakeScale(scale, scale));
    NSURL *const url = [NSURL URLWithString:[JRSDKModelUtils airlineLogoUrlWithIATA:airline.iata size:size]];
    
    logo.image = nil;
    logo.highlightedImage = nil;
    logo.hidden = YES;
    [logo sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            logo.hidden = (error == nil);
    }];
}

#pragma mark JRTicketCellProtocol methods

- (void)applyFlight:(id<JRSDKFlight>)flight {
    self.durationLabel.text = [NSString stringWithFormat:@"%@: %@", AVIASALES_(@"AVIASALES_FLIGHT_DURATION"),
                               [DateUtil formatDurationInMinutes:flight.duration.integerValue toHourAndMinutesStringWithFormat:AVIASALES_(@"AVIASALES_DURATION_FORMAT")]];
    
    self.departureTimeLabel.text = [[JRFlightCell timeFormatter] stringFromDate:flight.departureDate];
    
    self.arrivalTimeLabel.text = [[JRFlightCell timeFormatter] stringFromDate:flight.arrivalDate];
    
    self.departureDateLabel.text = [[JRFlightCell dateFormatter] stringFromDate:flight.departureDate];
    
    self.arrivalDateLabel.text = [[JRFlightCell dateFormatter] stringFromDate:flight.arrivalDate];
    
    self.originLabel.text = [NSString stringWithFormat:@"%@ %@", flight.originAirport.city, flight.originAirport.iata];
    
    self.destinationLabel.text = [NSString stringWithFormat:@"%@ %@", flight.destinationAirport.city, flight.destinationAirport.iata];
    
    NSNumber *const flightNumber = [[JRFlightCell flightNumberFormatter] numberFromString:flight.number];
    self.flightNumberLabel.text = [NSString localizedStringWithFormat:@"%@ %@-%@", AVIASALES_(@"AVIASALES_FLIGHT"), flight.airline.iata, [[JRFlightCell flightNumberFormatter] stringFromNumber:flightNumber]];
    
    [self downloadAndSetupImageForImageView:self.logoIcon forAirline:flight.airline];
}

@end
