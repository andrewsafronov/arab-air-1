//
//  ASTSearchResultsList.m
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 01.04.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "ASTSearchResultsList.h"
#import "ASTResultsTicketCell.h"

@implementation ASTSearchResultsList
@synthesize ticketCellNibName = _ticketCellNibName;

- (instancetype)initWithCellNibName:(NSString *)cellNibName {
    if (self = [super init]) {
        _ticketCellNibName = cellNibName;
    }
    return self;
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.delegate tickets].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ASTResultsTicketCell";

    ASTResultsTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[AVIASALES_BUNDLE loadNibNamed:self.ticketCellNibName owner:self options:nil] objectAtIndex:0];
    }

    cell.ticket = [self ticketAtIndexPath:indexPath];

    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<JRSDKTicket> const ticket = [self ticketAtIndexPath:indexPath];
    return [ASTResultsTicketCell heightWithTicket:ticket];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger index = indexPath.section;
    [self.delegate didSelectTicketAtIndex:index];
}

#pragma mark - Private

- (AviasalesTicket *)ticketAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger index = indexPath.section;
    return [[self.delegate tickets] objectAtIndex:index];
}

@end
