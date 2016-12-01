//
//  JRNewsFeedNativeAdView.m
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 24.08.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Appodeal/APDNativeAd.h>
#import <AXRatingView/AXRatingView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Appodeal/APDImage.h>

#import "JRNewsFeedNativeAdView.h"
#import "JRColorScheme.h"

static const CGFloat kCallToActionCornerRadius = 3;

@interface JRNewsFeedNativeAdView()
@property (strong, nonatomic) APDNativeAd *ad;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageRatingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet AXRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UIView *callToActionBorder;
@property (weak, nonatomic) IBOutlet UILabel *callToActionLabel;
@property (weak, nonatomic) IBOutlet UIView *adChoicesContainerView;
@end

@implementation JRNewsFeedNativeAdView

+ (instancetype)viewWithNativeAd:(APDNativeAd *)nativeAd {
    JRNewsFeedNativeAdView *const view = LOAD_VIEW_FROM_NIB_NAMED(@"JRNewsFeedNativeAdView");
    view.ad = nativeAd;
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ratingView.userInteractionEnabled = NO;
    [self setupStyle];
}

- (void)dealloc {
    [self.ad detachFromView];
}

- (void)setupStyle {
    self.titleLabel.textColor = [JRColorScheme darkTextColor];
    self.subtitleLabel.textColor = [JRColorScheme lightTextColor];
    self.ageRatingLabel.textColor = [JRColorScheme lightTextColor];
    self.callToActionBorder.layer.cornerRadius = kCallToActionCornerRadius;
    self.callToActionBorder.layer.borderWidth = 1;
    self.callToActionBorder.layer.borderColor = self.tintColor.CGColor;
    self.callToActionLabel.textColor = self.tintColor;
    self.ratingView.baseColor = [JRColorScheme ratingStarDefaultColor];
    self.ratingView.highlightColor = [JRColorScheme ratingStarSelectedColor];
    self.ratingView.markFont = [UIFont systemFontOfSize:8];
}

- (void)setAd:(APDNativeAd *)ad {
    _ad = ad;

    if ([ad.title isKindOfClass:[NSString class]]) {
        self.titleLabel.text = ad.title;
    } else {
        self.titleLabel.text = @"";
    }
    if ([ad.subtitle isKindOfClass:[NSString class]] && ad.subtitle.length > 0) {
        self.subtitleLabel.text = ad.subtitle;
    } else if ([ad.descriptionText isKindOfClass:[NSString class]] && ad.descriptionText.length > 0) {
        self.subtitleLabel.text = ad.descriptionText;
    } else {
        self.subtitleLabel.text = @"";
    }
    self.ageRatingLabel.text = @""; //Theare is no such parameter in native ad yet
    if ([ad.iconImage isKindOfClass:[APDImage class]] && [ad.iconImage.url isKindOfClass:[NSURL class]]) {
        [self.iconImage sd_setImageWithURL: ad.iconImage.url];
    }

    if ([self.ad.starRating isKindOfClass:[NSNumber class]]) {
        self.ratingView.value = [self.ad.starRating floatValue];
    } else {
        self.ratingView.hidden = YES;
    }

    if ([ad.callToActionText isKindOfClass:[NSString class]]) {
        self.callToActionLabel.text = ad.callToActionText;
    } else {
        self.callToActionLabel.text = @"GET";
    }
    for (UIView *adChoicesContainerSubview in self.adChoicesContainerView.subviews) {
        [adChoicesContainerSubview removeFromSuperview];
    }

    if ([self.ad.adChoicesView isKindOfClass:[UIView class]]) {
        self.ad.adChoicesView.frame = self.adChoicesContainerView.bounds;
        self.ad.adChoicesView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.adChoicesContainerView addSubview:ad.adChoicesView];
    }
}
@end
