//
//  JRFilterCellsFactory.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>

#import "JRFilterVC.h"

@class JRTableViewCell;
@class JRFilterItem;

@interface JRFilterCellsFactory : NSObject

- (instancetype)initWithTableView:(nonnull UITableView *)tableView withFilterMode:(JRFilterMode)mode;

- (nonnull UITableViewCell *)cellByItem:(nonnull JRFilterItem *)item;
- (CGFloat)heightForCellByItem:(nonnull JRFilterItem *)item;

@end
