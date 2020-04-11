//
//  MCDataProfessor.h
//  Project
//
//  Created by Ning on 2019/11/14.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDataProfessor : NSObject
/// 单例
+ (instancetype)sharedConfig;
/// 数据过滤
/// @param datasource 数据源
/// @param isMain 是否是主功能
- (NSArray*)getShelvesWithDatasource:(NSArray*)datasource isMain:(BOOL)isMain;

/// 获取最大行
/// @param datasource 数据源
- (NSInteger)getMaxRow:(NSArray*)datasource;

/// 获取最大列
/// @param datasource 数据源
- (NSInteger)getMaxColumnn:(NSArray*)datasource;
@end

NS_ASSUME_NONNULL_END
