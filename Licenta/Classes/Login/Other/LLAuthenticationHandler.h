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
}

@property (nonatomic, assign) BOOL isAuthenticated;

/*
 * Authentication shared instance
 */
+ (LLAuthenticationHandler *)sharedInstance;

@end
