//
//  MCNewsView.h
//  Project
//
//  Created by Nitch Zheng on 2019/12/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef  void (^MCNewsViewHeight)(CGFloat height);
@interface MCNewsView : UIView
/** 视图总高度 */
@property(nonatomic,readwrite,copy)  MCNewsViewHeight height;
@end

NS_ASSUME_NONNULL_END
