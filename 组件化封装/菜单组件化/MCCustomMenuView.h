//
//  MCCustomMenuView.h
//  Project
//
//  Created by Ning on 2019/11/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MCCustomMenuViewDataType){
    MCCustomMenuViewTypeMain,//主功能区
    MCCustomMenuViewTypeVice,//副功能区
};

typedef  void (^MCMenuViewHeight)(CGFloat menuViewHeight);
typedef  void (^DidSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary)(NSInteger seletedItemIndex,NSDictionary* _Nullable seletedDictionary);

NS_ASSUME_NONNULL_BEGIN

@interface MCCustomMenuView : UIView
/** 背景颜色 */
@property(nonatomic,readwrite,strong)  UIColor *itemColor;
/** 字体大小 */
@property(nonatomic,readwrite,strong)  UIFont  *itemFont;
/** 图片宽度*/
@property(nonatomic,readwrite,assign)  CGFloat iconeWidth;
/** 图片高度*/
@property(nonatomic,readwrite,assign)  CGFloat iconeHeight;
/** 视图总高度 */
@property(nonatomic,readwrite,copy)  MCMenuViewHeight menuViewHeight;
@property(nonatomic,readwrite,copy)  DidSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary;

/// 初始化
/// @param frame 位置
/// @param dataType 功能区类型
- (instancetype)initWithFrame:(CGRect)frame
                     dataType:(MCCustomMenuViewDataType)dataType;

/// 自定义视图的位置
/// @param lineSpacing 行间距
/// @param rowSpacing 列间距
/// @param menuWidth 单个视图宽度
/// @param menuHeight 单个视图高度
- (void) resetLineSpacing:(CGFloat)lineSpacing
               rowSpacing:(CGFloat)rowSpacing
                  menuWidth:(CGFloat)menuWidth
                  menuHeight:(CGFloat)menuHeight;

- (void) refreshData;

@end

NS_ASSUME_NONNULL_END
