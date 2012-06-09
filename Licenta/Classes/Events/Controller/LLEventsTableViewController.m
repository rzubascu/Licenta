//
//  LLEventsTableViewController.m
//  Licenta
//
//  Created by zubby on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLEventsTableViewController.h"

@interface LLEventsTableViewController ()

@end

@implementation LLEventsTableViewController

@synthesize eventsList              = _eventsList;
@synthesize detailViewController    = _detailViewController;
@synthesize eventStore              = _eventStore;
@synthesize defaultCalendar         = _defaultCalendar;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addEvent:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationController.delegate = self;
    self.title = @"Events List";
    self.navigationController.tabBarItem.title = @"Events";
	
	// Initialize an event store object with the init method. Initilize the array for events.
	self.eventStore = [[EKEventStore alloc] init];
    
	self.eventsList = [[NSMutableArray alloc] initWithArray:0];
	
	// Get the default calendar from store.
	self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];	
	
	// Fetch today's event on selected calendar and put them into the eventsList array
	[self.eventsList addObjectsFromArray:[self fetchEventsForToday]];
    
	[self.tableView reloadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_eventsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    cell.textLabel.text = [[self.eventsList objectAtIndex:indexPath.row] title];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_eventsList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Upon selecting an event, create an EKEventViewController to display the event.
	self.detailViewController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];	
    _detailViewController.delegate = self;
	_detailViewController.event = [self.eventsList objectAtIndex:indexPath.row];
    
	// Allow event editing.
	_detailViewController.allowsEditing = YES;
	
	//	Push detailViewController onto the navigation controller stack
	//	If the underlying event gets deleted, detailViewController will remove itself from
	//	the stack and clear its event property.
	[self.navigationController pushViewController:_detailViewController animated:YES];
}


#pragma mark - Navigation Controller delegate

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	// if we are navigating back to the rootViewController, and the detailViewController's event
	// has been deleted -  will title being NULL, then remove the events from the eventsList
	// and reload the table view. This takes care of reloading the table view after adding an event too.
	if (viewController == self && self.detailViewController.event.title == NULL) {
		[self.eventsList removeObject:self.detailViewController.event];
	}
    [self.tableView reloadData];
}

#pragma mark - Add a new event

// If event is nil, a new event is created and added to the specified event store. New events are 
// added to the default calendar. An exception is raised if set to an event that is not in the 
// specified event store.
- (void)addEvent:(id)sender {
	// When add button is pushed, create an EKEventEditViewController to display the event.
	EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	
	// set the addController's event store to the current event store.
	addController.eventStore = self.eventStore;
	
	// present EventsAddViewController as a modal view controller
	[self presentModalViewController:addController animated:YES];
	
	addController.editViewDelegate = self;
}


#pragma mark - EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller 
          didCompleteWithAction:(EKEventEditViewAction)action {
	
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store, 
			// and reload table view.
			// If the new event is being added to the default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.eventsList addObject:thisEvent];
			}
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store, 
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.eventsList removeObject:thisEvent];
			}
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissModalViewControllerAnimated:YES];
	
}

// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}

#pragma mark - Table view data source

// Fetching events happening in the next 24 hours with a predicate, limiting to the default calendar 
- (NSArray *)fetchEventsForToday {
	
	NSDate *startDate = [NSDate date];
	
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:86400];
	
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:_defaultCalendar];
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate 
                                                                    calendars:calendarArray]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
    
	return events;
}

#pragma mark - EKEventViewDelegate methods

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action {
	EKEvent *thisEvent = controller.event;
	
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing. 
			break;
			
		case EKEventEditViewActionSaved:
			[self.tableView reloadData];
			break;
			
		case EKEventEditViewActionDeleted:
			// If deleting an event from the currenly default calendar, then update its 
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.eventsList removeObject:thisEvent];
			}
			[self.tableView reloadData];
			break;
			
		default:
			break;
	}
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
