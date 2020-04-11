//
//  MCMenuItemView.m
//  Project
//
//  Created by Ning on 2019/11/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCMenuItemView.h"

@implementation MCMenuItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self p_setUI];
        [self addTapGestureRecognizer];
    }
    return self;
}

- (void) p_setUI{
//     [self addSubview:self.iconeBgView];
    [self addSubview:self.iconeImageView];
   
    [self addSubview:self.titleLabel];
}

- (void) refreshUI{
    self.iconeImageView.frame = CGRectMake((self.frame.size.width-35)/2,(self.frame.size.height-25-35)/2, 35, 35);
    self.titleLabel.frame = CGRectMake(0,self.frame.size.height-40,self.frame.size.width,25);
}

- (void) addTapGestureRecognizer {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSeletedMenuItem:)];
    [self addGestureRecognizer:tap];
}

- (void) resetIconeWidth:(CGFloat)width height:(CGFloat)height{
    if (!width) {
        return;
    }
    if (!height) {
        return;
    }
    self.iconeImageView.frame = CGRectMake((self.frame.size.width-width)/2,(self.frame.size.height-27-width)/2, width, height);
    self.titleLabel.frame = CGRectMake(0,self.frame.size.height-26,self.frame.size.width,25);
}

- (void) updataBackgroundColor:(UIColor*)backgroundColor
                    titlesFont:(UIFont*)fontSize
                    iconeWidth:(CGFloat)iconeWidth
                   iconeHeight:(CGFloat)iconeHeight{
    self.backgroundColor = backgroundColor;
    self.titleLabel.font = fontSize;
    [self resetIconeWidth:iconeWidth height:iconeHeight];
}
- (void) updataWithDataSource:(NSDictionary*)datasource{
    NSString* imageUrl = datasource[@"icon"];
    UIImageView* imageView = [[UIImageView alloc] init];
    kWeakObj(self);
    [self.iconeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSString* color = datasource[@"color"];
        if (![NSString stringIsEmptyWithString:color]) {
            if ([color hasPrefix:@"#"]) {
                self.iconeImageView.image = [image imageWithColor:[UIColor colorWithHexString:color]];
            }else{
                NSString* colorString = [NSString stringWithFormat:@"#%@",color];
                self.iconeImageView.image = [image imageWithColor:[UIColor colorWithHexString:color]];
            }
        }
    }];

    self.titleLabel.text = datasource[@"title"];
}

- (void) didSeletedMenuItem:(UITapGestureRecognizer*) tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeletedMenuItemWithTag:)]) {
        [self.delegate didSeletedMenuItemWithTag:tap.view.tag];
    }
}

- (UIImageView*) iconeImageView {
    if (nil == _iconeImageView) {
        _iconeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-39)/2,(self.frame.size.height-16.5-39 - 8)/2, 39, 39)];
        _iconeImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconeImageView;
}

- (UILabel*) titleLabel {
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.iconeImageView.LY_bottom + 8,self.frame.size.width,16.5)];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
