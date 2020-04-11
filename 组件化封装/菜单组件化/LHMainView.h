//
//  LHMainView.h
//  Project
//
//  Created by SS001 on 2020/3/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LHMainViewDelegate<NSObject>
- (void)didSeletedMainViewWithTag:(NSUInteger)aTag;
@end

NS_ASSUME_NONNULL_BEGIN

@interface LHMainView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<LHMainViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
