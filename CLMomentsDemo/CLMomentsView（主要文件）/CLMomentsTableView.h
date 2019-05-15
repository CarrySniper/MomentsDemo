//
//  CLMomentsTableView.h
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLMomentsMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface CLMomentsTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

NS_ASSUME_NONNULL_END
