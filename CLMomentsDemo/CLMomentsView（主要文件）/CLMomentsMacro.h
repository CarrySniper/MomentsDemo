//
//  CLMomentsMacro.h
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#ifndef CLMomentsMacro_h
#define CLMomentsMacro_h

/// 这里是局部宏定义，小写，避免与其他名字冲突。
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height

// 网络图片加载
#import <AFNetworking/UIKit+AFNetworking.h>
// 刷新加载
#import <MJRefresh/MJRefresh.h>
// 必要约束
#import <Masonry/Masonry.h>

#import "UIView+Extension.h"

#import "CLPictureBrowser.h"

typedef void (^CLMomentsFloatBlock)(CGFloat number);

#endif /* CLMomentsMacro_h */
