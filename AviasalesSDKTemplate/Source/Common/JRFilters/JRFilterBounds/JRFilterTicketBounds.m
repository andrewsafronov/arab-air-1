//
//  JRFilterTicketBounds.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 30/03/14.
//
//

#import "JRFilterTicketBounds.h"

#import "JRFilter.h"


@interface JRFilterTicketBounds ()

@end


@implementation JRFilterTicketBounds

- (instancetype)init {
    self = [super init];
    if (self) {
        _gates = [NSOrderedSet orderedSet];
        _paymentMethods = [NSOrderedSet orderedSet];
        _maxPrice = 0.0;
        _minPrice = NSIntegerMax;
        
        [self resetBounds];
    }
    return self;
}

- (void)resetBounds {
    _filterPrice = _maxPrice;
    _filterGates = [_gates copy];
    _filterPaymentMethods = [_paymentMethods copy];
    _filterMobileWebOnly = _mobileWebOnly;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidResetNotificationName object:self];
}

- (BOOL)isReseted {
    BOOL isReseted = (self.filterPrice == self.maxPrice) &&  (self.filterGates.count == 0) &&
    (self.filterPaymentMethods.count == 0) && !self.filterMobileWebOnly;
    
    return isReseted;
}

- (void)setFilterGates:(NSOrderedSet<id<JRSDKGate>> *)filterGates {
    if (![self.filterGates isEqual:filterGates]) {
        _filterGates = filterGates;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterPaymentMethods:(NSOrderedSet<id<JRSDKPaymentMethod>> *)filterPaymentMethods {
    if (self.filterPaymentMethods != filterPaymentMethods) {
        _filterPaymentMethods = filterPaymentMethods;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterPrice:(NSInteger)filterPrice {
    if (self.filterPrice != filterPrice) {
        _filterPrice = filterPrice;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterMobileWebOnly:(BOOL)filterMobileWebOnly {
    if (self.filterMobileWebOnly != filterMobileWebOnly) {
        _filterMobileWebOnly = filterMobileWebOnly;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

@end
