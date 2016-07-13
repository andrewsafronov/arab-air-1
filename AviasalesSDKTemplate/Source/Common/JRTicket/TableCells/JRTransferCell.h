//
//  JRTransferCell.h
//  AviasalesSDKTemplate
//

#import <UIKit/UIKit.h>
#import "JRTicketCellProtocol.h"

@interface JRTransferCell : UITableViewCell <JRTicketCellProtocol>

@property (nonatomic, weak) IBOutlet UIView *verticalDivider;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;

- (void)applyFlight:(id<JRSDKFlight>)nextFlight;

@end
