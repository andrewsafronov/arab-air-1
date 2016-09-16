//
//  JRInfoPanelView.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRInfoPanelView.h"

#import "JRTicketUtils.h"


static const CGFloat kBuyButtonMaxTopConstraint = 59.0;
static const CGFloat kBuyButtonMinTopConstraint = 19.0;

static const CGFloat kShowOtherAgenciesButtonMaxTopConstraint = 15.0;
static const CGFloat kShowOtherAgenciesButtonMinTopConstraint = -25.0;

static const CGFloat kBuyButtonMinRightConstraint = 20.0;

static const CGFloat kAgencyInfoLabelMinCenterConstraint = 0.0;
static const CGFloat kAgencyInfoLabelMaxCenterConstraint = 20.0;


@interface JRInfoPanelView()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyButtonLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *showOtherAgenciesButtonTopConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topLineHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomLineHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *agencyInfoLabelCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *agencyInfoLabelLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *agencyInfoLabelLeftContainerConstraint;

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *agencyInfoLabel;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;

@property (nonatomic, weak) IBOutlet UIButton *showOtherAgenciesButton;

@property (nonatomic, weak) IBOutlet UIButton *buyInCreditButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyButtonInCreditRightToContainerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buyButtonInCreditRightToOtherConstraint;

@end


@implementation JRInfoPanelView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat lineWidth = 1.0 / [UIScreen mainScreen].scale;
    self.topLineHeightConstraint.constant = lineWidth;
    self.bottomLineHeightConstraint.constant = lineWidth;
    
    [self.buyInCreditButton setTitle:AVIASALES_(@"JR_TICKET_BUY_IN_CREDIT_BUTTON") forState:UIControlStateNormal];
    [self.showOtherAgenciesButton setTitle:AVIASALES_(@"JR_TICKET_OTHER_BUTTON") forState:UIControlStateNormal];
    
    [self updateContent];
}

#pragma mark Public methods

- (void)setTicket:(id<JRSDKTicket>)ticket {
    _ticket = ticket;
    
    [self updateContent];
}

- (void)expand {
    [self.layer removeAllAnimations];
    
    self.buyButtonTopConstraint.constant = kBuyButtonMaxTopConstraint;
    self.showOtherAgenciesButtonTopConstraint.constant = kShowOtherAgenciesButtonMaxTopConstraint;
    self.buyButtonLeftConstraint.constant = kBuyButtonMinRightConstraint;
    
    if (self.showOtherAgenciesButton.hidden && self.buyInCreditButton.hidden) {
        [self moveUpAgencyInfoLabel];
    }
    
    self.showOtherAgenciesButton.alpha = 1.0;
    self.buyInCreditButton.alpha = 1.0;
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)collapse {
    [self.layer removeAllAnimations];
    
    self.buyButtonTopConstraint.constant = kBuyButtonMinTopConstraint;
    self.showOtherAgenciesButtonTopConstraint.constant = kShowOtherAgenciesButtonMinTopConstraint;
    self.buyButtonLeftConstraint.constant = kBuyButtonMinRightConstraint + 0.5 * self.bounds.size.width;
    
    if (self.showOtherAgenciesButton.hidden && self.buyInCreditButton.hidden) {
        [self moveDownAgencyInfoLabel];
    }
    
    self.showOtherAgenciesButton.alpha = 0.0;
    self.buyInCreditButton.alpha = 0.0;
    
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

#pragma mark Private methods

- (void)moveUpAgencyInfoLabel {
    self.agencyInfoLabelCenterConstraint.constant = kAgencyInfoLabelMinCenterConstraint;
    self.agencyInfoLabelLeftConstraint.priority = UILayoutPriorityDefaultHigh;
    self.agencyInfoLabelLeftContainerConstraint.priority = UILayoutPriorityDefaultLow;
}

- (void)moveDownAgencyInfoLabel {
    self.agencyInfoLabelCenterConstraint.constant = kAgencyInfoLabelMaxCenterConstraint;
    self.agencyInfoLabelLeftConstraint.priority = UILayoutPriorityDefaultLow;
    self.agencyInfoLabelLeftContainerConstraint.priority = UILayoutPriorityDefaultHigh;
}

- (void)updateContent {
    id<JRSDKGate> const gate = self.ticket.prices.firstObject.gate;
    if (gate) {
        self.agencyInfoLabel.text = [NSString stringWithFormat:@"%@ %@", AVIASALES_(@"JR_SEARCH_RESULTS_TICKET_IN_THE"), gate.label];
    } else {
        self.agencyInfoLabel.text = @"";
    }

    self.priceLabel.text = [JRTicketUtils formattedTicketMinPriceInUserCurrency:self.ticket];
    
    BOOL hasPriceInCredit = [JRSDKModelUtils ticketCreditPrice:self.ticket] != nil;
    NSUInteger pricesCount = self.ticket.prices.count;
    BOOL showOtherButton = hasPriceInCredit ? pricesCount > 2 : pricesCount > 1;
    BOOL showBuyInCredit = hasPriceInCredit && pricesCount > 1;
    
    self.showOtherAgenciesButton.hidden = !showOtherButton;
    self.buyButtonInCreditRightToOtherConstraint.priority = showOtherButton ? UILayoutPriorityDefaultHigh : UILayoutPriorityDefaultLow;
    self.buyButtonInCreditRightToContainerConstraint.priority = showOtherButton ? UILayoutPriorityDefaultLow : UILayoutPriorityDefaultHigh;
    self.buyInCreditButton.hidden = !showBuyInCredit;
    
    if (showOtherButton || showBuyInCredit) {
        [self moveDownAgencyInfoLabel];
    } else {
        [self moveUpAgencyInfoLabel];
    }
    
    if (hasPriceInCredit && pricesCount == 1) {
        [self.buyButton setTitle:AVIASALES_(@"JR_TICKET_BUY_IN_CREDIT_BUTTON").uppercaseString forState:UIControlStateNormal];
    } else {
        [self.buyButton setTitle:AVIASALES_(@"JR_TICKET_BUY_BUTTON").uppercaseString forState:UIControlStateNormal];
    }
}

#pragma mark IBAction methods

- (IBAction)buyBest:(id)sender {
    self.buyHandler();
}

- (IBAction)showOtherAgencies:(id)sender {
    self.showOtherAgencyHandler();
}

- (IBAction)buyInCredit:(id)sender {
    if (self.buyInCreditHandler != nil) {
        self.buyInCreditHandler();
    }
}

@end
