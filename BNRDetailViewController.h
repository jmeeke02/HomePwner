//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by Jordan Meeker on 4/30/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController

- (instancetype) initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) BNRItem *item;

@property (nonatomic, copy) void (^dismissBlock)(void);

@end
