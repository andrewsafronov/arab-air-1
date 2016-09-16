//
//  JRFilterBoundsBuilder.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>

@class JRFilterTicketBounds;

@interface JRFilterBoundsBuilder : NSObject

@property (nonatomic, assign, readonly) BOOL isSimpleSearch;

@property (nonatomic, strong, readonly) JRFilterTicketBounds *ticketBounds;
@property (nonatomic, strong, readonly) NSArray *travelSegmentsBounds;

- (instancetype)initWithSearchResults:(nonnull NSOrderedSet <id<JRSDKTicket>> *)tickets forSearchInfo:(nonnull id<JRSDKSearchInfo>)searchInfo;

@end
