#import "JRSDKSearchInfoUrlCoder.h"
#import "JRSearchInfo.h"

@implementation JRSDKSearchInfoUrlCoder

#pragma mark - <JRSDKSearchInfoCoder>

- (JRSearchInfo *)searchParamsWithString:(NSString *)encodedSearchParams {
    JRSearchInfo *result = nil;

    NSMutableArray<NSString *> *travelSegments = [[encodedSearchParams componentsSeparatedByString:@"-"] mutableCopy];

    NSString *const lastTravelSegmentPart = travelSegments.lastObject;

    NSRegularExpression *const lastTravelSegmentRegexp = [[NSRegularExpression alloc] initWithPattern: @"(.*?)(\\d)(\\d)?(\\d?)([CY])$" options:NSRegularExpressionCaseInsensitive error:nil];


    NSArray<NSTextCheckingResult *> *const matches = [lastTravelSegmentRegexp matchesInString:lastTravelSegmentPart options:0 range:NSMakeRange(0, lastTravelSegmentPart.length)];

    BOOL isMatching = matches.count > 0;

    if (isMatching) {
        NSTextCheckingResult *const match = matches[0];
        isMatching = match.resultType == NSTextCheckingTypeRegularExpression;
        if (isMatching) {
            result = [[JRSearchInfo alloc] init];

            NSString *const lastTravelSegmentValue = [lastTravelSegmentPart substringWithRange: [match rangeAtIndex:1]];
            travelSegments[travelSegments.count - 1] = lastTravelSegmentValue;

            const NSRange adultsPartRange = [match rangeAtIndex:2];
            const NSRange childrenPartRange = [match rangeAtIndex:3];
            const NSRange infantsPartRange = [match rangeAtIndex:4];
            const NSRange travelSegmentPartRange = [match rangeAtIndex:5];

            result.adults = [[lastTravelSegmentPart substringWithRange:adultsPartRange] integerValue];
            result.children = childrenPartRange.location != NSNotFound ? [[lastTravelSegmentPart substringWithRange:childrenPartRange] integerValue] : 0;
            result.infants = infantsPartRange.location != NSNotFound ? [[lastTravelSegmentPart substringWithRange:infantsPartRange] integerValue] : 0;
            result.travelClass = [JRSDKSearchInfoUrlCoder decodeTravelClass:[lastTravelSegmentPart substringWithRange:travelSegmentPartRange]];

            [self decodeTravelSegments:travelSegments toSearchInfo:result];
            return result;
        }
    }
    return result;
}

- (NSString *)encodeSearchParams:(id<JRSDKSearchInfo>)searchParams {
    NSMutableArray *const travelSegments = [NSMutableArray arrayWithCapacity:3];
    id<JRSDKTravelSegment> const firstTravelSegment = searchParams.travelSegments.firstObject;

    NSString *const directTravelSegment = [[self class] encodeTravelSegmentFrom:firstTravelSegment.originAirport.iata
                                                                            to:firstTravelSegment.destinationAirport.iata
                                                                          date:firstTravelSegment.departureDate];
    [travelSegments addObject:directTravelSegment];

    if (searchParams.travelSegments.count > 1) {
        id<JRSDKTravelSegment> const returnTravelSegment = searchParams.travelSegments.lastObject;
        NSString *const encodedReturnTravelSegment = [[self class] encodeTravelSegmentFrom:returnTravelSegment.originAirport.iata
                                                                                        to:returnTravelSegment.destinationAirport.iata
                                                                                      date:returnTravelSegment.departureDate];
        [travelSegments addObject:encodedReturnTravelSegment];
    }

    NSMutableString *const result = [[travelSegments componentsJoinedByString:@"-"] mutableCopy];

    NSString *const passengerInfo = [[self class] encodePassengerInfo:searchParams];
    [result appendString:passengerInfo];

    NSString *const travelClassInfo = [[self class] encodeTravelClass:searchParams.travelClass];
    [result appendString:travelClassInfo];

    return result;
}

#pragma mark - Private

- (void)decodeTravelSegments:(NSArray<NSString *> *)travelSegments toSearchInfo:(JRSearchInfo *)searchInfo {
    NSParameterAssert(travelSegments.count < 3);
    NSParameterAssert(searchInfo != nil);

    NSMutableOrderedSet<id<JRSDKTravelSegment>> *const decodedTravelSegments = [NSMutableOrderedSet orderedSetWithCapacity:travelSegments.count];
    id<AviasalesAirportsStorageProtocol> const airportStorage = [AviasalesSDK sharedInstance].airportsStorage;
    const NSRange dateRange = NSMakeRange(3, 4);
    for (NSString *encodedTravelSegment in travelSegments) {
        NSString *const originIATA = [encodedTravelSegment substringToIndex:3];
        NSString *const destinationIATA = [encodedTravelSegment substringFromIndex:7];

        JRTravelSegment *const travelSegment = [[JRTravelSegment alloc] init];
        travelSegment.originAirport = [airportStorage findAnythingByIATA:originIATA];
        travelSegment.destinationAirport = [airportStorage findAnythingByIATA:destinationIATA];
        travelSegment.departureDate = [NSDate aviasales_dateWithDayMonthString:[encodedTravelSegment substringWithRange:dateRange]];

        [decodedTravelSegments addObject:travelSegment];
    }

    searchInfo.travelSegments = [decodedTravelSegments copy];
}

+ (NSString *)encodeTravelSegmentFrom:(NSString *)originIATA to:(NSString *)destinationIATA date:(NSDate *)date {
    NSParameterAssert(originIATA.length == 3);
    NSParameterAssert(destinationIATA.length == 3);
    NSParameterAssert(date != nil);

    NSString *const dateRepresentation = [date aviasales_fastDayMonthString];
    return [NSString stringWithFormat:@"%@%@%@", originIATA, dateRepresentation, destinationIATA];
}

+ (NSString *)encodePassengerInfo:(id<JRSDKSearchInfo>)searchInfo {
    NSMutableString *const result = [[NSMutableString alloc] initWithCapacity:3];

    [result appendFormat:@"%ld", (long)searchInfo.adults];

    if (searchInfo.children > 0 || searchInfo.infants > 0) {
        [result appendFormat:@"%ld", (long)searchInfo.children];
        [result appendFormat:@"%ld", (long)searchInfo.infants];
    }
    return [result copy];
}

+ (NSString *)encodeTravelClass:(JRSDKTravelClass)travelClass {
    NSParameterAssert(travelClass < 2); //according to documentation

    switch (travelClass) {
        case JRSDKTravelClassBusiness:
            return @"C";
        default:
            return @"Y";
    }
}

+ (JRSDKTravelClass)decodeTravelClass:(NSString *)encodedTravelClass {
    NSParameterAssert(encodedTravelClass.length == 1);
    if ([encodedTravelClass isEqualToString:@"C"]) {
        return JRSDKTravelClassBusiness;
    } else {
        return JRSDKTravelClassEconomy;
    }
}
@end
