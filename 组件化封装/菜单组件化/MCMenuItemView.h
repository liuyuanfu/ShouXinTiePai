//
//  MCMenuItemView.h
//  Project
//
//  Created by Ning on 2019/11/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  MCMenuItemViewDelegate<NSObject>
- (void) didSeletedMenuItemWithTag:(NSUInteger)aTag;
@end

@interface MCMenuItemView : UIView
/** 图片 */
@property(nonatomic,readwrite,strong) UIImageView *iconeImageView;

/** 图片背景 */
@property(nonatomic,readwrite,strong) UIImageView *iconeBgView;

/** 标题 */
@property(nonatomic,readwrite,strong) UILabel     *titleLabel;
/** 代理 */
@property (nonatomic, weak) id<MCMenuItemViewDelegate> delegate;

- (void) refreshUI;
- (void) resetIconeWidth:(CGFloat)width height:(CGFloat)height;
/*属性更新*/
- (void) updataBackgroundColor:(UIColor*)backgroundColor
                    titlesFont:(UIFont*)fontSize
                    iconeWidth:(CGFloat)iconeWidth
                   iconeHeight:(CGFloat)iconeHeight;

- (void) updataWithDataSource:(NSDictionary*)datasource;

@end

NS_ASSUME_NONNULL_END
