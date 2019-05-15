//
//  CLMomentsInsertCollectionView.h
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMomentsMacro.h"

NS_ASSUME_NONNULL_BEGIN


@interface CLMomentsInsertCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource>

/**
 设置图片数组

 @param strings 字符串数组
 @param viewWidth UI宽度，关系到每个Item的大小
 @param columnNumber 显示列数，关系到每个Item的大小
 @param spacingDistance 行列间距
 @return View的高度，自适应使用
 */
- (CGFloat)setImageUrlStrings:(NSArray<NSString *> *)strings viewWidth:(CGFloat)viewWidth columnNumber:(NSUInteger)columnNumber spacingDistance:(CGFloat)spacingDistance;

@end

#pragma mark - UICollectionViewCell
@interface CLMomentsInsertCollectionViewCell : UICollectionViewCell

/** 图片 */
@property (nonatomic, strong) UIImageView *imageView;

@end
NS_ASSUME_NONNULL_END
