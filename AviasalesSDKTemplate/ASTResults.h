//
//  ASTResults.h
//

#import <AviasalesSDK/AviasalesFilter.h>
#import "JRViewController.h"

@class ASTFilters;

@interface ASTResults : JRViewController <UIActionSheetDelegate, AviasalesFilterDelegate>

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                          response:(id<JRSDKSearchResult>)response;
- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                          response:(id<JRSDKSearchResult>)response
                          filterVC:(ASTFilters *)filterVC;

- (IBAction)showCurrenciesList:(id)sender;
- (IBAction)showFilters:(id)sender;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *currencyButton;

@property (nonatomic, weak) IBOutlet UIView *emptyView;
@property (nonatomic, weak) IBOutlet UILabel *emptyLabel;

@property (nonatomic, weak) IBOutlet UIBarButtonItem *filters;

@end
