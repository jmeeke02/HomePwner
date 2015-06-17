//
//  BNRItem.m
//  RandomItems
//
//  Created by Jordan Meeker on 4/14/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRItem.h"


@implementation BNRItem

+ (instancetype) randomItem {
   
   //Create an immutable array of three adjectives
   
   NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
   
   //Create and immutable arry of three nouns
   
   NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
   
   
   //Get the index of a random adjective and noun from each list
   //Note: % gives the remainder, so adjectiveIndex is a random number from 0-2 inclusive
   
   NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
   NSInteger nounIndex = arc4random() % [randomNounList count];
   
   //Note that NSInteger is not an object, but a type definition for "long"
   
   NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[adjectiveIndex],randomNounList[nounIndex]];
   
   int randomValue = arc4random() %100;
   
   NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", '0' + arc4random() %10,'A' + arc4random() % 26, '0' + arc4random() %10, 'A' + arc4random() % 26, '0' + arc4random() %10];
   
   BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
   
   return newItem;
   
}

//Designated intializer

- (instancetype) initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber  {
   
   //Call the superclass's init method first
   self = [super init];
   
   //did the superclass's designated intializer succeed
   if(self) {
      
      _itemName =name;
      _serialNumber = sNumber;
      _valueInDollars = value;
      
      //Set _dateCreated ot the current date/time
      
      _dateCreated = [[NSDate alloc] init];
      
      //Create an NSUUID object - get its string version and set that as this instnaces key
      NSUUID *uuid = [[NSUUID alloc] init];
      NSString *key = [uuid UUIDString];
      _itemKey = key;
   }
   
   //Return the address of the newly initialized object
   return self;
}


//Other initializers

- (instancetype) initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber {
   
   return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}


- (instancetype) initWithItemName:(NSString *)name {
   
   return [self initWithItemName:name serialNumber:@""];
}


- (instancetype) init {
   
   return [self initWithItemName:@"Item"];
}



//Description Override

- (NSString *) description {
   
   NSString *descriptionString =
   [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@", self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
   
   return descriptionString;
}

//Dealloc Override

- (void) dealloc {
   
   NSLog(@"Destroyed: %@", self);
   
}


@end
