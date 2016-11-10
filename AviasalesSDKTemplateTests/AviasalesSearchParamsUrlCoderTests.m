//
//  AviasalesSearchParamsUrlCoderTests.m
//  AviasalesSDKTemplate
//
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AviasalesSDK/AviasalesSDK.h>
#import "JRSDKSearchInfoUrlCoder.h"
#import "JRSearchInfo.h"
#import "JRTravelSegment.h"
#import "JRAirport.h"

@interface JRAirport ()

@property (nonatomic, strong) JRSDKIATA iata;
@property (nonatomic, assign) BOOL isCity;

@end


@interface JRAirport (Test)

+ (JRAirport *)airportWithIATA:(JRSDKIATA)iata isCity:(BOOL)isCity;

@end


@implementation JRAirport (Test)

+ (JRAirport *)airportWithIATA:(JRSDKIATA)iata isCity:(BOOL)isCity {
    JRAirport *airport = [JRAirport new];
    airport.iata = iata;
    airport.isCity = isCity;
    
    return airport;
}

@end


@interface AviasalesSearchParamsUrlCoderTests : XCTestCase

@property (strong, nonatomic) id<JRSDKSearchInfoCoder> coder;

@end

@implementation AviasalesSearchParamsUrlCoderTests


- (void)setUp {
    [super setUp];
    self.coder = [[JRSDKSearchInfoUrlCoder alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Encoding

#pragma mark One way

- (void)testOneWayFlightWithOnePassengerCorrectlyEncodedToUrl {
    JRSearchInfo *const searchParams = [[JRSearchInfo alloc] init];

    JRTravelSegment *const travelSegment = [[JRTravelSegment alloc] init];
    travelSegment.originAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    travelSegment.destinationAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    travelSegment.departureDate = [self gmtDateFromString: @"12.05.2016"];

    searchParams.travelSegments = [NSOrderedSet orderedSetWithObject:travelSegment];
    searchParams.adults = 1;
    searchParams.travelClass = 0;

    NSString *const resultString = [self.coder encodeSearchParams:searchParams];

    XCTAssertEqualObjects(resultString, @"LED1205MOW1Y");
}

- (void)testOneWayFlightWithSevenBusinessPassengerCorrectlyEncodedToUrl {
    JRSearchInfo *const searchParams = [[JRSearchInfo alloc] init];

    JRTravelSegment *const travelSegment = [[JRTravelSegment alloc] init];
    travelSegment.originAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    travelSegment.destinationAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    travelSegment.departureDate = [self gmtDateFromString: @"12.05.2016"];

    searchParams.travelSegments = [NSOrderedSet orderedSetWithObject:travelSegment];
    searchParams.adults = 7;
    searchParams.travelClass = 1;

    NSString *const resultString = [self.coder encodeSearchParams:searchParams];

    XCTAssertEqualObjects(resultString, @"LED1205MOW7C");
}

- (void)testOneWayFlightWithDifferentPassengerCorrectlyEncodedToUrl {
    JRSearchInfo *const searchParams = [[JRSearchInfo alloc] init];

    JRTravelSegment *const travelSegment = [[JRTravelSegment alloc] init];
    travelSegment.originAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    travelSegment.destinationAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    travelSegment.departureDate = [self gmtDateFromString: @"12.05.2016"];

    searchParams.travelSegments = [NSOrderedSet orderedSetWithObject:travelSegment];
    searchParams.adults = 8;
    searchParams.children = 5;
    searchParams.infants = 3;
    searchParams.travelClass = 0;

    NSString *const resultString = [self.coder encodeSearchParams:searchParams];

    XCTAssertEqualObjects(resultString, @"LED1205MOW853Y");
}

#pragma mark Two ways

- (void)testTwoWaysFlightWithOnePassengerCorrectlyEncodedToUrl {
    JRSearchInfo *const searchParams = [[JRSearchInfo alloc] init];

    JRTravelSegment *const firstTravelSegment = [[JRTravelSegment alloc] init];
    firstTravelSegment.originAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    firstTravelSegment.destinationAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    firstTravelSegment.departureDate = [self gmtDateFromString: @"12.05.2016"];

    JRTravelSegment *const secondTravelSegment = [[JRTravelSegment alloc] init];
    secondTravelSegment.originAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    secondTravelSegment.destinationAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    secondTravelSegment.departureDate = [self gmtDateFromString: @"15.06.2016"];

    searchParams.travelSegments = [NSOrderedSet orderedSetWithObjects:firstTravelSegment, secondTravelSegment, nil];
    searchParams.adults = 1;
    searchParams.travelClass = 0;

    NSString *const resultString = [self.coder encodeSearchParams:searchParams];

    XCTAssertEqualObjects(resultString, @"LED1205MOW-MOW1506LED1Y");
}

- (void)testTwoWaysFlightWithSevenBusinessPassengerCorrectlyEncodedToUrl {
    JRSearchInfo *const searchParams = [[JRSearchInfo alloc] init];

    JRTravelSegment *const firstTravelSegment = [[JRTravelSegment alloc] init];
    firstTravelSegment.originAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    firstTravelSegment.destinationAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    firstTravelSegment.departureDate = [self gmtDateFromString: @"12.05.2016"];

    JRTravelSegment *const secondTravelSegment = [[JRTravelSegment alloc] init];
    secondTravelSegment.originAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    secondTravelSegment.destinationAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    secondTravelSegment.departureDate = [self gmtDateFromString: @"15.06.2016"];

    searchParams.travelSegments = [NSOrderedSet orderedSetWithObjects:firstTravelSegment, secondTravelSegment, nil];
    searchParams.adults = 7;
    searchParams.travelClass = 1;

    NSString *const resultString = [self.coder encodeSearchParams:searchParams];

    XCTAssertEqualObjects(resultString, @"LED1205MOW-MOW1506LED7C");
}

- (void)testTwoWaysFlightWithDifferentPassengerCorrectlyEncodedToUrl {
    JRSearchInfo *const searchParams = [[JRSearchInfo alloc] init];

    JRTravelSegment *const firstTravelSegment = [[JRTravelSegment alloc] init];
    firstTravelSegment.originAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    firstTravelSegment.destinationAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    firstTravelSegment.departureDate = [self gmtDateFromString: @"12.05.2016"];

    JRTravelSegment *const secondTravelSegment = [[JRTravelSegment alloc] init];
    secondTravelSegment.originAirport = [JRAirport airportWithIATA:@"MOW" isCity:NO];
    secondTravelSegment.destinationAirport = [JRAirport airportWithIATA:@"LED" isCity:NO];
    secondTravelSegment.departureDate = [self gmtDateFromString: @"15.06.2016"];

    searchParams.travelSegments = [NSOrderedSet orderedSetWithObjects:firstTravelSegment, secondTravelSegment, nil];
    searchParams.adults = 8;
    searchParams.children = 5;
    searchParams.infants = 3;
    searchParams.travelClass = 0;

    NSString *const resultString = [self.coder encodeSearchParams:searchParams];

    XCTAssertEqualObjects(resultString, @"LED1205MOW-MOW1506LED853Y");
}

#pragma mark One way

- (void)testOneWayFlightWithOnePassengerCorrectlyDecodedFromUrl {
    NSString *const inputString = @"LED1205MOW1Y";
    id<JRSDKSearchInfo> const searchParams = [self.coder searchParamsWithString:inputString];

    id<JRSDKTravelSegment> const firstTravelSegment = searchParams.travelSegments.firstObject;

    XCTAssertEqualObjects(firstTravelSegment.originAirport.iata, @"LED");
    XCTAssertEqualObjects(firstTravelSegment.destinationAirport.iata, @"MOW");
    NSString *const returnDateAsString = [self stringFromGMTDate: firstTravelSegment.departureDate];
    XCTAssertTrue([returnDateAsString hasPrefix:@"12.05"]);
    XCTAssertEqual(searchParams.adults, 1);
    XCTAssertEqual(searchParams.travelClass, 0);

}

- (void)testOneWayFlightWithSevenBusinessPassengerCorrectlyDecodedFromUrl {
    NSString *const inputString = @"LED1205MOW7C";
    id<JRSDKSearchInfo> const searchParams = [self.coder searchParamsWithString:inputString];

    id<JRSDKTravelSegment> const firstTravelSegment = searchParams.travelSegments.firstObject;

    XCTAssertEqualObjects(firstTravelSegment.originAirport.iata, @"LED");
    XCTAssertEqualObjects(firstTravelSegment.destinationAirport.iata, @"MOW");
    XCTAssertTrue([[self stringFromGMTDate: firstTravelSegment.departureDate] hasPrefix:@"12.05"]);
    XCTAssertEqual(searchParams.adults, 7);
    XCTAssertEqual(searchParams.travelClass, 1);
}

- (void)testOneWayFlightWithDifferentPassengerCorrectlyDecodedFromUrl {
    NSString *const inputString = @"LED1205MOW853Y";
    id<JRSDKSearchInfo> const searchParams = [self.coder searchParamsWithString:inputString];

    id<JRSDKTravelSegment> const firstTravelSegment = searchParams.travelSegments.firstObject;

    XCTAssertEqualObjects(firstTravelSegment.originAirport.iata, @"LED");
    XCTAssertEqualObjects(firstTravelSegment.destinationAirport.iata, @"MOW");
    XCTAssertTrue([[self stringFromGMTDate: firstTravelSegment.departureDate] hasPrefix:@"12.05"]);
    XCTAssertEqual(searchParams.adults, 8);
    XCTAssertEqual(searchParams.children, 5);
    XCTAssertEqual(searchParams.infants, 3);
    XCTAssertEqual(searchParams.travelClass, 0);
}

#pragma mark Two ways

- (void)testTwoWaysFlightWithOnePassengerCorrectlyDecodedFromUrl {
    NSString *const inputString = @"LED1205MOW-MOW1506LED1Y";
    id<JRSDKSearchInfo> const searchParams = [self.coder searchParamsWithString:inputString];

    XCTAssertEqual(searchParams.travelSegments.count, 2);

    id<JRSDKTravelSegment> const firstTravelSegment = searchParams.travelSegments.firstObject;

    XCTAssertEqualObjects(firstTravelSegment.originAirport.iata, @"LED");
    XCTAssertEqualObjects(firstTravelSegment.destinationAirport.iata, @"MOW");
    XCTAssertTrue([[self stringFromGMTDate: firstTravelSegment.departureDate] hasPrefix:@"12.05"]);

    id<JRSDKTravelSegment> const lastTravelSegment = searchParams.travelSegments.lastObject;

    XCTAssertEqualObjects(lastTravelSegment.originAirport.iata, @"MOW");
    XCTAssertEqualObjects(lastTravelSegment.destinationAirport.iata, @"LED");
    XCTAssertTrue([[self stringFromGMTDate: lastTravelSegment.departureDate] hasPrefix:@"15.06"]);

    XCTAssertEqual(searchParams.adults, 1);
    XCTAssertEqual(searchParams.travelClass, 0);

}

- (void)testTwoWaysFlightWithSevenBusinessPassengerCorrectlyDecodedFromUrl {
    NSString *const inputString = @"LED1205MOW-MOW1506LED7C";
    id<JRSDKSearchInfo> const searchParams = [self.coder searchParamsWithString:inputString];

    XCTAssertEqual(searchParams.travelSegments.count, 2);

    id<JRSDKTravelSegment> const firstTravelSegment = searchParams.travelSegments.firstObject;

    XCTAssertEqualObjects(firstTravelSegment.originAirport.iata, @"LED");
    XCTAssertEqualObjects(firstTravelSegment.destinationAirport.iata, @"MOW");
    XCTAssertTrue([[self stringFromGMTDate: firstTravelSegment.departureDate] hasPrefix:@"12.05"]);


    id<JRSDKTravelSegment> const lastTravelSegment = searchParams.travelSegments.lastObject;

    XCTAssertEqualObjects(lastTravelSegment.originAirport.iata, @"MOW");
    XCTAssertEqualObjects(lastTravelSegment.destinationAirport.iata, @"LED");
    XCTAssertTrue([[self stringFromGMTDate: lastTravelSegment.departureDate] hasPrefix:@"15.06"]);

    XCTAssertEqual(searchParams.adults, 7);
    XCTAssertEqual(searchParams.travelClass, 1);

}

- (void)testTwoWaysFlightWithDifferentPassengerCorrectlyDecodedFromUrl {
    NSString *const inputString = @"LED1205MOW-MOW1506LED853Y";
    id<JRSDKSearchInfo> const searchParams = [self.coder searchParamsWithString:inputString];

    XCTAssertEqual(searchParams.travelSegments.count, 2);

    id<JRSDKTravelSegment> const firstTravelSegment = searchParams.travelSegments.firstObject;

    XCTAssertEqualObjects(firstTravelSegment.originAirport.iata, @"LED");
    XCTAssertEqualObjects(firstTravelSegment.destinationAirport.iata, @"MOW");
    XCTAssertTrue([[self stringFromGMTDate: firstTravelSegment.departureDate] hasPrefix:@"12.05"]);


    id<JRSDKTravelSegment> const lastTravelSegment = searchParams.travelSegments.lastObject;

    XCTAssertEqualObjects(lastTravelSegment.originAirport.iata, @"MOW");
    XCTAssertEqualObjects(lastTravelSegment.destinationAirport.iata, @"LED");
    XCTAssertTrue([[self stringFromGMTDate: lastTravelSegment.departureDate] hasPrefix:@"15.06"]);

    XCTAssertEqual(searchParams.adults, 8);
    XCTAssertEqual(searchParams.children, 5);
    XCTAssertEqual(searchParams.infants, 3);
    XCTAssertEqual(searchParams.travelClass, 0);
}

#pragma mark - Utils

- (NSDate *)gmtDateFromString:(NSString *)string {
    return [self.gmtDateFormatter dateFromString:string];
}

- (NSString *)stringFromGMTDate:(NSDate *)date {
    return [self.gmtDateFormatter stringFromDate:date];
}

- (NSDateFormatter *)gmtDateFormatter {
    NSDateFormatter *const dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd.MM.yyyy";

    NSTimeZone *const gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];

    return dateFormatter;
}

@end
