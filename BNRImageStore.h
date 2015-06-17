//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Jordan Meeker on 5/2/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRImageStore : NSObject

//designated initializer
+ (instancetype) sharedStore;

- (void) setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *) imageForKey:(NSString *) key;
- (void) deleteImageForKey: (NSString *) key;


@end
