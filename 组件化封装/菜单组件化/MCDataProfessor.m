//
//  MCDataProfessor.m
//  Project
//
//  Created by Ning on 2019/11/14.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCDataProfessor.h"

@implementation MCDataProfessor
+ (instancetype)sharedConfig {
    static dispatch_once_t oneceToken;
    static MCDataProfessor *_singleConfig = nil;
    dispatch_once(&oneceToken, ^{
        if (_singleConfig == nil) {
            _singleConfig = [[self alloc] init];
        }
    });
    return _singleConfig;
}

/// 过滤掉 未上架的
/// @param datasource 数据源
- (NSArray*)getShelvesWithDatasource:(NSArray*)datasource isMain:(BOOL)isMain{
    NSMutableArray*shelvesDatasource = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < datasource.count; i++) {
        NSDictionary* dict = datasource[i];
        if ([[NSString stringWithFormat:@"%@",dict[@"status"]] isEqualToString:@"1"]) {
            if (isMain) {
                if ([[NSString stringWithFormat:@"%@",dict[@"positionType"]] isEqualToString:@"0"]) {
                    [shelvesDatasource addObject:dict];
                }
            }else{
                if ([[NSString stringWithFormat:@"%@",dict[@"positionType"]] isEqualToString:@"1"]) {
                    [shelvesDatasource addObject:dict];
                }
            }
        }
    }
    return shelvesDatasource;
}

/// 获取最大行
/// @param datasource 数据源
- (NSInteger)getMaxRow:(NSArray*)datasource{
    NSInteger max_number = 0;
    for (NSInteger i = 0; i < datasource.count; i++) {
        NSDictionary* dict = datasource[i];
        NSInteger row = [[NSString stringWithFormat:@"%@",dict[@"row"]] integerValue];
        //取最大值和最大值的对应下标
        NSInteger a = row;
        max_number = a>max_number?a:max_number;
    }
    return max_number;
}

/// 获取最大列
/// @param datasource 数据源
- (NSInteger)getMaxColumnn:(NSArray*)datasource{
    NSInteger max_number = 1;
    for (NSInteger i = 0; i < datasource.count; i++) {
        NSDictionary* dict = datasource[i];
        NSInteger columnn = [[NSString stringWithFormat:@"%@",dict[@"columnn"]] integerValue];
        //取最大值和最大值的对应下标
        NSInteger a = columnn;
        max_number = a>max_number?a:max_number;
    }
    return max_number;
}
@end
