//
//  JRFilterBoundsBuilder.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 28/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JRFilterTicketBounds;

@interface JRFilterBoundsBuilder : NSObject

@property (nonatomic, assign, readonly) BOOL isSimpleSearch;

@property (nonatomic, strong, readonly) JRFilterTicketBounds *ticketBounds;
@property (nonatomic, strong, readonly) NSArray *travelSegmentsBounds;

- (instancetype)initWithSearchResults:(nonnull NSOrderedSet <id<JRSDKTicket>> *)tickets forSearchInfo:(nonnull id<JRSDKSearchInfo>)searchInfo;

@end
