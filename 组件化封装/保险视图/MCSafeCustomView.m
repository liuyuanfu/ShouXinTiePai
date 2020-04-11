//
//  MCSafeCustomView.m
//  Project
//
//  Created by Ning on 2019/11/18.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCSafeCustomView.h"
#define  kLeftIconeImageView  [UIImage imageNamed:@"yhb_保障"]
@implementation MCSafeCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleName];
        [self addSubview:self.iconeImageView];
        
        [self.iconeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.right.mas_equalTo(self.titleName.mas_left).mas_equalTo(-5);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(18);
        }];
    }
    return self;
}
- (void) updataWithIconeUrl:(NSString*)iconUrl{
    if (iconUrl.length == 0) {
        return;
    }
    [self.iconeImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached progress:nil completed:nil];
}
- (UILabel*) titleName {
    if (nil == _titleName) {
        _titleName = [[UILabel alloc] initWithFrame:CGRectMake((self.ly_width - 204) * 0.5,-1.5,220,21)];
        _titleName.font = [UIFont systemFontOfSize:12];
        _titleName.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleName.text = @"账户安全由中国众安保险提供风险保障";
    }
    return _titleName;
}
- (UIImageView*) iconeImageView {
    if (nil == _iconeImageView) {
        _iconeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.ly_height - 19) * 0.5, 20, 19)];
        _iconeImageView.image = kLeftIconeImageView;
    }
    return _iconeImageView;
}

@end
