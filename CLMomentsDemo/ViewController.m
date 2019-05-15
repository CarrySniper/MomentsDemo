//
//  ViewController.m
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

/// 1、引入头文件
#import "CLMomentsTableView.h"

@interface ViewController ()

/** 2、声明属性 */
@property (nonatomic, strong) CLMomentsTableView *tableView;

@end

@implementation ViewController

#pragma mark - 3、Lazy懒加载，设置自己需要的属性
- (CLMomentsTableView *)tableView {
	if (!_tableView) {
		_tableView = [[CLMomentsTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		_tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
	}
	return _tableView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.navigationController.navigationBar.translucent = NO;
	
	/// 4、加载显示
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// 马上进入刷新状态
	[self.tableView.mj_header beginRefreshing];
}

@end
