#import <Foundation/Foundation.h>

@protocol JRSDKSearchInfo;
@class JRSearchInfo;

/**
 * Позволяет кодировать параметры поиска в строку и обратно.
 */
@protocol JRSDKSearchInfoCoder

/**
 * Преобразует строку в параметры поиска.
 * @return Параметры поиска, построенные по строке или nil, если не удалось раскодировать параметры.
 */
- (nullable JRSearchInfo *)searchParamsWithString:(nonnull NSString *)encodedSearchParams;

/**
 * Преобразует параметры поиска в строку.
 * @return Закодированные параметры поиска или nil при возникновении ошибки.
 */
- (nullable NSString *)encodeSearchParams:(nonnull id<JRSDKSearchInfo>)searchParams;
@end
