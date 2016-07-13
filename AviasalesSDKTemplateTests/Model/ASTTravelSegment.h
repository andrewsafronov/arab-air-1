#import <Foundation/Foundation.h>
#import <AviasalesSDK/AviasalesSDK.h>

@interface ASTTravelSegment : NSObject <JRSDKTravelSegment>
@property (nonatomic, retain) NSDate *departureDate;
@property (nonatomic, retain) id<JRSDKAirport> destinationAirport;
@property (nonatomic, retain) id<JRSDKAirport> originAirport;
@end
