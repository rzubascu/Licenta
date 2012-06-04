//
//  LLAuthenticationHandler.m
//  Licenta
//
//  Created by zubby on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLAuthenticationHandler.h"

@implementation LLAuthenticationHandler 

@synthesize isAuthenticated = _isAuthenticated;

+ (LLAuthenticationHandler *)sharedInstance {
	static LLAuthenticationHandler *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [LLAuthenticationHandler new];
		// Do any other initialisation stuff here
	});
	return sharedInstance;
}

- (id)init {
	self = [super init];
	if (self) {
		// Add init code here...
	}
	return self;
}
// isAuthenticated setter
- (void)setIsAuthenticated:(BOOL)isAuthenticated {
	_isAuthenticated = isAuthenticated;
}

@end
