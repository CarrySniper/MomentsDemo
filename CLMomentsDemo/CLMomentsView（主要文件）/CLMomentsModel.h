//
//  CLMomentsModel.h
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLMomentsModel : NSObject<NSCoding, NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSArray *commentList;
@property (nonatomic, copy) NSArray *imgs;


@end

NS_ASSUME_NONNULL_END
