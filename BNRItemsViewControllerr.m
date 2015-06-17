//
//  BNRItemsViewController.m
//  HomePwner
//
//  Created by John Gallagher on 1/7/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRItemsViewControllerr.h"

#import "BNRDetailViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@interface BNRItemsViewControllerr ()



@end

@implementation BNRItemsViewControllerr

#pragma mark - Controller Life Cycle (Initializers)

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
      
    if (self) {
      
       UINavigationItem *navItem = self.navigationItem;
       navItem.title = @"Homepwner";
       
       //Create a new bar button itme that will send addNewItem: to BNRItemsViewController
       UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
       
       //Set this bar button item as the right item in navigationITem
       navItem.rightBarButtonItem = bbi;
       
       navItem.leftBarButtonItem = self.editButtonItem;
       
       }
       
   
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];

}


#pragma mark - Table View
//Create the BNRDetailViewController and push it on the top of the stack when an item in the list is selected

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
   BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
   
   NSArray *items = [[BNRItemStore sharedStore] allItems];
   BNRItem *selectedItem = items[indexPath.row];
   
   //Give the detailed Viewcontroller a pointer to the item object in the current row selected using the setter to set the item
   
   detailViewController.item = selectedItem;
   
   //Push the detail view controller onto the top of the navigation controllers stack
   [self.navigationController pushViewController:detailViewController animated:YES];
   
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // Get a new or recycled cell
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
   
   // Set the text on the cell with the description of the item
   // that is at the nth index of items, where n = row this cell
   // will appear in on the tableview
   NSArray *items = [[BNRItemStore sharedStore] allItems];
   BNRItem *item = items[indexPath.row];
   
   cell.textLabel.text = [item description];
   
   return cell;
}

//When asked to delete a row- let this happend - button will send this message asking to delete

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   //If the table view is asking to commit a delete command..
   if(editingStyle == UITableViewCellEditingStyleDelete) {
      NSArray *items = [[BNRItemStore sharedStore] allItems];
      BNRItem *item= items[indexPath.row];
      [[BNRItemStore sharedStore] removeItem:item];
      
      
      //Also remove the row from the tale view
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
   }
   
}

//When asked to move a row, table will automatically send this message

- (void) tableView:(UITableView *) tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
   
   [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (void) viewWillAppear:(BOOL)animated {
   
   [super viewWillAppear:animated];
   
   [self.tableView reloadData];
}


#pragma mark - Actions

- (IBAction)addNewItem:(id)sender
{
   
   //create an new item, by initializing sharedStore (can only do this bc static sharedStore instance of BNRItemStore that is preserved)
   BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
   
   BNRDetailViewController *detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
   
   detailViewController.item = newItem;
   
   //the block
   detailViewController.dismissBlock = ^{
      [self.tableView reloadData];
   };
   
   UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
   
   navController.modalPresentationStyle = UIModalPresentationFormSheet;
   navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
   
   [self presentViewController:navController animated:YES completion:NULL];
   
   
   }











@end
