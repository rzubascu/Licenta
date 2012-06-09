//
//  LLEventsTableViewController.h
//  Licenta
//
//  Created by zubby on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface LLEventsTableViewController : UITableViewController <UINavigationBarDelegate, UITableViewDelegate, 
EKEventEditViewDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, EKEventViewDelegate> {
    
	EKEventViewController *_detailViewController;
	EKEventStore            *_eventStore;
	EKCalendar              *_defaultCalendar;
	NSMutableArray          *_eventsList;
}

@property (nonatomic, retain) EKEventStore          *eventStore;
@property (nonatomic, retain) EKCalendar            *defaultCalendar;
@property (nonatomic, retain) NSMutableArray        *eventsList;
@property (nonatomic, retain) EKEventViewController *detailViewController;

- (NSArray *) fetchEventsForToday;
- (IBAction) addEvent:(id)sender;

@end;