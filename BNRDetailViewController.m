//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by Jordan Meeker on 4/30/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"


@interface BNRDetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation BNRDetailViewController

//When BNRItemsVC uses setter item to set the item property, also set this as the NavBar title property

-(void)setItem:(BNRItem *)item {
   
   _item = item;
   self.navigationItem.title = item.itemName;
   
}
#pragma mark - Initializers

//Designated Initializer

-(instancetype) initForNewItem:(BOOL)isNew
{
   self = [super initWithNibName:nil bundle:nil];
   
   if (self) {
      if(isNew) {
         UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
         self.navigationItem.rightBarButtonItem= doneItem;
         
         UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
         self.navigationItem.leftBarButtonItem = cancelItem;
      }
   }
   return self;
}
//Override superclass's designated initializer

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   
   [NSException raise:@"Wrong initializer" format:@"Use initForNewItem:"];
   
   return nil;
}

#pragma mark - View Life Cycle

- (void) prepareViewsForOrientation: (UIInterfaceOrientation) orientation {
   
   //Is it an iPad? No prep neccessary
   if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      return;
   }
   
   //Is it landscape?
   
   if(UIInterfaceOrientationIsLandscape(orientation)) {
      
      self.imageView.hidden = YES;
      self.cameraButton.enabled = NO;
      
   }else {
      self.imageView.hidden = NO;
      self.cameraButton.enabled = YES;
   }
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
   
   [self prepareViewsForOrientation:toInterfaceOrientation];
}

- (void) viewWillAppear:(BOOL)animated {
   
   [super viewWillAppear:animated];
   
   UIInterfaceOrientation iO = [[UIApplication sharedApplication] statusBarOrientation];
   [self prepareViewsForOrientation:iO];
   
   BNRItem *item = self.item;
   
   self.nameField.text = item.itemName;
   self.serialNumberField.text = item.serialNumber;
   self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
   
   //You need an NSDateFormatter that will turn a date into a simple dat string
   
   static NSDateFormatter *dateFormatter;
   if(!dateFormatter) {
      
      dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateStyle = NSDateFormatterMediumStyle;
      dateFormatter.timeStyle =NSDateFormatterNoStyle;
   }
   
   //Use filtered NSDate object to set dateLabel contents
   self.dateLabel.text =[dateFormatter stringFromDate:item.dateCreated];
   
   NSString *itemKey =self.item.itemKey;
   
   //Get the image for its image key from the imageStore
   UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:itemKey];
   
   //Put that image on screen in imageView
   self.imageView.image = imageToDisplay;
   
}

- (void) viewWillDisappear:(BOOL)animated {
   
   [super viewWillDisappear:YES];
   
   //Clear first responder
   [self.view endEditing:YES];
   
   //Save Changes to the Item
   BNRItem *item = self.item;
   item.itemName = self.nameField.text;
   item.serialNumber = self.serialNumberField.text;
   item.valueInDollars = [self.valueField.text intValue];
   
}

#pragma mark - Keyboard Handling

//Text field should return, closes text field when return button pressed

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
   
   [textField resignFirstResponder];
   return YES;
}

- (IBAction)backgroudTapped:(id)sender {
   
   [self.view endEditing:YES];
   
}


#pragma mark - Image Handling

- (IBAction)takePicture:(id)sender {
   
   //Prevent destruction of popover by double tapping camera button
   
   if ([self.imagePickerPopover isPopoverVisible]) {
      
      //If popover is already up, get rid of it
      [self.imagePickerPopover dismissPopoverAnimated:YES];
      self.imagePickerPopover =nil;
      return;
   }
   
   
   UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
   
   //if the device has a camera take a picture otherwise, use the photo library
   
   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
   } else {
      imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   }
   imagePicker.delegate = self;
   imagePicker.allowsEditing = YES;
   
   //Place the imagePicker on screen
   
   
   //Place image picker on the screen
   //check for iPad device before instatiating the popover controller
   if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      
      //Create a new popover controller that will dispaly the imagePicker
      self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
      self.imagePickerPopover.popoverBackgroundViewClass = nil;
      
      //Would need to create a UIPopoverBackgroundView to use as the class - create a custom
      
      self.imagePickerPopover.delegate = self;
      
      //Display the popover controller; sender is the camera bar button item
      [self.imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
      
   } else {
      [self presentViewController:imagePicker animated:YES completion:NULL];
   }
   
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
   
   NSLog(@"User dismissed popover");
   self.imagePickerPopover = nil;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
   
   //Get Picked Image from info dictionary
   UIImage *image = info[UIImagePickerControllerEditedImage];
   
   [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
   
   //Put this image on the screen in our image view - set that image view outlet
   self.imageView.image = image;
   
   //take image picker off the screen, must call this dismiss method or well be stuck on the modal view for image
   //Do I have a popover?
   if (self.imagePickerPopover) {
      //Dismiss it
      [self.imagePickerPopover dismissPopoverAnimated:YES];
      self.imagePickerPopover =nil;
      
   } else {
      
      //Dismiss the model image picker
   
   [self dismissViewControllerAnimated:YES completion:NULL];
   
   }
}

- (IBAction)deleteImage:(id)sender {
   
   BNRImageStore *store =[BNRImageStore sharedStore];
   
   [store deleteImageForKey:self.item.itemKey];
   
   self.imageView.image = nil;
   
  
}

- (void) viewDidLoad {
   
   [super viewDidLoad];
   
   UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
   
   //The contentMode of the image view in the XIB was Aspect Fit
   iv.contentMode = UIViewContentModeScaleAspectFit;
   
   //Do not produce a translated constraint for this view
   iv.translatesAutoresizingMaskIntoConstraints =NO;
   
   //The imageview was a subivew of the view
   [self.view addSubview:iv];
   
   //The imageview was pointed to by the imageViewProperty
   self.imageView = iv;
   
   //Set the vertical property to be less than those of the other subviews
   [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
   [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
   
   NSDictionary *nameMap = @{@"imageView" :self.imageView,
                             @"dateLabel" :self.dateLabel,
                             @"toolbar" :self.toolbar};
   
   //imageView is 0pts form superview left and right
   
   NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
   
   //imageView is 8 pts form dataLable and from toolBar
   NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]" options:0 metrics:nil views:nameMap];
   
   
   [self.view addConstraints:horizontalConstraints];
   [self.view addConstraints:verticalConstraints];
   
}

#pragma mark - actions

- (void) save:(id)sender
{
   [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}


-(void) cancel:(id)sender
{
   
   //If users cancels remove the BNRItem form store
   [[BNRItemStore sharedStore] removeItem:self.item];
   
   [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}








@end
