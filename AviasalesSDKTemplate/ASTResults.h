//
//  ASTResults.h
//

#import "JRViewController.h"
#import "JRFilterVC.h"


@interface ASTResults : JRViewController <UIActionSheetDelegate>

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                          response:(id<JRSDKSearchResult>)response;

- (IBAction)showCurrenciesList:(id)sender;
- (IBAction)showFilters:(id)sender;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *currencyButton;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *filters;

@property (nonatomic, weak) IBOutlet UIView *emptyView;
@property (nonatomic, weak) IBOutlet UILabel *emptyLabel;

@property (strong, nonatomic, readonly) JRFilter *filter;

@end
