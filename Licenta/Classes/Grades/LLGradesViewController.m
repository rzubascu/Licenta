//
//  LLGradesViewController.m
//  Licenta
//
//  Created by zubby on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLGradesViewController.h"

#pragma mark - Private

@interface LLGradesViewController () <UITableViewDataSource, UITableViewDelegate> {

}

@end

#pragma mark - Public

@implementation LLGradesViewController

- (id)initWithStudentObject:(NSManagedObject *)studentObject {
	self = [super initWithNibName:nil bundle:nil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
