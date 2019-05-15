//
//  CLPictureZoom.m
//  MVVMdemo
//
//  Created by CL on 2019/5/15.
//  Copyright © 2019 CL. All rights reserved.
//

#import "CLPictureZoom.h"

@implementation CLPictureZoom

// 指定大小，直接显示状态下放大缩小
- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.scrollEnabled = YES;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.delegate = self;    //实现Scrollview的代理
		self.bounces = NO;
		self.bouncesZoom = NO;//NO时缩放不可超出最大最小缩放范围 默认YES
		self.minimumZoomScale = 1;//缩放最小倍数 =1不能缩小
		self.maximumZoomScale = 5;//缩放最大倍数 =1不能放大
		
		self.imageView = [[UIImageView alloc]initWithFrame:self.frame];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		self.userInteractionEnabled = YES;
		[self addSubview:self.imageView];
		
		// 单击的 TapRecognizer
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
		singleTap.numberOfTapsRequired = 1; //点击的次数 ＝1 单击
		[self addGestureRecognizer:singleTap];//给对象添加一个手势监测；
	}
	return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	for (UIView *view in self.subviews){
		return view;
	}
	return nil;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.actionHandler) {
			self.actionHandler();
		}
	});
}

@end
