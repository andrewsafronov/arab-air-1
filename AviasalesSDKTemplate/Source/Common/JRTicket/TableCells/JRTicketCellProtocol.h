//
//  JRTicketCellProtocol.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 08/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#ifndef ASTTicketCellProtocol_h
#define ASTTicketCellProtocol_h

@protocol JRTicketCellProtocol <NSObject>

- (void)applyFlight:(id<JRSDKFlight>)flight;

@end

#endif /* JRTicketCellProtocol_h */

