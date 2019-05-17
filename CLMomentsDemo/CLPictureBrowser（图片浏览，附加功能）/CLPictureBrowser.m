//
//  CLPictureBrowser.m
//  MVVMdemo
//
//  Created by CL on 2018/12/13.
//  Copyright © 2018 CL. All rights reserved.
//

#import "CLPictureBrowser.h"
#import <AFNetworking/UIKit+AFNetworking.h>

/// 这里是局部宏定义，小写，避免与其他。
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height
#define kAnimateDuration 	0.28

#pragma mark - CLPictureBrowser
#pragma mark interface
@interface CLPictureBrowser()<UICollectionViewDelegate, UICollectionViewDataSource>

/** 流动布局 */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** CollectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

/** 分页控制 */
@property (nonatomic, strong) UIPageControl *pageControl;

/// 占位
@property (nonatomic, strong) UIImageView *imageView;

/// 用于记录的属性
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGRect originalframe;
@property (nonatomic, assign) NSUInteger originalIndex;

/** 状态栏样式 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@end

@implementation CLPictureBrowser

#pragma mark - Lazy懒加载，设置自己需要的属性
#pragma mark flowLayout
- (UICollectionViewFlowLayout *)flowLayout {
	if (!_flowLayout) {
		_flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		_flowLayout.minimumLineSpacing = 0;
		_flowLayout.minimumInteritemSpacing = 0;
		_flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);//上左下右
		_flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
	}
	return _flowLayout;
}

- (UICollectionView *)collectionView {
	if (!_collectionView) {
		_collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
		
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.pagingEnabled = YES;
		_collectionView.showsHorizontalScrollIndicator = NO;
		_collectionView.showsVerticalScrollIndicator = NO;
		_collectionView.backgroundColor = UIColor.clearColor;
		
		if (@available(iOS 11.0, *)) {
			_collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		} else {
		}
		
		NSString *name = NSStringFromClass([CLPictureBrowserCollectionViewCell class]);
		[_collectionView registerClass:[CLPictureBrowserCollectionViewCell class] forCellWithReuseIdentifier:name];
	}
	return _collectionView;

}

- (UIPageControl *)pageControl {
	if (!_pageControl) {
		CGFloat bottom = 30.0;
		if (@available(iOS 11.0, *)) {
			UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
			bottom = window.safeAreaInsets.bottom + 30.0;
		}
		_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - bottom, kScreenWidth, 30.0)];
		_pageControl.pageIndicatorTintColor = UIColor.lightGrayColor;
		_pageControl.currentPageIndicatorTintColor = UIColor.whiteColor;
	}
	return _pageControl;
}

#pragma mark - 实例化
+ (instancetype)sharedInstance {
	return [[self alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect
{
	static CLPictureBrowser *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [super initWithEffect:effect];
		[instance setup];
	});
	return instance;
}

#pragma mark - 配置
- (void)setup {
	self.frame = [UIScreen mainScreen].bounds;
//	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	[self.contentView addSubview:self.collectionView];
	
	// 图片占位
	self.imageView = [[UIImageView alloc]init];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.contentView addSubview:_imageView];
	
	// 分页
	[self.contentView addSubview:self.pageControl];
}

#pragma mark - 公有,外部调用方法
- (void)showImageArray:(NSArray<NSString *> * _Nullable)imageArray currentIndex:(NSUInteger)currentIndex currentImageView:(UIImageView * _Nullable)currentImageView
{
	_originalIndex = currentIndex;
	_imageArray = imageArray;
	[self.collectionView reloadData];
	if (imageArray.count > 1) {
		self.pageControl.numberOfPages = imageArray.count;
		self.pageControl.currentPage = currentIndex;
		// 滚动到当前图片
		self.collectionView.scrollEnabled = YES;
		[self.collectionView setContentOffset:CGPointMake(self.frame.size.width * currentIndex, 0) animated:NO];
	} else {
		self.pageControl.numberOfPages = 0;
		// 滚动到当前图片
		self.collectionView.scrollEnabled = NO;
		[self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
	}
	
	[self showViewWithImageView:currentImageView];
}

#pragma mark 显示
- (void)showViewWithImageView:(UIImageView * _Nullable)currentImageView {
	// 记录状态样式，用于恢复
	self.statusBarStyle = [UIApplication sharedApplication].statusBarStyle;
	// 然后设为亮色样式
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
	
	if (self.show == NO) {
		self.show = YES;
		// 获得根窗口，并添加UI
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		[window addSubview:self];
		
		if (currentImageView) {
			// ImageView全屏后的高度
			UIImage *image = currentImageView.image;
			CGFloat imageHeight = kScreenWidth * image.size.height/image.size.width;
			
			self.originalframe = [currentImageView convertRect:currentImageView.bounds toView:window];
			self.imageView.frame = self.originalframe;
			self.imageView.image = image;
			self.imageView.alpha = 1;
			self.collectionView.alpha = 0;
			// 加上动画
			[UIView animateWithDuration:kAnimateDuration animations:^{
				self.imageView.frame = CGRectMake(0, (kScreenHeight - imageHeight) / 2.0, kScreenWidth, imageHeight);
			} completion:^(BOOL finished) {
				self.imageView.alpha = 0;
				self.collectionView.alpha = 1;
			}];
		} else {
			// 不用动画
			self.originalframe = CGRectZero;
			self.imageView.alpha = 0;
			self.collectionView.alpha = 1;
		}
	} else {
		self.show = YES;
	}
}

#pragma mark 隐藏
- (void)hideWithIndex:(NSUInteger)index {
	// 区别对待
	if (CGRectIsEmpty(self.originalframe) || self.originalIndex != index) {
	} else {
		self.collectionView.alpha = 0;
		self.imageView.alpha = 1;
	}
	[UIView animateWithDuration:kAnimateDuration animations:^{
		if (CGRectIsEmpty(self.originalframe) || self.originalIndex != index) {
			self.collectionView.alpha = 0;
		} else {
			self.imageView.frame = self.originalframe;
			self.imageView.alpha = 0.0;
		}
	} completion:^(BOOL finished) {
		self.show = NO;
		[self removeFromSuperview];
		[UIApplication sharedApplication].statusBarStyle = self.statusBarStyle;
	}];
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [_imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

	NSString *name = NSStringFromClass([CLPictureBrowserCollectionViewCell class]);
	CLPictureBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
	
	NSString *urlString = _imageArray[indexPath.item];
	[cell.imageZoom.imageView setImageWithURL:[NSURL URLWithString:urlString]];
	
	__weak __typeof(self)weakSelf = self;
	[cell.imageZoom setActionHandler:^(void){
		[weakSelf hideWithIndex:indexPath.item];
	}];
	return cell;
}

#pragma mark 图片恢复默认大小
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
	CLPictureBrowserCollectionViewCell *myCell = (CLPictureBrowserCollectionViewCell *)cell;
	myCell.imageZoom.zoomScale = 1;
}

#pragma mark - UIScrollView
#pragma mark 改变当前页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([scrollView isEqual:self.collectionView]) {
		int index = fabs(scrollView.contentOffset.x + scrollView.frame.size.width/2)/scrollView.frame.size.width;
		self.pageControl.currentPage = index;
	}
}

@end

#pragma mark - UICollectionViewCell
#pragma mark implementation
@implementation CLPictureBrowserCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
		self.backgroundColor = UIColor.clearColor;
		self.contentView.backgroundColor = UIColor.clearColor;
		
		self.imageZoom = [[CLPictureZoom alloc]initWithFrame:[UIScreen mainScreen].bounds];
		[self.contentView addSubview:self.imageZoom];
	}
	return self;
}

@end
