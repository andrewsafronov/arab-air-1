//
//  ASTAirport.m
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 28.06.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "ASTAirport.h"

@implementation ASTAirport
+ (instancetype)airportWithIATA:(JRSDKIATA)iata isCity:(BOOL)isCity {
    ASTAirport *const result = [[ASTAirport alloc] init];
    result.iata = iata;
    result.isCity = isCity;
    return result;
}
@end
