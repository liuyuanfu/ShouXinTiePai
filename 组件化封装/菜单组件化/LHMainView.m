//
//  LHMainView.m
//  Project
//
//  Created by SS001 on 2020/3/19.
//  Copyright © 2020 LY. All rights reserved.
//

#import "LHMainView.h"
#import "MCDataProfessor.h"

@interface LHMainView ()
@property (nonatomic, assign) CGRect myFrame;
@end

@implementation LHMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.myFrame = frame;
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgView.image = [UIImage imageNamed:@"lx_home_top_banner"];
        [self addSubview:bgView];
        
        [self p_getMenuComponentData];
    }
    return self;
}

- (void) p_getMenuComponentData{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setNoNullObject:[MCBrandConfig sharedConfig].brand_id forKey:@"brandId"];

    NSString *path = [NSString stringWithFormat:@"%@%@%@", [MCBrandConfig sharedConfig].baseUrl, KBanben,@"/user/app/select/topup/home/Selectagreement/"];
    NSString* token  = [UserInfoManager getUserInfo].userToken;
    [LXServer postDataFromAction:path parameters:params config:@{@"authToken":token} result:^(id  _Nullable data, NSError * _Nullable error) {
        [[LXToast shared]hideLoading];
        if(error){
        } else {
            NSArray* datasource = data[@"result"][@"content"];
            self.dataArray = [[MCDataProfessor sharedConfig] getShelvesWithDatasource:datasource isMain:YES].mutableCopy;
        }
    }];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    CGFloat viewW = self.myFrame.size.width / dataArray.count;
    CGFloat viewH = self.frame.size.height;
    CGFloat viewX = 0;
    CGFloat viewY = 0;
    for (int i = 0; i < dataArray.count; i++) {
        viewX = viewW * i;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((viewW - 50) * 0.5, (viewH - 50 - 30) * 0.5, 50, 50)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:dataArray[i][@"icon"]]];
        [contentView addSubview:imgView];
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.LY_bottom, viewW, 30)];
        titleView.text = dataArray[i][@"title"];
        titleView.textColor = [UIColor whiteColor];
        titleView.font = LYFont(21);
        titleView.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(viewW - 1, imgView.ly_y, 1, titleView.LY_bottom - imgView.ly_y)];
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        [self addSubview:lineView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(viewW * i, 0, viewW, viewH);
        btn.tag = i;
        [btn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)clickMainBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSeletedMainViewWithTag:)]) {
        [self.delegate didSeletedMainViewWithTag:sender.tag];
    }
}
@end
