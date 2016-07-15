//
//  JRPriceCell.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 16/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRPriceCell.h"


@interface JRPriceCell ()

@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *agencyLabel;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;

@end

@implementation JRPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.buyButton setTitle:AVIASALES_(@"AVIASALES_BUY") forState:UIControlStateNormal];
    
    [self updateContent];
}

#pragma mark - Public methods

- (void)setPrice:(id<JRSDKPrice>)price {
    _price = price;
    
    [self updateContent];
}

#pragma mark - Private methods

- (void)updateContent {
    if (self.price == nil) { return; }
    
    NSNumber *const minPriceValue = [JRSDKModelUtils priceInUserCurrency:self.price];
    self.priceLabel.text = [AviasalesNumberUtil formatPrice:minPriceValue];
   
    self.agencyLabel.text = self.price.gate.label;
}

#pragma mark - IBAction methods

- (IBAction)onBuy:(id)sender {
    self.buyHandler(self.price);
}

@end
