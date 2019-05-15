//
//  CLPictureBrowser.m
//  MVVMdemo
//
//  Created by CL on 2018/12/13.
//  Copyright © 2018 CL. All rights reserved.
//

#import "CLPictureBrowser.h"
#import <AFNetworking/UIKit+AFNetworking.h>

#pragma mark - CLPictureBrowser
#pragma mark interface
@interface CLPictureBrowser()<UICollectionViewDelegate, UICollectionViewDataSource>

/** 流动布局 */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/** CollectionView */
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) CGRect originalframe;
@property (nonatomic, assign) NSUInteger originalIndex;

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
		_collectionView.backgroundColor = UIColor.blackColor;
		
		NSString *name = NSStringFromClass([CLPictureBrowserCollectionViewCell class]);
		[_collectionView registerClass:[CLPictureBrowserCollectionViewCell class] forCellWithReuseIdentifier:name];
	}
	return _collectionView;

}

#pragma mark - 实例化
+ (instancetype)sharedInstance {
	return [[self alloc] init];
}

- (instancetype)init
{
	static CLPictureBrowser *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [super init];
		[instance setup];
	});
	return instance;
}

#pragma mark - 配置
- (void)setup {
	self.frame = [UIScreen mainScreen].bounds;
	self.backgroundColor = UIColor.blackColor;
	[self addSubview:self.collectionView];
	
	// 图片占位
	self.imageView = [[UIImageView alloc]init];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self addSubview:_imageView];
	
	// 图片数量
	CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
	self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10 + statusBarHeight, self.frame.size.width, 24)];
	self.numberLabel.backgroundColor = [UIColor clearColor];
	self.numberLabel.textColor = [UIColor whiteColor];
	self.numberLabel.textAlignment = NSTextAlignmentCenter;
	[self addSubview:self.numberLabel];
}

#pragma mark - 公有,外部调用方法
- (void)showImageArray:(NSArray<NSString *> *)imageArray currentIndex:(NSUInteger)currentIndex currentImageView:(UIImageView * _Nullable)currentImageView
{
	_originalIndex = currentIndex;
	_imageArray = imageArray;
	[self.collectionView reloadData];
	if (imageArray.count > 1) {
		self.numberLabel.text = [NSString stringWithFormat:@"%ld / %ld", (long)(currentIndex + 1), (unsigned long)_imageArray.count];
		self.collectionView.scrollEnabled = YES;
		// 滚动到当前图片
		[self.collectionView setContentOffset:CGPointMake(self.frame.size.width * currentIndex, 0) animated:NO];
	} else {
		self.numberLabel.text = @"";
		self.collectionView.scrollEnabled = NO;
		// 滚动到当前图片
		[self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
	}
	
	[self showViewWithImageView:currentImageView];
}

#pragma mark 显示
- (void)showViewWithImageView:(UIImageView * _Nullable)currentImageView {
	
	if (self.show == NO) {
		self.show = YES;
		if (currentImageView) {
			UIImage *image = currentImageView.image;
			// 获得根窗口
			UIWindow *window = [UIApplication sharedApplication].keyWindow;
			self.originalframe = [currentImageView convertRect:currentImageView.bounds toView:window];
			self.imageView.alpha = 1;
			self.collectionView.alpha = 0;
			
			self.imageView.frame = self.originalframe;
			self.imageView.image = image;
			[window addSubview:self];
			
			__weak __typeof(self)weakSelf = self;
			[UIView animateWithDuration:0.28 animations:^{
				weakSelf.imageView.frame = CGRectMake(0,
													  ([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2,
													  [UIScreen mainScreen].bounds.size.width,
													  image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width
													  );
			}completion:^(BOOL finished) {
				weakSelf.imageView.alpha = 0;
				weakSelf.collectionView.alpha = 1;
			}];
		}else{
			// 获得根窗口
			UIWindow *window = [UIApplication sharedApplication].keyWindow;
			[window addSubview:self];
			
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
	if (CGRectIsEmpty(self.originalframe) || self.originalIndex != index) {
		[UIView animateWithDuration:0.28 animations:^{
			self.collectionView.alpha = 0;
		} completion:^(BOOL finished) {
			[self removeFromSuperview];
		}];
	}else{
		self.collectionView.alpha = 0;
		self.imageView.alpha = 1;
		[UIView animateWithDuration:0.28 animations:^{
			self.imageView.frame = self.originalframe;
			self.imageView.alpha = 0.0;
		} completion:^(BOOL finished) {
			[self removeFromSuperview];
		}];
	}
	self.show = NO;
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
		if (self.imageArray.count > 1) {
			int index = fabs(scrollView.contentOffset.x + scrollView.frame.size.width/2)/scrollView.frame.size.width;
			_numberLabel.text = [NSString stringWithFormat:@"%d / %zd", index + 1, _imageArray.count];
		}
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
		self.imageZoom = [[CLPictureZoom alloc]initWithFrame:[UIScreen mainScreen].bounds];
		[self.contentView addSubview:self.imageZoom];
	}
	return self;
}

@end
