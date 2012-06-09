//
//  LLStudentProfileCell.h
//  Licenta
//
//  Created by zubby on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EmailPhoneActionBlock)();

@interface LLStudentProfileCell : UITableViewCell

/*
 * Update cell with name, email and phone number
 */
- (void)updateCellWithName:(NSString *)nameString 
				  emailAddress:(NSString *)emailAddress
				andPhoneNumber:(NSString *)phoneNumber;


@end
