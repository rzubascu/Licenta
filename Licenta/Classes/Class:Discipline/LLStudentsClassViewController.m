//
//  LLStudentsClassViewController.m
//  Licenta
//
//  Created by zubby on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLStudentsClassViewController.h"
#import "AppDelegate.h"
#import "LLStudentViewController.h"

static const UIEdgeInsets kStudentsTableViewInsets = {0.0f, 0.0f, 94.0f, 0.0f};

#pragma mark - Private

@interface LLStudentsClassViewController () <UITableViewDelegate, UITableViewDataSource> {
	NSNumber		*_currentClassID; // Current ID of the selected class
	NSArray		*_studentsArray; // Array of students from the selected class
	UITableView *_studentsTableView;
}

/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Public

@implementation LLStudentsClassViewController

- (id)initWithClassID:(NSNumber *)classID {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		// Custom initialization
		_currentClassID = classID;
		
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
		NSError *error;
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
		
		[fetchRequest setEntity:entity];
		
		NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"id_class == %@", _currentClassID];
		[fetchRequest setPredicate:newPredicate];
		
		NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
		_studentsArray = fetchedObjects;

	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = [NSString stringWithFormat:@"%@", _currentClassID];
	// Do any additional setup after loading the view.
	// Table view
	_studentsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_studentsTableView.dataSource = self;
	_studentsTableView.delegate = self;
	_studentsTableView.contentInset = kStudentsTableViewInsets;

	[self.view addSubview:_studentsTableView];
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
	
	return [_studentsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"StudentsClassCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
												reuseIdentifier:cellIdentifier];
	}
	
	// Update cell
	[self updateCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// insert code here
	NSManagedObject *selectedStudentObj = [_studentsArray objectAtIndex:indexPath.row];
	NSLog(@"Student from class %@", [[_studentsArray objectAtIndex:indexPath.row] valueForKey:@"id_class"]);
	LLStudentViewController *studentViewController = [[LLStudentViewController alloc] initWithStudentManagedObject:selectedStudentObj];
	[self.navigationController pushViewController:studentViewController animated:YES];
}

#pragma mark - Private

/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSManagedObject *currentStudent = [_studentsArray objectAtIndex:indexPath.row];
	cell.textLabel.text = [currentStudent valueForKey:@"name"];
}

@end
