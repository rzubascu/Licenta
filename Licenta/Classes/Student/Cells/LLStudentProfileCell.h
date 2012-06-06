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
 * Custom init method
 */
- (id)initWithStyle:(UITableViewCellStyle)style 
	 reuseIdentifier:(NSString *)reuseIdentifier 
	phoneActionBlock:(EmailPhoneActionBlock)phoneActionBlock
andEmailActionBlock:(EmailPhoneActionBlock)emailActionBlock;

@end
