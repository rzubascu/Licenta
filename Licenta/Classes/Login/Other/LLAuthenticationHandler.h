//
//  LLAuthenticationHandler.h
//  Licenta
//
//  Created by zubby on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLAuthenticationHandler : NSObject {
	BOOL _isAuthenticated; // is any user authenticated flag
	int  _currentUserID;
}

@property (nonatomic, assign) BOOL	isAuthenticated;
@property (nonatomic, assign) int	currentUserID;

/*
 * Authentication shared instance
 */
+ (LLAuthenticationHandler *)sharedInstance;

@end
