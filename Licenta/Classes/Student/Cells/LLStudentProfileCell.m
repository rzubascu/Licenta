//
//  LLStudentProfileCell.m
//  Licenta
//
//  Created by zubby on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLStudentProfileCell.h"

static const CGRect kProfileImageViewFrame	= {18.0f, 5.0f, 70.0f, 90.0f};
static const CGRect kNameLabelFrame				= {100.0f, 5.0f, 200.0f, 40.0f};
static const CGRect kEmailLabelFrame			= {100.0f, 45.0f, 200.0f, 25.0f};
static const CGRect kPhoneNumberLabelFrame	= {100.0f, 70.0f, 200.0f, 25.0f};

#pragma mark - Private

@interface LLStudentProfileCell () {
	UIImageView					*_profileImageView;
	UILabel						*_studentNameLabel;
	UILabel						*_studentEmailLabel;
	UILabel						*_studentPhoneLabel;
}

@end

#pragma mark - Public

@implementation LLStudentProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style 
	 reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization code

		// Profile image
		_profileImageView = [[UIImageView alloc] initWithFrame:kProfileImageViewFrame];
		_profileImageView.backgroundColor = [UIColor magentaColor];
		
		// Student name
		_studentNameLabel = [[UILabel alloc] initWithFrame:kNameLabelFrame];
		_studentNameLabel.text = @"Not Available";
		_studentNameLabel.font = [UIFont boldSystemFontOfSize:24.0f];
		
		// Student email
		_studentEmailLabel = [[UILabel alloc] initWithFrame:kEmailLabelFrame];
		_studentEmailLabel.text = @"Not Available";
		UITapGestureRecognizer *emailTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendEmail)];
		[_studentEmailLabel addGestureRecognizer:emailTapGesture];

		// Student phone number
		_studentPhoneLabel = [[UILabel alloc] initWithFrame:kPhoneNumberLabelFrame];
		_studentPhoneLabel.text = @"Not Available";
		UITapGestureRecognizer *phoneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phone)];
		[_studentPhoneLabel addGestureRecognizer:phoneTapGesture];

		[self addSubview:_profileImageView];
		[self addSubview:_studentNameLabel];
		[self addSubview:_studentEmailLabel];
		[self addSubview:_studentPhoneLabel];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

/*
 * Update cell with name, email and phone number
 */
- (void)updateCellWithName:(NSString *)nameString 
				  emailAddress:(NSString *)emailAddress
				andPhoneNumber:(NSString *)phoneNumber {
	_studentNameLabel.text = nameString;
	_studentEmailLabel.text = emailAddress;
	_studentPhoneLabel.text = phoneNumber;
}

@end
