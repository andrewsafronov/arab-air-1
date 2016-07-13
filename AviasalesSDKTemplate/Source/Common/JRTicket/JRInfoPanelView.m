//
//  JRInfoPanelView.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 10/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRInfoPanelView.h"


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
@property (nonatomic, weak) IBOutlet UIButton *showOtherAgenciesButton;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;

@end


@implementation JRInfoPanelView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat lineWidth = 1.0 / [UIScreen mainScreen].scale;
    self.topLineHeightConstraint.constant = lineWidth;
    self.bottomLineHeightConstraint.constant = lineWidth;

    [self.buyButton setTitle:AVIASALES_(@"AVIASALES_BUY_TICKET").uppercaseString forState:UIControlStateNormal];
    
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
    self.agencyInfoLabelCenterConstraint.constant = kAgencyInfoLabelMinCenterConstraint;
    
    self.agencyInfoLabelLeftConstraint.priority = UILayoutPriorityDefaultHigh;
    self.agencyInfoLabelLeftContainerConstraint.priority = UILayoutPriorityDefaultLow;
    
    self.showOtherAgenciesButton.alpha = 1.0;
    
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
    self.buyButtonLeftConstraint.constant = kBuyButtonMinRightConstraint + 0.5 * self.bounds.size.width;;
    self.agencyInfoLabelCenterConstraint.constant = kAgencyInfoLabelMaxCenterConstraint;
    
    self.agencyInfoLabelLeftConstraint.priority = UILayoutPriorityDefaultLow;
    self.agencyInfoLabelLeftContainerConstraint.priority = UILayoutPriorityDefaultHigh;
    
    self.showOtherAgenciesButton.alpha = 0.0;
    
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

- (void)updateContent {
    id<JRSDKGate> const gate = self.ticket.prices.firstObject.gate;
    if (gate) {
        self.agencyInfoLabel.text = [NSString stringWithFormat:@"%@ %@", AVIASALES_(@"AVIASALES_ON"), gate.label];
    } else {
        self.agencyInfoLabel.text = @"";
    }

    self.priceLabel.text = [JRSDKModelUtils formattedTicketMinPriceInUserCurrency:self.ticket];
    
    self.showOtherAgenciesButton.hidden = self.ticket.prices.count == 1;
}

#pragma mark IBAction methods

- (IBAction)buyBest:(id)sender {
    self.buyHandler();
}

- (IBAction)showOtherAgencies:(id)sender {
    self.showOtherAgencyHandler();
}

@end
