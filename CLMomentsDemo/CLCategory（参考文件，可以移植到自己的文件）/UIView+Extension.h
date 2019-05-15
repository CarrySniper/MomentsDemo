//
//  UIView+Extension.h
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

+ (instancetype)viewFromXib;

- (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
