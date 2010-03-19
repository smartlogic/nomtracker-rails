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
#import "FindFirstResponder.h"

#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/CAAnimation.h>

@implementation NewTransactionViewController
@synthesize emailAddressField, transactionType, forField, createTransactionButton, amount, transaction, ntDelegate;
@synthesize scrollView;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.transaction = [[Transaction alloc]init];
}

-(IBAction)createTransaction:(id)sender {
  NSString *urlString = [NSString stringWithFormat:@"%@transactions", [ObjectiveResourceConfig getSite]];
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
  [urlRequest setHTTPMethod:@"POST"];	
  
	// Setup POST body
	NSString *stringBoundary = [NSString stringWithString:@"0xKhTmLbOuNdArY"];
	NSString *contentType    = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", stringBoundary];
	[urlRequest addValue:contentType forHTTPHeaderField:@"Content-Type"]; 
	
  // Retrieve values from form fields
  transaction.amount = amount.text;
  transaction.description = forField.text;
  transaction.email = emailAddressField.text;
  transaction.transactionType = [transactionType selectedSegmentIndex] == 0 ? @"credit" : @"debt";
	
  // Add form values to request body
  NSData *myNewBody;
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:transaction.amount, @"amount", transaction.description, @"description",transaction.email, @"email", transaction.transactionType, @"transaction_type", nil];
  myNewBody = [self createMultiPartFormData:dict withItemKey:@"transaction"];
  [urlRequest setHTTPBody:myNewBody];
  
  // Make request
  Response *res = [Connection sendRequest:urlRequest withUser:[ObjectiveResourceConfig getUser] andPassword:[ObjectiveResourceConfig getPassword]];
  NSError *aError = nil;
  
  if ([res isError]) {
    aError = res.error;
    NSString *errors = [[NSString stringWithFormat:@"%@", [[aError errors] componentsJoinedByString:@"\n"]] stringByReplacingOccurrencesOfString:@"_id" withString:@""];
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"There were errors saving this transaction" message:errors delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
  } else if ([res isSuccess]) {
    amount.text = @"";
    forField.text = @"";
    emailAddressField.text = @"";
    transactionType.selectedSegmentIndex = 0;
    [transaction release];
    transaction = [[Transaction alloc] init];
    
    NomTrackerAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.rootController.selectedIndex = 0;
    [[delegate balancesController] popToRootViewControllerAnimated:YES];
  }
}


-(NSData *)createMultiPartFormData:(NSDictionary *)params withItemKey:(NSString *)key {
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

  return postBody;
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

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  [theTextField resignFirstResponder];
  return YES;
}

- (void)dealloc {
  [emailAddressField release];
  [transactionType release];
  [forField release];
  [createTransactionButton release];
  [amount release];
  [transaction release];
  [ntDelegate release];
  [super dealloc];
}

@end