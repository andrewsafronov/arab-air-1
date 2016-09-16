//
//  JRTransferCell.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>
#import "JRTicketCellProtocol.h"

@interface JRTransferCell : UITableViewCell <JRTicketCellProtocol>

@property (nonatomic, weak) IBOutlet UIView *verticalDivider;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;

- (void)applyFlight:(id<JRSDKFlight>)nextFlight;

@end
