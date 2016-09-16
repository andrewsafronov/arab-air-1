//
//  JRSearchFormPassengersView.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchFormPassengersView.h"
#import "JRSearchFormPassengerPickerView.h"
#import "UIImage+JRUIImage.h"
#import "JRColorScheme.h"

static const NSInteger kMaximumSeats = 9;

@interface JRSearchFormPassengersView ()

@property (nonatomic, strong) NSString *ageText;

@end


@implementation JRSearchFormPassengersView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_ellipseImageView setImage:[_ellipseImageView.image imageTintedWithColor:[JRColorScheme darkTextColor]]];
    [_ellipseImageView.layer setBorderWidth:JRPixel()];
    [_ellipseImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_ellipseImageView.layer setCornerRadius:_ellipseImageView.image.size.height/2];
    
    [_minusButton setImage:[[_minusButton imageForState:UIControlStateNormal] imageTintedWithColor:[JRColorScheme darkTextColor]] forState:UIControlStateNormal];
    [_plusButton setImage:[[_plusButton imageForState:UIControlStateNormal] imageTintedWithColor:[JRColorScheme darkTextColor]] forState:UIControlStateNormal];
    
    [_minusButton setImage:[[_minusButton imageForState:UIControlStateNormal] imageTintedWithColor:[JRColorScheme darkTextColor] fraction:0.75] forState:UIControlStateHighlighted];
    [_plusButton setImage:[[_plusButton imageForState:UIControlStateNormal] imageTintedWithColor:[JRColorScheme darkTextColor] fraction:0.75] forState:UIControlStateHighlighted];
}

- (void)setSearchInfo:(JRSearchInfo *)searchInfo {
    _searchInfo = searchInfo;
    
    [self updateView];
}

- (void)setType:(JRSearchFormPassengersViewType)type {
    _type = type;
    [self updateView];
    
    _ageText = NSLS(@"JR_SEARCH_FORM_PASSENGERS_OLDER_THEN_12");
    if (_type == JRSearchFormPassengersViewChildrenType) {
        _ageText = NSLS(@"JR_SEARCH_FORM_PASSENGERS_FROM_2_TO_12_YEARS");
    } else if (_type == JRSearchFormPassengersViewInfantsType) {
        _ageText = NSLS(@"JR_SEARCH_FORM_PASSENGERS_UP_TO_2_YEARS");
    }
    _minusButton.accessibilityLabel = [NSString stringWithFormat:NSLS(@"JR_SEARCH_FORM_PASSENGERS_DECREASE_BTN_TITLE_ACC"), _ageText];
    _plusButton.accessibilityLabel = [NSString stringWithFormat:NSLS(@"JR_SEARCH_FORM_PASSENGERS_INCREASE_BTN_TITLE_ACC"), _ageText];
}

- (void)updateView {
    [self checkPassangersLimit];
    UIImage *passengerImage = nil;
    NSString *passengerCountString = nil;
    switch (_type) {
        case JRSearchFormPassengersViewAdultsType: {
            passengerImage = [UIImage imageNamed:@"JRSearchFormAdultPassenger"];
            passengerCountString = [NSString stringWithFormat:@"%@", @(_searchInfo.adults)];
        } break;
        case JRSearchFormPassengersViewChildrenType: {
            passengerImage = [UIImage imageNamed:@"JRSearchFormChildPassenger"];
            passengerCountString = [NSString stringWithFormat:@"%@", @(_searchInfo.children)];
        } break;
        case JRSearchFormPassengersViewInfantsType: {
            passengerImage = [UIImage imageNamed:@"JRSearchFormInfantPassenger"];
            passengerCountString = [NSString stringWithFormat:@"%@", @(_searchInfo.infants)];
        } break;
        default:
            break;
    }
    
    [_passengerImageView setImage:passengerImage];
    [_passengerCount setText:passengerCountString];
    
    _passengerCount.accessibilityLabel = [NSString stringWithFormat:NSLS(@"JR_SEARCH_FORM_PASSENGERS_COUNT_ACC"), _passengerCount.text, _ageText];
    
    _minusButton.accessibilityValue = _plusButton.accessibilityValue = _passengerCount.text;
}

- (IBAction)minusAction:(id)sender {
    switch (_type) {
        case JRSearchFormPassengersViewAdultsType: {
            [_searchInfo setAdults:_searchInfo.adults - 1];
        } break;
        case JRSearchFormPassengersViewChildrenType: {
            [_searchInfo setChildren:_searchInfo.children - 1];
        } break;
        case JRSearchFormPassengersViewInfantsType: {
            [_searchInfo setInfants:_searchInfo.infants - 1];
        } break;
        default:
            break;
    }
    [_pickerView.passengerViews makeObjectsPerformSelector:@selector(updateView)];
    
    [_pickerView.delegate passengerViewDidChangePassengers];
}

- (IBAction)plusAction:(id)sender {
    if (![self isItPossibleToAddSomeone]) {
        return;
    }
    
    switch (_type) {
        case JRSearchFormPassengersViewAdultsType: {
            [_searchInfo setAdults:_searchInfo.adults + 1];
        } break;
        case JRSearchFormPassengersViewChildrenType: {
            [_searchInfo setChildren:_searchInfo.children + 1];
        } break;
        case JRSearchFormPassengersViewInfantsType: {
            NSInteger infants = _searchInfo.infants + 1;
            if (infants <= _searchInfo.adults) {
                [_searchInfo setInfants:infants];
            } else {
                [_pickerView.delegate passengerViewExceededTheAllowableNumberOfInfants];
            }
        } break;
        default:
            break;
    }
    [_pickerView.passengerViews makeObjectsPerformSelector:@selector(updateView)];
    
    [_pickerView.delegate passengerViewDidChangePassengers];
}

- (BOOL)isItPossibleToAddSomeone {
    NSInteger adultsNumber = _searchInfo.adults;
    NSInteger childrenNumber = _searchInfo.children;
    NSInteger babiesNumber = _searchInfo.infants;
    
    return (adultsNumber + childrenNumber + babiesNumber) < kMaximumSeats;
}

- (void)checkPassangersLimit {
    NSInteger adultsNumber = _searchInfo.adults;
    NSInteger childrenNumber = _searchInfo.children;
    NSInteger babiesNumber = _searchInfo.infants;
    
    const BOOL isItPossibleToAddSomeone = [self isItPossibleToAddSomeone];
    
    if (_type == JRSearchFormPassengersViewAdultsType) {
        [_plusButton setEnabled: isItPossibleToAddSomeone];
        adultsNumber == 1 ? [_minusButton setEnabled:NO] : [_minusButton setEnabled:YES];
    }
    
    if (_type == JRSearchFormPassengersViewChildrenType) {
        [_plusButton setEnabled: isItPossibleToAddSomeone];
        childrenNumber == 0 ? [_minusButton setEnabled:NO] : [_minusButton setEnabled:YES];
    }
    
    if (_type == JRSearchFormPassengersViewInfantsType) {
        
        BOOL isItPossibleToAddInfant = isItPossibleToAddSomeone && (babiesNumber < adultsNumber);
        if (babiesNumber > adultsNumber) {
            _searchInfo.infants = adultsNumber;
        }
        
        [_plusButton setAlpha:isItPossibleToAddInfant ? 1 : 0.5];
        babiesNumber == 0 ? [_minusButton setEnabled:NO] : [_minusButton setEnabled:YES];
    }
}

@end
