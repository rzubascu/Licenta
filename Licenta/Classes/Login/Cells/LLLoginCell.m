//
//  LLLoginCell.m
//  VetMicrochip
//
//  Created by zubby on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LLLoginCell.h"

static const CGRect kSubmitButtonFrame		= {8.0f, 0.0f, 293.0f, 44.0f};

#pragma mark - Public

@implementation LLLoginCell

@synthesize submitButton = _submitButton;

- (id)initWithStyle:(UITableViewCellStyle)style 
	 reuseIdentifier:(NSString *)reuseIdentifier 
				andType:(VMCellType)cellType {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization code
		self.clipsToBounds = NO;
		self.textLabel.textAlignment = UITextAlignmentCenter;

		switch (cellType) {
			case kUsernameCell: {
//				UIImageView *textFieldImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microapp_input_field"]];
//				textFieldImgView.center = CGPointMake(self.center.x - 5.0f, textFieldImgView.center.y);
////				[self addSubview:textFieldImgView];
//				
//				self.backgroundColor = [UIColor redColor];
				break;

			}	
			
			case kPasswordCell: {
				// Add code here...
//				UIImageView *textFieldImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"microapp_input_field"]];
//				textFieldImgView.center = CGPointMake(self.center.x - 5.0f, textFieldImgView.center.y);
////				[self addSubview:textFieldImgView];
//				
//				self.backgroundColor = [UIColor redColor];
				break;
			}
			case kSubmitCell: {				
//				_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//				_submitButton.frame = CGRectMake(30.0f, 0.0f, 260.0f, 60.0f);
//				[_submitButton setImage:[UIImage imageNamed:@"microapp_submit_btn"] forState:UIControlStateNormal];
//
//				[self addSubview:_submitButton];
				break;
			}
			default:
				break;
		}
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];

	// Configure the view for the selected state
}

@end
