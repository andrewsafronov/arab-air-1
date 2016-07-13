#import <UIKit/UIKit.h>

@class JRWaitingViewController;

@protocol JRWaitingViewControllerDelegate <NSObject>
- (void)waitingViewController:(JRWaitingViewController *)viewController
      didFinishSearchWithInfo:(id<JRSDKSearchInfo>)searchInfo
                       result:(id<JRSDKSearchResult>)searchResult;
- (void)waitingViewController:(JRWaitingViewController *)viewController
     didFinishSearchWithError:(NSError *)error;
@end

@interface JRWaitingViewController : UIViewController
@property (weak, nonatomic) id<JRWaitingViewControllerDelegate> delegate;
- (instancetype)initWithSearchInfo:(id <JRSDKSearchInfo>)searchInfo;
- (void)finish;
- (void)performSearch;
+ (NSString *)nibFileName;
@end
