//
//  UIView+Extension.m
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

#pragma mark - 获取Xib的view
+ (instancetype)viewFromXib {
	return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

#pragma mark - 顶级控制器，用于跳转页面等操作
- (UIViewController *)topViewController {
	UIView *next = self;
	while ((next = [next superview])) {
		UIResponder *nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController *)nextResponder;
		}
	}
	return nil;
}
@end
