//
//  JRSearchInfoUtils.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchInfoUtils.h"
#import "JRSearchInfo.h"
#import "JRAirport.h"
#import "DateUtil.h"
#import "JRTravelSegment.h"

static NSString *formattedDate(NSDate *date, BOOL includeMonth, BOOL includeYear, BOOL numberRepresentation);

@implementation JRSearchInfoUtils

+ (NSArray *)getDirectionIATAsForSearchInfo:(JRSearchInfo *)searchInfo {
	NSMutableArray *iatas = [NSMutableArray new];
	for (JRTravelSegment *travelSegment in searchInfo.travelSegments) {
		NSString *originIATA = travelSegment.originAirport.iata;
		if (originIATA) {
			[iatas addObject:originIATA];
		}
		NSString *destinationIATA = travelSegment.destinationAirport.iata;
		if (destinationIATA) {
			[iatas addObject:destinationIATA];
		}
	}
	if (searchInfo.isDirectReturnFlight && iatas.count > 2) {
		NSArray *directReturnIATAs = nil;
		NSRange directReturnIATAsRange = NSMakeRange(0, 2);
		directReturnIATAs = [iatas subarrayWithRange:directReturnIATAsRange];
		return directReturnIATAs;
	} else {
		return iatas;
	}
}

+ (NSArray *)getMainIATAsForSearchInfo:(JRSearchInfo *)searchInfo {
	NSMutableArray *iatasForSearchInfo = [[self getDirectionIATAsForSearchInfo:searchInfo] mutableCopy];
	NSMutableArray *mainIATAsForSearchInfo = [NSMutableArray new];
	for (NSString *iata in iatasForSearchInfo) {
		NSString *mainIATA = [[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:iata];
		if (mainIATA) {
			[mainIATAsForSearchInfo addObject:mainIATA];
		}
	}
	return mainIATAsForSearchInfo;
}

+ (NSArray *)datesForSearchInfo:(JRSearchInfo *)searchInfo {
	NSMutableArray *dates = [NSMutableArray new];
    
	for (JRTravelSegment *travelSegment in searchInfo.travelSegments) {
		NSDate *departureDate = travelSegment.departureDate;
		if (departureDate) {
			[dates addObject:departureDate];
		}
	}
	return dates;
}

+ (NSString *)shortDirectionIATAStringForSearchInfo:(JRSearchInfo *)searchInfo {
	NSArray *iatas = [self getDirectionIATAsForSearchInfo:searchInfo];
    
    NSString *separator = searchInfo.isComplexSearch ? @" … " : @" — ";
	return [NSString stringWithFormat:@"%@ %@ %@", iatas.firstObject, separator, iatas.lastObject];
}

+ (NSString *)fullDirectionIATAStringForSearchInfo:(JRSearchInfo *)searchInfo {
    NSMutableString *directionString = [NSMutableString new];
    for (JRTravelSegment *travelSegment in searchInfo.travelSegments) {
        if (travelSegment != searchInfo.travelSegments.firstObject) {
            [directionString appendString:@"  "];
        }
        [directionString appendFormat:@"%@—%@", travelSegment.originAirport.iata, travelSegment.destinationAirport.iata];
    }
	return directionString;
}

+ (NSString *)fullDirectionCityStringForSearchInfo:(JRSearchInfo *)searchInfo {
    NSArray *iatas = [self getDirectionIATAsForSearchInfo:searchInfo];
    NSMutableString *directionString = [NSMutableString new];
	for (NSInteger i = 0; i < iatas.count; i++) {
		NSString *iata = iatas[i];
        id <JRSDKAirport> airport = [[[AviasalesSDK sharedInstance] airportsStorage] findAnythingByIATA:iata];
        NSString *airportCity = airport.city ? airport.city : iata;
		[directionString appendString:airportCity];
		if (i != iatas.count - 1) {
			[directionString appendString:@" — "];
		}
	}
	return directionString;
}

+ (NSString *)datesIntervalStringWithSearchInfo:(JRSearchInfo *)searchInfo {
	NSString *datesString;
    
	NSDate *firstDate = [searchInfo.travelSegments.firstObject departureDate];
	NSDate *lastDate = searchInfo.travelSegments.count > 1 ?[searchInfo.travelSegments.lastObject departureDate] : nil;
    
	if (lastDate) {
		datesString = [NSString stringWithFormat:@"%@ — %@", iPhone() ?[DateUtil dayMonthStringFromDate:firstDate] : [DateUtil dayFullMonthYearStringFromDate:firstDate], iPhone() ?[DateUtil dayMonthStringFromDate:lastDate] : [DateUtil dayFullMonthYearStringFromDate:lastDate]];
	} else {
		datesString = [NSString stringWithFormat:@"%@", iPhone() ?[DateUtil dayFullMonthStringFromDate:firstDate] : [DateUtil dayFullMonthYearStringFromDate:firstDate]];
	}
	return datesString;
}

+ (NSString *)passengersCountAndTravelClassStringWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo {
    NSString *passengersCountStringWithSearchInfo = [JRSearchInfoUtils passengersCountStringWithSearchInfo:searchInfo];
    return [NSString stringWithFormat:@"%@, %@", passengersCountStringWithSearchInfo, [JRSearchInfoUtils travelClassStringWithSearchInfo:searchInfo].lowercaseString];
}

+ (NSString *)passengersCountStringWithSearchInfo:(JRSearchInfo *)searchInfo {
	NSInteger passengers = searchInfo.adults + searchInfo.children  + searchInfo.infants;
    NSString *format = NSLSP(@"JR_SEARCHINFO_PASSENGERS", passengers);
	return [NSString stringWithFormat:format, passengers];
}

+ (NSString *)travelClassStringWithSearchInfo:(JRSearchInfo *)searchInfo {
    return [self travelClassStringWithTravelClass:searchInfo.travelClass];
}

+ (NSString *)travelClassStringWithTravelClass:(JRSDKTravelClass)travelClass {
    switch (travelClass) {
        case JRSDKTravelClassBusiness : {
            return NSLS(@"JR_SEARCHINFO_BUSINESS");
        } break;
        case JRSDKTravelClassPremiumEconomy : {
            return NSLS(@"JR_SEARCHINFO_PREMIUM_ECONOMY");
        } break;
        case JRSDKTravelClassFirst : {
            return NSLS(@"JR_SEARCHINFO_FIRST");
        } break;
        default : {
            return NSLS(@"JR_SEARCHINFO_ECONOMY");
        } break;
    }
}

+ (NSString *)formattedIatasForSearchInfo:(id<JRSDKSearchInfo>)searchInfo {
    NSMutableArray *const iatas = [NSMutableArray array];
    for (id<JRSDKTravelSegment> travelSegment in searchInfo.travelSegments) {
        [iatas addObject:travelSegment.originAirport.iata];
    }
    JRSDKIATA const lastIata = searchInfo.travelSegments.lastObject.destinationAirport.iata;
    if (![iatas[0] isEqualToString:lastIata]) {
        [iatas addObject:lastIata];
    }
    NSString *result;
    if (iatas.count > 2) {
        result = [NSString stringWithFormat:@"%@ – … –  %@", iatas[0], iatas[iatas.count - 1]];
    } else {
        result = [NSString stringWithFormat:@"%@ — %@", iatas[0], iatas[iatas.count - 1]];
    }
    return result;
}

+ (NSString *)formattedDatesForSearchInfo:(id<JRSDKSearchInfo>)searchInfo {
    id<JRSDKTravelSegment> const firstTravelSegment = searchInfo.travelSegments.firstObject;
    if (firstTravelSegment.departureDate == nil) {
        return nil;
    }

    NSCalendar *const calendar = [NSCalendar currentCalendar];
    const NSCalendarUnit necessaryDateComponents = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *const departureDateComponents = [calendar components:necessaryDateComponents fromDate:firstTravelSegment.departureDate];
    NSDateComponents *const currentYear = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];

    if (searchInfo.travelSegments.count == 1) {
        return formattedDate(firstTravelSegment.departureDate, YES, departureDateComponents.year != currentYear.year, NO);
    }

    id<JRSDKTravelSegment> const lastTravelSegment = searchInfo.travelSegments.lastObject;

    NSDateComponents *const returnDateComponents = [calendar components:necessaryDateComponents fromDate:lastTravelSegment.departureDate];

    BOOL departureIncludeMonth = NO;
    BOOL departureIncludeYear = NO;
    BOOL returnIncludeMonth = YES;
    BOOL returnIncludeYear = returnDateComponents.year != currentYear.year;

    if (returnDateComponents.year != departureDateComponents.year) {
        departureIncludeMonth = YES;
        departureIncludeYear = YES;
        returnIncludeYear = YES;
    } else if (returnDateComponents.month != departureDateComponents.month) {
        departureIncludeMonth = YES;
    }

    const BOOL numberRepresentation = searchInfo.travelSegments.count > 2;

    NSString *const formattedDeparture = formattedDate(firstTravelSegment.departureDate, departureIncludeMonth, departureIncludeYear, numberRepresentation);
    NSString *const formattedReturn = formattedDate(lastTravelSegment.departureDate, returnIncludeMonth, returnIncludeYear, numberRepresentation);
    NSString *const separator = departureIncludeMonth ? @" - " : @"-";

    return [NSString stringWithFormat:@"%@%@%@", formattedDeparture, separator, formattedReturn];
}

@end

static NSString *formattedDate(NSDate *date, BOOL includeMonth, BOOL includeYear, BOOL numberRepresentation) {
    NSString *format;
    if (numberRepresentation) {
        format = @"dd.MM";
    } else {
        if (includeMonth && includeYear) {
            format = @"dd MMM yyyy";
        } else if (includeMonth) {
            format = @"dd MMM";
        } else {
            format = @"dd";
        }
    }

    NSDateFormatter *const formatter = [NSDateFormatter applicationUIDateFormatter];
    formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:format options:kNilOptions locale:formatter.locale];
    return [formatter stringFromDate:date];
}
