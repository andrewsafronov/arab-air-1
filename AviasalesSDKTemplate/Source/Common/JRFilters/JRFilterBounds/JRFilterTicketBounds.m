//
//  JRFilterTicketBounds.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
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
        _minPrice = CGFLOAT_MAX;
        
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
    BOOL isReseted = (self.filterPrice == self.maxPrice) &&  (self.filterGates.count == self.gates.count) &&
    (self.filterPaymentMethods.count == self.paymentMethods.count) && !self.filterMobileWebOnly;
    
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

- (void)setFilterPrice:(CGFloat)filterPrice {
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
