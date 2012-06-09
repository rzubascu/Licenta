//
//  LLSearchTableViewController.m
//  Licenta
//
//  Created by zubby on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLSearchTableViewController.h"
#import "AppDelegate.h"

@implementation LLSearchTableViewController

@synthesize listContent                     = _listContent;
@synthesize filteredListContent             = _filteredListContent;
@synthesize generalSearchDisplayController  = _generalSearchDisplayController;

#pragma mark - Lifecycle methods

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
	self.filteredListContent = [[NSMutableArray alloc] init];
	
	UISearchBar *mySearchBar = [[UISearchBar alloc] init];
	[mySearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"Student", @"Group",nil]];
	mySearchBar.delegate = self;
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[mySearchBar sizeToFit];
    mySearchBar.barStyle = UIBarStyleBlackOpaque;
    mySearchBar.placeholder = @"Search";
	self.tableView.tableHeaderView = mySearchBar;

    self.tableView.tableHeaderView.frame = CGRectMake(0.f, 0.f, 320.f, 44.f);

	// set up the searchDisplayController programically
	_generalSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
	[self setGeneralSearchDisplayController:_generalSearchDisplayController];
	[_generalSearchDisplayController setDelegate:self];
	[_generalSearchDisplayController setSearchResultsDataSource:self];
    
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
}


- (void)viewWillAppear:(BOOL)animated {
	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    
    [self.searchDisplayController setActive:YES animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView data source and delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredListContent count];
    }
	else {
        return [self.listContent count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {	
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    NSManagedObject *managedObject = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        managedObject = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else {
        managedObject = [self.listContent objectAtIndex:indexPath.row];
    }
    
	cell.textLabel.text = [managedObject valueForKey:@"name"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
//    NSManagedObject *managedObject = nil;
//	if (tableView == self.searchDisplayController.searchResultsTableView) {
//        managedObject = [self.filteredListContent objectAtIndex:indexPath.row];
//    }
//	else {
//        managedObject = [self.listContent objectAtIndex:indexPath.row];
//    }    
}

#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    if (nil != searchText) {
        // Update the filtered array based on the search text and scope.
        
        [self.filteredListContent removeAllObjects];// First clear the filtered array.
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSError *error;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"(name CONTAINS %@)", searchText];
        [fetchRequest setPredicate:newPredicate];
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        self.filteredListContent = [NSMutableArray arrayWithArray:fetchedObjects];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
	// Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
	// Hide the search bar
	//[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
}

@end
