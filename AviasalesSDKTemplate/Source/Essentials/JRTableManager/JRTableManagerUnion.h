//
//  JRTableManagerUnion.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTableManager.h"

/**
 * Works with one cell per section
 */
@interface JRTableManagerUnion : NSObject <JRTableManager>

@property (copy, nonatomic) NSIndexSet *secondManagerPositions;

- (instancetype)initWithFirstManager:(id<JRTableManager>)firstManager
                       secondManager:(id<JRTableManager>)secondManager
              secondManagerPositions:(NSIndexSet *)secondManagerPositions;

@end
