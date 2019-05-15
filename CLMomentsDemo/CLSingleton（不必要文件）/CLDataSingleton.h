//
//  CLDataSingleton.h
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLDataSingleton : NSObject

/**
 单例模式
 */
+ (instancetype)sharedInstance;

/** 数据，写死 */
@property (nonatomic, strong) NSArray *dataArray;

@end

NS_ASSUME_NONNULL_END
