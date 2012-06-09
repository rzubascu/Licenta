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
	UITableView			*_studentTableView; // Table view that display the info for a student
	NSManagedObject	*_studentManagedObject; // Current student object
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

- (id)initWithStudentManagedObject:(NSManagedObject *)studentManagedObject {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		// Custom initialization
		_studentManagedObject = studentManagedObject;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.navigationItem.title = @"Student Info";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger rowsNumber = (0 == section) ? 1 : 3;
	
	return rowsNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = (0 == indexPath.section) ? 100.0f : 44.0f;
	
	return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"StudentCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	Class cellClass = (0 == indexPath.section) ? [LLStudentProfileCell class] : [UITableViewCell class];
	if (nil == cell) {
		
		cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
										reuseIdentifier:cellIdentifier];
	}
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
	switch (indexPath.section) {
		case 0: {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			NSString *studentNameString = [_studentManagedObject valueForKey:@"name"];
			[(LLStudentProfileCell*)cell updateCellWithName:studentNameString
														  emailAddress:@"N/A" 
														andPhoneNumber:@"N/A"];
			break;
		}
		case 1: {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			switch (indexPath.row) {
				case 0: {
					cell.textLabel.text = @"Grades";
					break;
				}
				case 1: {
					cell.textLabel.text = @"Presence";
					break;
				}
				case 2: {
					cell.textLabel.text = @"Notes";
					cell.detailTextLabel.text = @"Something";
					break;
				}	
				default:
					break;
			}
			break;
		}
		default:
			break;
	}
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
