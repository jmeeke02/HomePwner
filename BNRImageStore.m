//
//  BNRImageStore.m
//  Homepwner
//
//  Created by Jordan Meeker on 5/2/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRImageStore.h"

@interface BNRImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;


@end

@implementation BNRImageStore

//INITIALIZATION

//Initialize the object and make sure its a singleton

+ (instancetype) sharedStore {
   
   static BNRImageStore *sharedStore;
   
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedStore = [[self alloc] initPrivate];
   });
   
   return sharedStore;
}


//No one should call init

- (instancetype) init {
   
   [NSException raise:@"Singleton" format:@"Use +[BNRImageStore sharedStore]"];
   return nil;
}


- (instancetype) initPrivate {
   
   self = [super init];
   if (self) {
      _dictionary = [[NSMutableDictionary alloc] init];
   }
   return self;
   
}

//ACCESSORS AND OTHER METHODS

//Set a image with a key
- (void) setImage:(UIImage *)image forKey:(NSString *)key {
   
   self.dictionary[key] = image;
}

//retrieve image for a given key
- (UIImage *) imageForKey:(NSString *)key {
   
   return self.dictionary[key];
}

//delete image for a given key
- (void) deleteImageForKey:(NSString *)key {
   
   if (!key) {
      return;
   }
   
   [self.dictionary removeObjectForKey:key];
}


@end
