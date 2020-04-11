//
//  MCSafeCustomView.h
//  Project
//
//  Created by Ning on 2019/11/18.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCSafeCustomView : UIView
/** 标题 */
@property(nonatomic,readwrite,strong)  UILabel *titleName;
/** 图标 */
@property(nonatomic,readwrite,strong)  UIImageView *iconeImageView;
- (void) updataWithIconeUrl:(NSString*)iconUrl;
@end

NS_ASSUME_NONNULL_END
