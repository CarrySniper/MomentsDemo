//
//  CLMomentsTableViewCell.m
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import "CLMomentsTableViewCell.h"

@implementation CLMomentsTableViewCell

- (void)setupWithModel:(CLMomentsModel *)model {
	[self.avatar setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"avatar"]];
	
	self.nameLabel.text = model.name;
	self.contentLabel.text = model.content;
	self.dateLabel.text = model.time;
	
	CGFloat width = kScreenWidth-16-66;
	switch (model.imgs.count) {
		case 0:
			self.heightImagesViewLayoutConstraint.constant = 0.0;
			break;
		case 1:
		case 2:{
			CGFloat height = [self.imagesCollectionView setImageUrlStrings:model.imgs viewWidth:width columnNumber:2 spacingDistance:10.0];
			self.heightImagesViewLayoutConstraint.constant = height;
		}
			break;
		default:{
			CGFloat height = [self.imagesCollectionView setImageUrlStrings:model.imgs viewWidth:width columnNumber:3 spacingDistance:10.0];
			self.heightImagesViewLayoutConstraint.constant = height;
		}
			break;
	}
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	
	self.avatar.layer.cornerRadius = 5;
	self.avatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
