//
//  CLPictureZoom.h
//  MVVMdemo
//
//  Created by CL on 2019/5/15.
//  Copyright © 2019 CL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CLPictureZoomHandler)(void);

@interface CLPictureZoom : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

/** 操作回调 */
@property (nonatomic, copy) CLPictureZoomHandler actionHandler;

@end

NS_ASSUME_NONNULL_END
