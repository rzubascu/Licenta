//
//  LLStudentViewController.m
//  Licenta
//
//  Created by zubby on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLStudentViewController.h"
#import "LLStudentProfileCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

static const UIEdgeInsets kStudentsTableViewInsets = {0.0f, 0.0f, 94.0f, 0.0f};

#pragma mark - Private

@interface LLStudentViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	UITableView *_studentTableView; // Table view that display the info for a student
}
/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
/*
 * Call phone number
 */
- (void)callPhoneNumber;
/*
 * Send an email
 */
- (void)sendEmailTo:(NSString *)to;
@end

#pragma mark - Public

@implementation LLStudentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	// Table view
	_studentTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	_studentTableView.dataSource = self;
	_studentTableView.delegate = self;
	_studentTableView.contentInset = kStudentsTableViewInsets;
	_studentTableView.rowHeight = 100.0f;
	
	[self.view addSubview:_studentTableView];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"StudentCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell) {
		cell = [[LLStudentProfileCell alloc] initWithStyle:UITableViewCellStyleDefault
													  reuseIdentifier:cellIdentifier
				  phoneActionBlock:^{
					  [self callPhoneNumber];
				  } andEmailActionBlock:^{
					  [self sendEmailTo:nil];
				  }];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	// Update cell
	[self updateCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// insert code here
}

#pragma mark - Private

/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Call phone number
/*
 * Call phone number
 */
- (void)callPhoneNumber {
	NSString *callNUmberString = [NSString stringWithFormat:@"CALL 0000000 ?"];
	
	UIActionSheet *callActionSheet = [[UIActionSheet alloc] initWithTitle:callNUmberString
																					 delegate:self
																		 cancelButtonTitle:nil
																  destructiveButtonTitle:@"Cancel"
																		 otherButtonTitles:@"CALL", nil];
	[callActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (1 == buttonIndex) {
		NSString *telephoneNumber = @"0000000";
		NSURL *phoneNumberURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telephoneNumber]];
		[[UIApplication sharedApplication] openURL:phoneNumberURL];
	}
}

#pragma mark - Send email
/*
 * Send an email
 */
- (void)sendEmailTo:(NSString *)to {
	if ([MFMailComposeViewController canSendMail]) {
      
      MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
      mailViewController.mailComposeDelegate = self;
      [mailViewController setToRecipients:[NSArray arrayWithObject:to]];
      
      [self presentModalViewController:mailViewController animated:YES];
      
   }
   
   else {
      NSLog(@"Device is unable to send email in its current state.");
   }
}

/*
 * Mail composer delegate
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[self dismissModalViewControllerAnimated:YES];
}




@end
