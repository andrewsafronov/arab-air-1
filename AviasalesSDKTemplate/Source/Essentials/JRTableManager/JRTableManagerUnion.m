//
//  JRTableManagerUnion.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTableManagerUnion.h"

@interface JRTableManagerUnion ()

@property (strong, nonatomic) id<JRTableManager> first;
@property (strong, nonatomic) id<JRTableManager> second;
@property (strong, nonatomic) NSIndexSet *realSecondManagerPositions;
@property (assign, nonatomic) NSInteger firstTableSizeCache;

@end

@implementation JRTableManagerUnion

@synthesize realSecondManagerPositions = _realSecondManagerPositions;

- (instancetype)initWithFirstManager:(id<JRTableManager>)firstManager
                       secondManager:(id<JRTableManager>)secondManager
              secondManagerPositions:(NSIndexSet *)secondManagerPositions {
    if (self = [super init]) {
        _first = firstManager;
        _second = secondManager;
        _secondManagerPositions = secondManagerPositions;
    }
    return self;
}

#pragma mark - Setters

- (void)setSecondManagerPositions:(NSIndexSet *)secondManagerPositions {
    _secondManagerPositions = [secondManagerPositions copy];
    _realSecondManagerPositions = nil;
}

- (void)setFirstTableSizeCache:(NSInteger)firstTableSizeCache {
    _firstTableSizeCache = firstTableSizeCache;
    _realSecondManagerPositions = nil;
}

#pragma mark - Getters

- (NSIndexSet *)realSecondManagerPositions {
    if (_realSecondManagerPositions != nil) {
        return _realSecondManagerPositions;
    }
    const NSInteger firstManagerTableSize = self.firstTableSizeCache;
    const NSInteger secondManagerTableSize = self.secondManagerPositions.count;
    const NSInteger tableSize = firstManagerTableSize + secondManagerTableSize;
    const NSRange allTableItemsIndexesRange = NSMakeRange(0, tableSize);
    __block NSInteger tableSizeForEnumeration = firstManagerTableSize;
    NSIndexSet *const elementsFromSecondTableToUseWithoutSpaces = [self.secondManagerPositions indexesInRange:allTableItemsIndexesRange options:0 passingTest:^BOOL(NSUInteger idx, BOOL * _Nonnull stop) {
        ++tableSizeForEnumeration;
        const BOOL result = idx < tableSizeForEnumeration;
        *stop = !result;
        return result;
    }];

    const NSInteger countOfElementsFromSecondTableToUseWithoutSpaces = elementsFromSecondTableToUseWithoutSpaces.count;
    if (countOfElementsFromSecondTableToUseWithoutSpaces == secondManagerTableSize) {
        _realSecondManagerPositions = self.secondManagerPositions;
    } else {
        NSMutableIndexSet *const mergedSet = [[NSMutableIndexSet alloc] initWithIndexSet:elementsFromSecondTableToUseWithoutSpaces];
        [mergedSet addIndexesInRange:NSMakeRange(firstManagerTableSize + countOfElementsFromSecondTableToUseWithoutSpaces, secondManagerTableSize - countOfElementsFromSecondTableToUseWithoutSpaces)];
        _realSecondManagerPositions = [mergedSet copy];
    }
    return _realSecondManagerPositions;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self firstTableSizeWithTable:tableView] + self.realSecondManagerPositions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger index = indexPath.section;
    UITableViewCell *result;
    if ([self isSecondTableIndex:index]) {
        NSIndexPath *const pathInSeconTable = [self indexPathFromSecondTableWithIndex:index];
        result = [self.second tableView:tableView cellForRowAtIndexPath:pathInSeconTable];
    } else {
        NSIndexPath *const pathInFirstTable = [self indexPathFromFirstTableWithIndex:index];
        result = [self.first tableView:tableView cellForRowAtIndexPath:pathInFirstTable];
    }
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<JRTableManager> manager;
    NSInteger managerSection;

    if ([self isSecondTableIndex:section]) {
        manager = self.second;
        managerSection = [self sectionFromSecondTableWithSection:section];
    } else {
        manager = self.first;
        managerSection = [self sectionFromFirstTableWithIndex:section];
    }

    if ([manager respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [manager tableView:tableView heightForHeaderInSection:managerSection];
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id<JRTableManager> manager;
    NSInteger managerSection;

    if ([self isSecondTableIndex:section]) {
        manager = self.second;
        managerSection = [self sectionFromSecondTableWithSection:section];
    } else {
        manager = self.first;
        managerSection = [self sectionFromFirstTableWithIndex:section];
    }

    if ([manager respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [manager tableView:tableView heightForFooterInSection:managerSection];
    } else {
        return 0;
    }
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger index = indexPath.section;
    if ([self isSecondTableIndex:index]) {
        if ([self.second respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            NSIndexPath *const pathInSeconTable = [self indexPathFromSecondTableWithIndex:index];
            [self.second tableView:tableView didSelectRowAtIndexPath:pathInSeconTable];
        }
    } else {
        if ([self.first respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            NSIndexPath *const pathInFirstTable = [self indexPathFromFirstTableWithIndex:index];
            [self.first tableView:tableView didSelectRowAtIndexPath:pathInFirstTable];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger index = indexPath.section;
    CGFloat result = tableView.rowHeight;
    if ([self isSecondTableIndex:index]) {
        if ([self.second respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            NSIndexPath *const pathInSeconTable = [self indexPathFromSecondTableWithIndex:index];
            result = [self.second tableView:tableView heightForRowAtIndexPath:pathInSeconTable];
        }
    } else {
        if ([self.first respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            NSIndexPath *const pathInFirstTable = [self indexPathFromFirstTableWithIndex:index];
            result = [self.first tableView:tableView heightForRowAtIndexPath:pathInFirstTable];
        }
    }
    return result;
}

#pragma mark - Private

- (id<JRTableManager>)tableManagerAtIndex:(NSInteger)index {
    if ([self isSecondTableIndex:index]) {
        return self.second;
    } else {
        return self.first;
    }
}

- (BOOL)isSecondTableIndex:(NSInteger)index {
    return [self.realSecondManagerPositions containsIndex:index];
}

- (NSIndexPath *)indexPathFromSecondTableWithIndex:(NSInteger)index {
    const NSInteger newIndex = [self sectionFromSecondTableWithSection:index];
    return [NSIndexPath indexPathForRow:0 inSection:newIndex];
}

- (NSInteger)sectionFromSecondTableWithSection:(NSInteger)index {
    return [self.realSecondManagerPositions countOfIndexesInRange:NSMakeRange(0, index)];
}

- (NSIndexPath *)indexPathFromFirstTableWithIndex:(NSInteger)index {
    const NSInteger newIndex = [self sectionFromFirstTableWithIndex:index];
    return [NSIndexPath indexPathForRow:0 inSection:newIndex];
}

- (NSInteger)sectionFromFirstTableWithIndex:(NSInteger)index {
    return index - [self.realSecondManagerPositions countOfIndexesInRange:NSMakeRange(0, index)];
}

- (NSInteger)firstTableSizeWithTable:(UITableView *)tableView {
    const NSInteger firstTableSize = [self.first numberOfSectionsInTableView:tableView];
    if (self.firstTableSizeCache != firstTableSize) {
        self.firstTableSizeCache = firstTableSize;
    }
    return firstTableSize;
}

@end
