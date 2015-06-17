//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Jordan Meeker on 4/26/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

//Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype) sharedStore;
- (BNRItem *) createItem;
- (void) removeItem:(BNRItem *) item;
- (void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger) toIndex;


@end
