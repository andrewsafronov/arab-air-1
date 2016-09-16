//
//  JRTicketCellProtocol.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#ifndef ASTTicketCellProtocol_h
#define ASTTicketCellProtocol_h

@protocol JRTicketCellProtocol <NSObject>

- (void)applyFlight:(id<JRSDKFlight>)flight;

@end

#endif /* JRTicketCellProtocol_h */

