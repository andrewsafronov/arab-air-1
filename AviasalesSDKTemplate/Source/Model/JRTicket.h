//
//  JRTicket.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>

@interface JRTicket : NSObject <JRSDKTicket>

@property (nonatomic, strong) NSOrderedSet<id<JRSDKPrice>> *prices;

@property (nonatomic, weak) id<JRSDKSearchInfo> searchInfo;

+ (JRTicket *)ticketByCopyingFieldsFromTicket:(id<JRSDKTicket>)ticket;

@end