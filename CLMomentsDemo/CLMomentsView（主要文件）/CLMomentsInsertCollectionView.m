//
//  CLMomentsInsertCollectionView.m
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import "CLMomentsInsertCollectionView.h"

#pragma mark - CLMomentsInsertCollectionView
#pragma mark interface
@interface CLMomentsInsertCollectionView ()<UIGestureRecognizerDelegate>

/** 数据源 */
@property (nonatomic, strong) NSArray *dataArray;

/** 流动布局 */
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

/** CollectionView的宽 */
@property (nonatomic, assign) CGFloat viewWidth;

/** 行列间距，默认0 */
@property (nonatomic, assign) CGFloat spacingDistance;

/** 设置列数，默认1列 */
@property (nonatomic, assign) NSUInteger columnNumber;

@end

#pragma mark implementation
@implementation CLMomentsInsertCollectionView

#pragma mark - Lazy懒加载，设置自己需要的属性
#pragma mark flowLayout
- (UICollectionViewFlowLayout *)flowLayout {
	if (!_flowLayout) {
		_flowLayout = [[UICollectionViewFlowLayout alloc] init];
		_flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
		_flowLayout.minimumLineSpacing = 0;
		_flowLayout.minimumInteritemSpacing = 0;
		_flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);//上左下右
		_flowLayout.itemSize = self.frame.size;
	}
	return _flowLayout;
}

#pragma mark - 实例化
- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setCollectionViewLayout:self.flowLayout animated:YES];
		[self setup];
	}
	return self;
}

#pragma mark - 配置
- (void)setup {
	self.delegate = self;
	self.dataSource = self;
	self.scrollEnabled = NO;
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
	self.backgroundColor = UIColor.whiteColor;
	
	self.columnNumber = 1;
	self.spacingDistance = 0.0;
	
	NSString *name = NSStringFromClass([CLMomentsInsertCollectionViewCell class]);
	[self registerClass:[CLMomentsInsertCollectionViewCell class] forCellWithReuseIdentifier:name];
	
	if (@available(iOS 11.0, *)) {
		self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}
}

#pragma mark - 公有,外部调用方法
- (CGFloat)setImageUrlStrings:(NSArray<NSString *> *)strings viewWidth:(CGFloat)viewWidth columnNumber:(NSUInteger)columnNumber spacingDistance:(CGFloat)spacingDistance {
	_dataArray = strings;
	_viewWidth = viewWidth;
	
	// 先设置列数和间距
	self.columnNumber = columnNumber;
	self.spacingDistance = spacingDistance;
	
	// 后获取Item大小，才能正确赋值
	CGFloat width = [self getItemLengthOrHeight];
	self.flowLayout.itemSize = CGSizeMake(width, width);
	
	[self reloadData];
	return [self getViewHeight];
}

#pragma mark - set
- (void)setColumnNumber:(NSUInteger)columnNumber {
	if (columnNumber < 1) {
		columnNumber = 1;
	}
	_columnNumber = columnNumber;
}

- (void)setSpacingDistance:(CGFloat)spacingDistance {
	if (spacingDistance < 0) {
		spacingDistance = 0;
	}
	_spacingDistance = spacingDistance;
	
	self.flowLayout.minimumLineSpacing = spacingDistance;
	self.flowLayout.minimumInteritemSpacing = spacingDistance;
}

#pragma mark - get
- (CGFloat)getItemLengthOrHeight {
	return (self.viewWidth - self.spacingDistance * (self.columnNumber-1)) / self.columnNumber;
}

- (CGFloat)getViewHeight {
	if (self.dataArray.count == 0) {
		return 0.0;
	}
	CGFloat itemHeight = [self getItemLengthOrHeight];
	NSUInteger row = self.dataArray.count / self.columnNumber;
	long delivery = self.dataArray.count % self.columnNumber;
	if (delivery != 0) {
		row += 1;
	}
	return itemHeight * row + self.spacingDistance * (row - 1);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	CLMomentsInsertCollectionViewCell *cell = (CLMomentsInsertCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
	[[CLPictureBrowser sharedInstance] showImageArray:self.dataArray currentIndex:indexPath.item currentImageView:cell.imageView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.dataArray count];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
	
	NSString *name = NSStringFromClass([CLMomentsInsertCollectionViewCell class]);
	CLMomentsInsertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
	
	NSString *urlString = self.dataArray[indexPath.item];
	NSURL *url = [NSURL URLWithString:urlString];
	[cell.imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
	
	return cell;
}

/**
 重新事件传递方法，作用于，只点击图片时才响应，其他的位置跳过。
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	UIView *view = [super hitTest:point withEvent:event];
	if (!view.isHidden && [view isKindOfClass:[UIImageView class]]) {
		return view;
	}
	return nil;
}

@end

#pragma mark - UICollectionViewCell
#pragma mark implementation
@implementation CLMomentsInsertCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = UIColor.whiteColor;
		
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		self.imageView.contentMode = UIViewContentModeScaleToFill;
		self.imageView.userInteractionEnabled = YES;
		self.imageView.clipsToBounds = YES;
		[self.contentView addSubview:self.imageView];
		[self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.contentView);
		}];
	}
	return self;
}

@end
