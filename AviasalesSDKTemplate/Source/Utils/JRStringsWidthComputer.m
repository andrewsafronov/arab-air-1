//
//  JRStringsWidthComputer.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRStringsWidthComputer.h"

@interface JRStringsWidthComputer()
@property (strong, nonatomic, nonnull) NSCache *cache;
@property (strong, nonatomic, nonnull) NSDictionary *stringAttributes;
@end

@implementation JRStringsWidthComputer
- (instancetype)initWithFont:(UIFont *)font {
    NSParameterAssert(font != nil);

    if (self = [super init]) {
        _cache = [[NSCache alloc] init];
        _stringAttributes = @{
                              NSFontAttributeName: font
                              };
        if (_cache == nil || _stringAttributes == nil) {
            self = nil;
        }
    }
    return self;
}

- (CGFloat)widthWithString:(NSString *)string {
    NSParameterAssert(string != nil);
    NSNumber *const fromCache = [self.cache objectForKey:string];
    CGFloat result;
    if (fromCache) {
        result = fromCache.floatValue;
    } else {
        result = [string sizeWithAttributes:self.stringAttributes].width;
        [self.cache setObject:@(result) forKey:string];
    }
    return result;
}

@end
