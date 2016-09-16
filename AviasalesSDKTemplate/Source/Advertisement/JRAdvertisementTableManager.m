//
//  JRAdvertisementTableManager.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRAdvertisementTableManager.h"

static NSString *const kCellReusableId = @"JRAdvertisementTableManagerAdCell";
static NSInteger const kAdViewTag = 567134;
static CGFloat kAppodealAdHeight = 100;

@implementation JRAdvertisementTableManager

+ (CGFloat)appodealAdHeight {
    return kAppodealAdHeight;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ads.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *res = [tableView dequeueReusableCellWithIdentifier:kCellReusableId];

    if (res == nil) {
        res = [[UITableViewCell alloc] init];
    } else {
        [[res.contentView viewWithTag:kAdViewTag] removeFromSuperview];
    }

    UIView *const adView = self.ads[indexPath.section];
    [adView removeFromSuperview];
    adView.frame = res.contentView.bounds;
    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [res.contentView addSubview:adView];
    return res;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAppodealAdHeight;
}

@end
