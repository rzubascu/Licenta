//
//  AppDelegate.m
//  Licenta
//
//  Created by zubby on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LLLoginViewController.h"
#import "LLClassesViewController.h"
#import "LLSearchTableViewController.h"
#import "LLEventsTableViewController.h"

@implementation AppDelegate

@synthesize window							= _window;
@synthesize managedObjectContext			= __managedObjectContext;
@synthesize managedObjectModel			= __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	NSManagedObjectContext *context = [self managedObjectContext];
//	NSManagedObject *failedBankInfo = [NSEntityDescription
//												  insertNewObjectForEntityForName:@"Teacher"
//												  inManagedObjectContext:context];
//	[failedBankInfo setValue:@"ancuta" forKey:@"username"];
//	[failedBankInfo setValue:@"baritiu" forKey:@"password"];
//	[failedBankInfo setValue:[NSNumber numberWithInt:1] forKey:@"id_teacher"];
//	NSManagedObject *failedBankInfo = [NSEntityDescription
//												  insertNewObjectForEntityForName:@"Teacher_Class"
//												  inManagedObjectContext:context];
//	[failedBankInfo setValue:[NSNumber numberWithInt:1115] forKey:@"id_class"];
//	[failedBankInfo setValue:[NSNumber numberWithInt:1004] forKey:@"id_discipline"];
//	[failedBankInfo setValue:[NSNumber numberWithInt:1] forKey:@"id_teacher"];
//	[failedBankInfo setValue:@"Fourth discipline" forKey:@"discipline_name"];
	
//	int studentID = 9069;
//	for (int i = 0; i <= 15; i++) {
//		studentID++;
//		NSString *studentName = [NSString stringWithFormat:@"Other %d", i];
//		NSManagedObject *failedBankInfo = [NSEntityDescription
//													  insertNewObjectForEntityForName:@"Student"
//													  inManagedObjectContext:context];
//		[failedBankInfo setValue:[NSNumber numberWithInt:1115] forKey:@"id_class"];
//		[failedBankInfo setValue:[NSNumber numberWithInt:studentID] forKey:@"id_student"];
//		[failedBankInfo setValue:studentName forKey:@"name"];
//		
//		NSError *error;
//
//		if (![context save:&error]) {
//			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//		}
//
//	}
	

	NSError *error;
//	if (![context save:&error]) {
//		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (NSManagedObject *info in fetchedObjects) {
		NSLog(@"ID class: %@", [info valueForKey:@"id_class"]);
		NSLog(@"ID student: %@", [info valueForKey:@"id_student"]);
		NSLog(@"Student name: %@", [info valueForKey:@"name"]);
	}
	

	
	_tabBarController = [[UITabBarController alloc] init];
	
	_firstController = [[LLLoginViewController alloc] initWithNibName:nil bundle:nil];
	_firstController.tabBarItem.title = @"Login";
	
	_secondController = [[LLClassesViewController alloc] initWithNibName:nil bundle:nil];
	_navigationController = [[UINavigationController alloc] initWithRootViewController:_secondController];
	_navigationController.tabBarItem.title = @"Classes";
	_navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

	_eventsTableViewController = [[LLEventsTableViewController alloc] initWithNibName:nil bundle:nil];
    _eventsNavigationController = [[UINavigationController alloc] initWithRootViewController:_eventsTableViewController];
    _eventsNavigationController.tabBarItem.title = @"Events";
    _eventsNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
	_searchTableViewController = [[LLSearchTableViewController alloc] initWithNibName:nil bundle:nil];
	_searchTableViewController.tabBarItem.title = @"Search";
    
	NSArray* controllers = [NSArray arrayWithObjects:_firstController, _navigationController, _eventsNavigationController, _searchTableViewController, nil];
	
	[_tabBarController setViewControllers:controllers animated:YES];
	
	[self.window setRootViewController:_tabBarController];

	// Override point for customization after application launch.
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

- (void)saveContext {
	NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	if (managedObjectContext != nil) {
		if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		} 
	}
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
	if (__managedObjectContext != nil) {
		return __managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		__managedObjectContext = [[NSManagedObjectContext alloc] init];
		[__managedObjectContext setPersistentStoreCoordinator:coordinator];
	}
	return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
	if (__managedObjectModel != nil)
	{
		return __managedObjectModel;
	}
	NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Licenta" withExtension:@"momd"];
	__managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (__persistentStoreCoordinator != nil) {
		return __persistentStoreCoordinator;
	}
	
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Licenta.sqlite"];
	
	NSError *error = nil;
	__persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible;
		 * The schema for the persistent store is incompatible with current managed object model.
		 Check the error message to determine what the actual problem was.
		 
		 
		 If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
		 
		 If you encounter schema incompatibility errors during development, you can reduce their frequency by:
		 * Simply deleting the existing store:
		 [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
		 
		 * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
		 [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
		 
		 Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
		 
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}    
	
	return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
