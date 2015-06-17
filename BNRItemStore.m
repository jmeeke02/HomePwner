//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Jordan Meeker on 4/26/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@interface BNRItemStore()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BNRItemStore

+ (instancetype) sharedStore {
   
   static BNRItemStore *sharedStore;
   
   static dispatch_once_t singleToken;
   dispatch_once(&singleToken, ^{
      sharedStore = [[self alloc] initPrivate];
   });

   
   return sharedStore;
   
   
}



//IF a programmer calls [[BNRItemSTore alloc] init] let him know the error of his ways

- (instancetype) init {
   
   @throw [NSException exceptionWithName:@"Singleton"
                                  reason:@"Use +[BNRItemStore sharedStore]"
                                userInfo:nil];
   
   return nil;
   
}

//initialize the secret Array

- (instancetype) initPrivate {
   
   self = [super init];
   
   if (self) {
      
      _privateItems = [[NSMutableArray alloc] init];
   }
   
   return self;
   
}

//Array getter - actually gets the secret private items array - no such all Items

- (NSArray *) allItems {
   
   return [self.privateItems copy];
}

//Create Item add it to the secret array

- (BNRItem *)createItem {
   
   BNRItem *item =[BNRItem randomItem];
   
   [self.privateItems addObject:item];
   
   return item;
}

//Remove Item from array

- (void) removeItem:(BNRItem *)item {
   
   NSString *key = item.itemKey;
   [[BNRImageStore sharedStore] deleteImageForKey:key];
   
   [self.privateItems removeObjectIdenticalTo:item];
   
}

//Move/ reoder Items in the array

- (void) moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
   
   if(fromIndex == toIndex) {
      return;
   }
   
   //Get pointer to the object being moved so you can reinsert it
   BNRItem *item = self.privateItems[fromIndex];
   
   //Remove item from array
   [self.privateItems removeObjectAtIndex:fromIndex];
   
   //Insert item in array at new location
   [self.privateItems insertObject:item atIndex:toIndex];
}




@end
