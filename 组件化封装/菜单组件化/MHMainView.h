//
//  MHMainView.h
//  Project
//
//  Created by SS001 on 2020/4/2.
//  Copyright © 2020 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol  MHMainViewDelegate<NSObject>
- (void)didSeletedMainViewWithTag:(NSUInteger)aTag;
@end
@interface MHMainView : UIView
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) id<MHMainViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
