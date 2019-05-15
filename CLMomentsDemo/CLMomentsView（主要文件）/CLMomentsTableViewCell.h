//
//  CLMomentsTableViewCell.h
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMomentsModel.h"
#import "CLMomentsInsertCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLMomentsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImagesViewLayoutConstraint;

/**
 朋友圈，顶部用户信息栏
 */
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 朋友圈，中间图文
 */
@property (weak, nonatomic) IBOutlet UIView *textImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet CLMomentsInsertCollectionView *imagesCollectionView;

/**
 朋友圈，底部点赞、评论栏
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


- (void)setupWithModel:(CLMomentsModel *)model;

@end

NS_ASSUME_NONNULL_END
