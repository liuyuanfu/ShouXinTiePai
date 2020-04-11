//
//  MCNewsCell.h
//  Project
//
//  Created by Nitch Zheng on 2019/12/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HomeModel;
@interface MCNewsCell : UITableViewCell
/**
 *  更新数据.
 */
- (void) updataWithModel:(HomeModel*)newsModel;

@end

NS_ASSUME_NONNULL_END
