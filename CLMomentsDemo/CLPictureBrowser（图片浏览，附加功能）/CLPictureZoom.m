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
		self.bouncesZoom = YES;//NO时缩放不可超出最大最小缩放范围 默认YES
		self.minimumZoomScale = 1;//缩放最小倍数 =1不能缩小
		self.maximumZoomScale = 3;//缩放最大倍数 =1不能放大
		self.backgroundColor = UIColor.clearColor;
		
		if (@available(iOS 11.0, *)) {
			self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		} else {
		}
		
		self.imageView = [[UIImageView alloc]initWithFrame:self.frame];
		self.imageView.backgroundColor = UIColor.clearColor;
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];
		
		// 单击的 TapRecognizer
		self.userInteractionEnabled = YES;
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
		singleTap.numberOfTapsRequired = 1; //点击的次数 ＝1 单击
		[self addGestureRecognizer:singleTap];//给对象添加一个手势监测；
	}
	return self;
}

#pragma mark - 点击事件
- (void)singleTap:(UITapGestureRecognizer *)recognizer {
	self.zoomScale = 1;
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.actionHandler) {
			self.actionHandler();
		}
	});
}

#pragma mark - 缩放代理
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	for (UIView *view in self.subviews){
		return view;
	}
	return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

#pragma mark - 重设Frame，让缩放的时候居中
- (void)layoutSubviews {
	[super layoutSubviews];
	
	// Center the image as it becomes smaller than the size of the screen
	CGSize boundsSize = self.bounds.size;
	CGRect frameToCenter = _imageView.frame;
	
	// Horizontally
	if (frameToCenter.size.width < boundsSize.width) {
		frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
	} else {
		frameToCenter.origin.x = 0;
	}
	
	// Vertically
	if (frameToCenter.size.height < boundsSize.height) {
		frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
	} else {
		frameToCenter.origin.y = 0;
	}
	
	// Center
	if (!CGRectEqualToRect(_imageView.frame, frameToCenter)) {
		_imageView.frame = frameToCenter;
	}
}

@end
