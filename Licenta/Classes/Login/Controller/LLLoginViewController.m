//
//  LLLoginViewController.m
//  Licenta
//
//  Created by zubby on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLLoginViewController.h"
#import "LLLoginCell.h"
#import "AppDelegate.h"
#import "LLAuthenticationHandler.h"
#import "Defines.h"

static const CGRect kInputTextFieldFrame	= {35.0f, 0.0f, 254.0f, 40.0f};
static const CGRect kTitleLabelFrame		= {0.0f, 0.0f, 320.0f, 100.0f};
static const CGRect kLoginTableViewFrame	= {0.0f, 100.0f, 320.0f, 300.0f};
static const CGRect kLoginButtonFrame		= {30.0f, 185.0f, 260.0f, 60.0f};

#pragma mark - Private

@interface LLLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *_loginTableView; // Login table view
	UILabel		*_titleLabel;
	UITextField *_userNameTextField;
	UITextField *_passwordtextField;
	UIButton		*_submitButton;
}

/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
/*
 * Authenticate user
 */
- (void)authenticateUserWithuUsername:(NSString *)username andPassword:(NSString *)password;
/*
 * Login succesfull
 */
- (void)loginSuccessful;

@end

#pragma mark - Public

@implementation LLLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor redColor];
	
	// Login title label
	_titleLabel = [[UILabel alloc] initWithFrame:kTitleLabelFrame];
	_titleLabel.text = @"Please Login";
	_titleLabel.textAlignment = UITextAlignmentCenter;
	_titleLabel.backgroundColor = [UIColor clearColor];
	
	// Login table view
	_loginTableView = [[UITableView alloc] initWithFrame:kLoginTableViewFrame style:UITableViewStylePlain];
	_loginTableView.delegate = self;
	_loginTableView.dataSource = self;
	_loginTableView.scrollEnabled = NO;
	_loginTableView.backgroundColor = [UIColor clearColor];
	_loginTableView.separatorColor = [UIColor clearColor];
	
	// Username text field
	_userNameTextField = [[UITextField alloc] initWithFrame:kInputTextFieldFrame];
	_userNameTextField.placeholder = @"Enter username";
	//	_inputTextField.backgroundColor = [UIColor greenColor];
	_userNameTextField.textAlignment = UITextAlignmentCenter;
	_userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	_userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_userNameTextField.delegate = self;
	_userNameTextField.returnKeyType = UIReturnKeyNext;
	_userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_userNameTextField.borderStyle = UITextBorderStyleRoundedRect;

	// Username text field
	_passwordtextField = [[UITextField alloc] initWithFrame:kInputTextFieldFrame];
	_passwordtextField.placeholder = @"Enter password";
	//	_inputTextField.backgroundColor = [UIColor greenColor];
	_passwordtextField.textAlignment = UITextAlignmentCenter;
	_passwordtextField.autocorrectionType = UITextAutocorrectionTypeNo;
	_passwordtextField.clearButtonMode = UITextFieldViewModeWhileEditing;
	_passwordtextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	_passwordtextField.delegate = self;
	_passwordtextField.returnKeyType = UIReturnKeyDone;
	_passwordtextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_passwordtextField.secureTextEntry = YES;
	_passwordtextField.borderStyle = UITextBorderStyleRoundedRect;
	
	_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_submitButton.frame = kLoginButtonFrame;
	[_submitButton setImage:[UIImage imageNamed:@"microapp_submit_btn"] forState:UIControlStateNormal];
	[_submitButton addTarget:self action:@selector(loginButtonWasTapped) forControlEvents:UIControlEventTouchDown];

	
	// Tap gesture recognizer
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
	
	[self.view addSubview:_titleLabel];
	[self.view addSubview:_loginTableView];
	[self.view addGestureRecognizer:tapGesture];
	[self.view addSubview:_submitButton];
	
	// Already logged-in?
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL isUserLogged = [userDefaults boolForKey:kIsUserLogged];
	if (isUserLogged) {
		NSString *username = [userDefaults objectForKey:kUsernameKey];
		_userNameTextField.text = username;
		NSString *password = [userDefaults objectForKey:kPasswordKey];
		_passwordtextField.text = password;
		[self loginSuccessful];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate & UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"LoginCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell) {
		cell = [[LLLoginCell alloc] initWithStyle:UITableViewCellStyleDefault
										  reuseIdentifier:cellIdentifier
													 andType:indexPath.row];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	// Update cell
	[self updateCell:cell atIndexPath:indexPath];
	
	return cell;
}

#pragma mark - Private
/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case kUsernameCell: {
			[cell addSubview:_userNameTextField];
			break;
		}
		case kPasswordCell: {
			[cell addSubview:_passwordtextField];
			break;
		}
		case kSubmitCell: {
			break;
		}
		default:
			break;
	}
	
}

/*
 * Authenticate user method
 */
- (void)authenticateUserWithuUsername:(NSString *)username andPassword:(NSString *)password {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSError *error;

	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (NSManagedObject *info in fetchedObjects) {
//		NSLog(@"UserName: %@", [info valueForKey:@"username"]);
//		NSLog(@"Password: %@", [info valueForKey:@"password"]);
		if ([username isEqualToString:[info valueForKey:@"username"]] && [password isEqualToString:[info valueForKey:@"password"]]) {
			[self loginSuccessful];
		} else {
			NSLog(@"Error while logging in");
		}
	}
}

/*
 * Login succesfull
 */
- (void)loginSuccessful {
	NSLog(@"Success !!!!! ");
	[_userNameTextField setEnabled:NO];
	_userNameTextField.textColor = [UIColor lightGrayColor];
	[_passwordtextField setEnabled:NO];
	_passwordtextField.textColor = [UIColor lightGrayColor];
	_submitButton.enabled = NO;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:YES forKey:kIsUserLogged];
	NSString *username = _userNameTextField.text;
	[userDefaults setObject:username forKey:kUsernameKey];
	NSString *password = _passwordtextField.text;
	[userDefaults setObject:password forKey:kPasswordKey];
	// User successfully authenticated
	[[LLAuthenticationHandler sharedInstance] setIsAuthenticated:YES];
	
}

- (void)dismissKeyboard {
	[_userNameTextField resignFirstResponder];
	[_passwordtextField resignFirstResponder];
}

- (void)loginButtonWasTapped {
	[self authenticateUserWithuUsername:_userNameTextField.text andPassword:_passwordtextField.text];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _userNameTextField) {
		[_passwordtextField becomeFirstResponder];
	} else {
		[self authenticateUserWithuUsername:_userNameTextField.text andPassword:_passwordtextField.text];
		[_passwordtextField resignFirstResponder];
	}
	
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	
	return YES;
}

@end
