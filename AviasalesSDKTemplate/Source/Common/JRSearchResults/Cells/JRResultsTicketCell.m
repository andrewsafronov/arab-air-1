//
//  JRResultsTicketCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRResultsTicketCell.h"

#import <AviasalesSDK/AviasalesSDK.h>

#import "JRResultsTicketPriceCell.h"
#import "JRResultsFlightSegmentCell.h"
#import "JRColorScheme.h"

static NSString *const kPriceCellReusableId = @"JRResultsTicketPriceCell";
static NSString *const kFlightSegmentCellReusableID = @"JRResultsFlightSegmentCell";

static CGFloat const kBottomPadding = 12;

@interface JRResultsTicketCell() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation JRResultsTicketCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self registerTableReusableCells];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self registerTableReusableCells];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self updateBackground];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self updateBackground];
}

#pragma mark - Setters

- (void)setTicket:(id<JRSDKTicket>)ticket {
    _ticket = ticket;
    [self.tableView reloadData];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.tableView.backgroundColor = backgroundColor;
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        cell.backgroundColor = backgroundColor;
    }
}

#pragma mark - Static methods

+ (NSString *)nibFileName {
    return @"JRResultsTicketCell";
}

+ (CGFloat)heightWithTicket:(id<JRSDKTicket>)ticket {
    return [JRResultsTicketPriceCell height] +
          [JRResultsFlightSegmentCell height] * ticket.flightSegments.count +
          kBottomPadding;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ticket.flightSegments.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            JRResultsTicketPriceCell *const cell = [tableView dequeueReusableCellWithIdentifier:kPriceCellReusableId];
            cell.airline = self.ticket.mainAirline;
            cell.price = [JRSDKModelUtils ticketMinPrice:self.ticket];
            return cell;
        }

        default: {
            JRResultsFlightSegmentCell *const cell = [tableView dequeueReusableCellWithIdentifier:kFlightSegmentCellReusableID];
            cell.layoutParameters = self.flightSegmentsLayoutParameters;
            cell.flightSegment = self.ticket.flightSegments[indexPath.row - 1];
            return cell;
        }
    }
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return [JRResultsTicketPriceCell height];
        default:
            return [JRResultsFlightSegmentCell height];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = self.backgroundColor;
}

#pragma mark - Private

- (void)registerTableReusableCells {
    [self.tableView registerNib:[UINib nibWithNibName:[JRResultsTicketPriceCell nibFileName] bundle:nil] forCellReuseIdentifier:kPriceCellReusableId];
    [self.tableView registerNib:[UINib nibWithNibName:[JRResultsFlightSegmentCell nibFileName] bundle:nil] forCellReuseIdentifier:kFlightSegmentCellReusableID];
}

- (void)updateBackground {
    if (self.selected || self.highlighted) {
        self.backgroundColor = [JRColorScheme itemsSelectedBackgroundColor];
    } else {
        self.backgroundColor = [JRColorScheme itemsBackgroundColor];
    }
}

@end
