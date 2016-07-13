//
//  ASTStopoverCell.h
//  AviasalesSDKTemplate
//

#import <UIKit/UIKit.h>

@class AviasalesFlight;

@interface ASTStopoverCell : UITableViewCell

- (void)applyFlight:(id<JRSDKFlight>)nextFlight;

@property (nonatomic, weak) IBOutlet UILabel *duration;
@property (nonatomic, weak) IBOutlet UILabel *place;

@property (nonatomic, weak) IBOutlet UILabel *stopoverLabel;

@end
