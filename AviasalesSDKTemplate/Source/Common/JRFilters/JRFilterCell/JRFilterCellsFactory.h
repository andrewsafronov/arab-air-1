//
//  JRFilterCellsFactory.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 23/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JRFilterVC.h"

@class JRTableViewCell;
@class JRFilterItem;

@interface JRFilterCellsFactory : NSObject

- (instancetype)initWithTableView:(nonnull UITableView *)tableView withFilterMode:(JRFilterMode)mode;

- (nonnull UITableViewCell *)cellByItem:(nonnull JRFilterItem *)item;
- (CGFloat)heightForCellByItem:(nonnull JRFilterItem *)item;
- (CGFloat)heightForHederByItem:(nonnull JRFilterItem *)item;

@end
