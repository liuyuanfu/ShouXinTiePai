//
//  MCRunLightView.m
//  Project
//
//  Created by Ning on 2019/11/18.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCRunLightView.h"
#import "MCScrollText.h"
#define  kLeftIconeImageView  [UIImage imageNamed:@"rh_home_gonggao"]
@interface MCRunLightView ()
/** 左侧喇叭视图 */
@property(nonatomic,readwrite,strong)  UIImageView *iconeImageView;
/** 跑马灯视图 */
@property(nonatomic,readwrite,strong)  MCScrollText *scrololerView;

@property (nonatomic, strong) UILabel *leftLabel;
@end
@implementation MCRunLightView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconeImageView];
        [self addSubview:self.leftLabel];
        [self addSubview:self.scrololerView];
    }
    return self;
}

- (MCScrollText*) scrololerView {
    if (nil == _scrololerView) {
        _scrololerView = [[MCScrollText alloc] initWithFrame:CGRectMake(self.leftLabel.LY_right + 10, 0, kScreenW - self.leftLabel.LY_right - 20, 40)];
    }
    return _scrololerView;
}
- (UIImageView*) iconeImageView {
    if (nil == _iconeImageView) {
        _iconeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.ly_height - 11) * 0.5, 14, 11)];
        _iconeImageView.image = kLeftIconeImageView;
    }
    return _iconeImageView;
}

- (UILabel *)leftLabel
{
    if (_leftLabel == nil) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.iconeImageView.LY_right + 10, self.iconeImageView.ly_y, 1, 11)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self addSubview:lineView];
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.LY_right + 10, self.iconeImageView.ly_y + 2, 0, 16)];
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.text = @"消息";
        _leftLabel.font = LYFont(10);
        _leftLabel.layer.masksToBounds = YES;
        _leftLabel.layer.cornerRadius = 3;
        _leftLabel.backgroundColor = [UIColor mainColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _leftLabel;
}
@end
