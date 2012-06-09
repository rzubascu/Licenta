//
//  AppDelegate.h
//  Licenta
//
//  Created by zubby on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LLLoginViewController;
@class LLClassesViewController;
@class LLSearchTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	UITabBarController *_tabBarController;
	LLLoginViewController *_firstController;
	LLClassesViewController *_secondController;
	UIViewController *_thirdController;
	LLSearchTableViewController *_searchTableViewController;
	UINavigationController *_navigationController;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
