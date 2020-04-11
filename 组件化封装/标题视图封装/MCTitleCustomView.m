//
//  MCTitleCustomView.m
//  Project
//
//  Created by Ning on 2019/11/18.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCTitleCustomView.h"
@interface MCTitleCustomView ()

@end
@implementation MCTitleCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleName];
        [self addSubview:self.iconeImageView];
    }
    return self;
}

- (UILabel*) titleName {
    if (nil == _titleName) {
        _titleName = [[UILabel alloc] initWithFrame:CGRectMake(self.iconeImageView.LY_right+5,0,kScreenW-30-7,21)];
        _titleName.font = [UIFont systemFontOfSize:15];
        _titleName.textColor = [UIColor colorWithHexString:@"#666666"];
        _titleName.backgroundColor = [UIColor clearColor];
    }
    return _titleName;
}
- (UIImageView*) iconeImageView {
    if (nil == _iconeImageView) {
        _iconeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (self.ly_height - 12) * 0.5, 2, 12)];
        _iconeImageView.backgroundColor = [UIColor mainColor];
    }
    return _iconeImageView;
}
@end
