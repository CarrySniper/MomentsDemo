//
//  CLPictureBrowser.h
//  MVVMdemo
//
//  Created by CL on 2018/12/13.
//  Copyright © 2018 CL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLPictureZoom.h"
NS_ASSUME_NONNULL_BEGIN

@interface CLPictureBrowser : UIView

+ (instancetype)sharedInstance;

/**
 *  设置数据源，图片放大/缩小展示
 *
 *  @param imageArray url数组
 *  @param currentIndex   当前显示页
 */
- (void)showImageArray:(NSArray<NSString *> *)imageArray currentIndex:(NSUInteger)currentIndex currentImageView:(UIImageView * _Nullable)currentImageView;

@end

#pragma mark - UICollectionViewCell
@interface CLPictureBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) CLPictureZoom *imageZoom;

@end


NS_ASSUME_NONNULL_END
