//
//  LLLoginCell.h
//  VetMicrochip
//
//  Created by zubby on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
// Cell type enum
typedef enum VMCellType {
	kUsernameCell = 0,
	kPasswordCell,
	kSubmitCell
} VMCellType;

@interface LLLoginCell : UITableViewCell {
	UIButton *_submitButton;
}

@property (nonatomic, strong) UIButton *submitButton;

/*
 * Cell custom init method
 */
- (id)initWithStyle:(UITableViewCellStyle)style 
	 reuseIdentifier:(NSString *)reuseIdentifier 
				andType:(VMCellType)cellType;

@end
