//
//  LLClassesViewController.m
//  Licenta
//
//  Created by zubby on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLClassesViewController.h"
#import "AppDelegate.h"
#import "LLAuthenticationHandler.h"

#pragma mark - Private

@interface LLClassesViewController () <UITableViewDataSource, UITableViewDelegate> {
	UITableView		*_classesTableView;
	NSMutableArray	*_disciplinesIDArray;
}

/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;


@end


#pragma mark - Public

@implementation LLClassesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor greenColor];
	// Do any additional setup after loading the view.
	_disciplinesIDArray = [NSMutableArray new];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSError *error;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Teacher_Class" inManagedObjectContext:context];

	[fetchRequest setEntity:entity];
	
	int teacherID = [[LLAuthenticationHandler sharedInstance] currentUserID];
	NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"id_teacher == %@", [NSNumber numberWithInt:teacherID]];
	[fetchRequest setPredicate:newPredicate];
	fetchRequest.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"id_discipline"]];
	fetchRequest.returnsDistinctResults = YES;
	fetchRequest.resultType = NSDictionaryResultType;
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

	[_disciplinesIDArray addObjectsFromArray:fetchedObjects];
	
	// Table view
	_classesTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_classesTableView.dataSource = self;
	_classesTableView.delegate = self;
	
	
	[self.view addSubview: _classesTableView];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private

/*
 * Update cell at index path
 */
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSError *error;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Teacher_Class" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	NSNumber *disciplineID = [[_disciplinesIDArray objectAtIndex:indexPath.section] valueForKey:@"id_discipline"];
	int teacherID = [[LLAuthenticationHandler sharedInstance] currentUserID];
	NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"(id_discipline == %@) AND (id_teacher == %@)", disciplineID, [NSNumber numberWithInt:teacherID]];
	[fetchRequest setPredicate:newPredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@", [[fetchedObjects objectAtIndex:indexPath.row] valueForKey:@"id_class"]];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [_disciplinesIDArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSError *error;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Teacher_Class" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	NSNumber *disciplineID = [[_disciplinesIDArray objectAtIndex:section] valueForKey:@"id_discipline"];
	int teacherID = [[LLAuthenticationHandler sharedInstance] currentUserID];
	NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"(id_discipline == %@) AND (id_teacher == %@)", disciplineID, [NSNumber numberWithInt:teacherID]];
	[fetchRequest setPredicate:newPredicate];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

	return [fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"LoginCellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (nil == cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
												reuseIdentifier:cellIdentifier];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	// Update cell
	[self updateCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	return [NSString stringWithFormat:@"%@", [[_disciplinesIDArray objectAtIndex:section] valueForKey:@"id_discipline"]];
}


@end
