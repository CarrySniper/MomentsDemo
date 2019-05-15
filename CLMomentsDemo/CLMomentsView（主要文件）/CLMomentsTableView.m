//
//  CLMomentsTableView.m
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import "CLMomentsTableView.h"
#import "CLMomentsTableViewCell.h"

#warning 这是本地数据，要替换
#import "CLDataSingleton.h"

@implementation CLMomentsTableView

#pragma mark - 实例化
#pragma mark 纯代码调用
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self setup];
	}
	return self;
}

#pragma mark Xib调用
- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}

#pragma mark - 配置
- (void)setup {
	self.delegate = self;
	self.dataSource = self;
	
	/// 自适应高度
	self.estimatedRowHeight = 242;
	self.rowHeight = UITableViewAutomaticDimension;
	
	self.backgroundColor = UIColor.whiteColor;
	self.separatorColor = UIColor.redColor;
	//self.separatorStyle = UITableViewCellEditingStyleNone;     //让tableview不显示分割线
	self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
	
	/// 头部尾部
	self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
	self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.001)];
	
	NSString *name = NSStringFromClass([CLMomentsTableViewCell class]);
	[self registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];

	// iOS11，内边距调整，看需求要不要设置，特别是导航栏半透明的
	if (@available(iOS 11.0, *)) {
		self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}

	/// 加载数据
	self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[self loadData];
	}];
	self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		[self loadMoreData];
	}];
}

#pragma mark - 数据加载，个人使用ViewModel，这里不实现，不是重点。需要的另外找我
#pragma mark 加载刷新第一页数据
- (void)loadData {
#warning 这是本地数据，要替换
	__weak typeof(self)weakSelf = self;
	
	int64_t delayInSeconds = 1.0; // 延迟的时间
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		// YYModel转换，看个人喜欢
		NSArray *loadData = [NSArray yy_modelArrayWithClass:[CLMomentsModel class] json:[CLDataSingleton sharedInstance].dataArray];
		weakSelf.dataArray = [NSMutableArray arrayWithArray:loadData];
		
		[weakSelf reloadData];
		[weakSelf.mj_header endRefreshing];
		[weakSelf.mj_footer resetNoMoreData];
	});
}

#pragma mark 加载更多数据
- (void)loadMoreData {
	
#warning 这是本地数据，要替换
	__weak typeof(self)weakSelf = self;
	
	int64_t delayInSeconds = 1.0; // 延迟的时间
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (self.dataArray == nil) {
			self.dataArray = [NSMutableArray array];
		}
		// YYModel转换，看个人喜欢
		NSArray *loadData = [NSArray yy_modelArrayWithClass:[CLMomentsModel class] json:[CLDataSingleton sharedInstance].dataArray];
		[weakSelf.dataArray addObjectsFromArray:loadData];;
		
		[weakSelf reloadData];
		[weakSelf.mj_footer endRefreshing];
	});
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSLog(@"点击了某条数据 section = %zd", indexPath.section);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.dataArray count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	NSString *name = NSStringFromClass([CLMomentsTableViewCell class]);
	CLMomentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
	
	CLMomentsModel *model = self.dataArray[indexPath.section];
	[cell setupWithModel:model];
	return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]init];
	view.backgroundColor = self.backgroundColor;
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.001;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]init];
	view.backgroundColor = self.backgroundColor;
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 8.0;
}

@end
