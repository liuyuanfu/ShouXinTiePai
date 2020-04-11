//
//  MCMenuManager.h
//  Project
//
//  Created by Ning on 2019/11/14.
//  Copyright © 2019 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCMenuManager : NSObject
+ (instancetype)sharedConfig;

/// 模块跳转
/// @param data 数据
- (void) pushModuleWithData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
