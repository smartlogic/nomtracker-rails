//
//  NewTransactionViewController.m
//  NomTracker
//
//  Created by Michael Berkowitz on 8/6/09.
//  Copyright 2009 SmartLogic Solutions. All rights reserved.
//

#import "NomTrackerAppDelegate.h"
#import "NewTransactionViewController.h"
#import "Transaction.h"
#import "UserPickerViewController.h"
#import "DatePickerViewController.h"
#import "FindFirstResponder.h"

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CAAnimation.h>

@implementation NewTransactionViewController
@synthesize emailAddressField, transactionType, onField, forField, createTransactionButton, selectExistingButton, amount, transaction, ntDelegate, reloadView;
@synthesize pickUserViewController, pickDateViewController;
@synthesize selectImageButton, imagePicker, selectedImage, imagePreview;
@synthesize scrollView;
-(IBAction)createTransaction:(id)sender {
  NSString *urlString = [NSString stringWithFormat:@"%@transactions", [ObjectiveResourceConfig getSite]];
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
  [urlRequest setHTTPMethod:@"POST"];
	NSData *imageData = self.selectedImage;
	
  
	// Setup POST body
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
	[urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"]; 
	
  transaction.amount = amount.text;
  transaction.description = forField.text;
  transaction.when = onField.text;
  transaction.email = emailAddressField.text;
  if ([transactionType selectedSegmentIndex] == 0) {
    // credit
    transaction.transactionType = @"credit";
  } else {
    // debt
    transaction.transactionType = @"debt";
  }
	
  NSData *myNewBody;
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:transaction.amount, @"amount", transaction.description, @"description", transaction.when, @"when",transaction.email, @"email", transaction.transactionType, @"transaction_type", nil];
  myNewBody = [self createMultiPartFormData:dict withImage:imageData andItemKey:@"transaction"];
  [urlRequest setHTTPBody:myNewBody];
  Response *res = [Connection sendRequest:urlRequest withUser:[ObjectiveResourceConfig getUser] andPassword:[ObjectiveResourceConfig getPassword]];
  NSError *aError = nil;
  if ([res isError]) {
    aError = res.error;
    NSString *errors = [[NSString stringWithFormat:@"%@", [[aError errors] componentsJoinedByString:@"\n"]] stringByReplacingOccurrencesOfString:@"_id" withString:@""];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"There were errors saving this transaction" message:errors delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
  } else if ([res isSuccess]) {
    NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.rootController.selectedIndex = 0;
    [[delegate balancesController] popToRootViewControllerAnimated:YES];
  }
}


-(NSData *)createMultiPartFormData:(NSDictionary *)params withImage:(NSData *)image andItemKey:(NSString *)key {
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSMutableData *postBody = [NSMutableData data];

	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"format\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithString:@"iphone"] dataUsingEncoding:NSUTF8StringEncoding]];
  
  for (id dKey in params) {
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@[%@]\"\r\n\r\n", key, dKey] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:[params objectForKey:dKey]] dataUsingEncoding:NSUTF8StringEncoding]];
  }

  [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  if (image != NULL) {
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@[image]\"; filename=\"%@\"\r\n", key, @"this_image.jpg" ] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Type: image/jpg\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];  // jpeg as data
    [postBody appendData:[[NSString stringWithString:@"Content-Transfer-Encoding: binary\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:image];  // Tack on the imageData to the end    
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];  
  }
  return postBody;
}


-(IBAction)selectExistingContact:(id)sender {
  UserPickerViewController *upvController = [[UserPickerViewController alloc] initWithNibName:@"UserPickerView" bundle:nil];
  upvController.ntvController = self;

  UIView *thisFirstResponder = [self.view.superview findFirstResponder];
  if (thisFirstResponder != nil) {
    [thisFirstResponder resignFirstResponder];
  }
  
  upvController.view.alpha = 0;
  [self.view.superview addSubview:upvController.view];
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:1];
  upvController.view.alpha = 1;
  
  [UIView commitAnimations];
}

-(IBAction)selectDate:(id)sender {
  DatePickerViewController *dpvController = [[DatePickerViewController alloc] initWithNibName:@"DatePickerView" bundle:nil];
  dpvController.ntvController = self;

  UIView *thisFirstResponder = [self.view.superview findFirstResponder];
  if (thisFirstResponder != nil) {
    [thisFirstResponder resignFirstResponder];
  }
  
  dpvController.view.alpha = 0;
  [self.view.superview addSubview:dpvController.view];  
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:1];
  dpvController.view.alpha = 1;
  
  [UIView commitAnimations];
}

-(IBAction)switchTransactionType:(id)sender {
  if ([transactionType selectedSegmentIndex] == 0) {
    [transactionType setImage:[UIImage imageNamed:@"borrowed_unlit_checked.png"] forSegmentAtIndex:0];
    [transactionType setImage:[UIImage imageNamed:@"lentme_lit.png"] forSegmentAtIndex:1];
  } else {
    [transactionType setImage:[UIImage imageNamed:@"borrowed_lit.png"] forSegmentAtIndex:0];
    [transactionType setImage:[UIImage imageNamed:@"lentme_unlit_checked.png"] forSegmentAtIndex:1];
  }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  self.reloadView = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (self.reloadView == YES) {
    self.reloadTransaction;
    self.reloadView = NO;
  }
}

-(void)reloadTransaction {
  UserPickerViewController *upvController = [[UserPickerViewController alloc] initWithNibName:@"UserPickerView" bundle:nil];
  self.pickUserViewController = upvController;
  [upvController release];
  if (self.transaction == NULL) {
    Transaction *t = [[Transaction alloc] init];
    self.transaction = t;
    [t release];
  }
  
  self.imagePicker = [[UIImagePickerController alloc] init];
  imagePicker.allowsEditing = NO;
  imagePicker.delegate = self;
  imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  
//  [self.imagePreview removeFromSuperview];

//  amount.text = @"";
//  forField.text = @"";
//  onField.text = @"";
//  emailAddressField.text = @"";
//  transactionType.selectedSegmentIndex = 0;
}

-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  self.reloadView = YES;
}

-(IBAction)selectImage:(id)sender {
  [self presentModalViewController:self.imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
  self.selectedImage = [NSData dataWithData:UIImageJPEGRepresentation(img, 0.5)];
  UIImageView *iView = [[UIImageView alloc] initWithImage:img];
  iView.frame = CGRectMake(31.0f, 256.0f, 80.0f, 120.0f);
  self.imagePreview = iView;
  [iView release];
  [self.view addSubview:self.imagePreview];

  
  self.reloadView = NO;
  [[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  [theTextField resignFirstResponder];
  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
  [emailAddressField release];
  [transactionType release];
  [onField release];
  [forField release];
  [createTransactionButton release];
  [selectExistingButton release];
  [amount release];
  [transaction release];
  [ntDelegate release];
  [pickUserViewController release];
  [pickDateViewController release];
  [selectImageButton release];
  [imagePicker release];
  [selectedImage release];
  [super dealloc];
}


@end
