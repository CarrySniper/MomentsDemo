//
//  CLMomentsModel.m
//  CLMomentsDemo
//
//  Created by CL on 2019/5/14.
//  Copyright © 2019 朋友圈. All rights reserved.
//

#import "CLMomentsModel.h"

@implementation CLMomentsModel

#pragma mark - 直接添加以下代码即可自动完成序列化／反序列化
- (void)encodeWithCoder:(NSCoder *)aCoder {
	[self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
	return [self yy_modelCopy];
}
- (NSUInteger)hash {
	return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object {
	return [self yy_modelIsEqual:object];
}
- (NSString *)description {
	return [self yy_modelDescription];
}

@end
