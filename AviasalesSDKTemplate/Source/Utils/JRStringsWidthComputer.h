//
//  JRStringsWidthComputer.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>

@interface JRStringsWidthComputer : NSObject
- (instancetype)initWithFont:(UIFont *)font;
- (CGFloat)widthWithString:(NSString *)string;
@end
