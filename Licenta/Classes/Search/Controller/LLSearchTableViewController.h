//
//  LLSearchTableViewController.h
//  Licenta
//
//  Created by zubby on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSearchTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
{
	NSArray						*_listContent;			// The master content.
	NSMutableArray				*_filteredListContent;	// The content filtered as a result of a search.
	UISearchDisplayController	*_generalSearchDisplayController;
}

@property (nonatomic, retain) NSArray                   *listContent;
@property (nonatomic, retain) NSMutableArray            *filteredListContent;
@property (nonatomic, retain) UISearchDisplayController	*generalSearchDisplayController;

@end
