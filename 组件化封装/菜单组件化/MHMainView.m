//
//  MHMainView.m
//  Project
//
//  Created by SS001 on 2020/4/2.
//  Copyright © 2020 LY. All rights reserved.
//

#import "MHMainView.h"
#import "MCDataProfessor.h"

@interface MHMainView ()
@property (nonatomic, assign) CGRect myFrame;
@end

@implementation MHMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.myFrame = frame;
        
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
        NSDictionary *dict = dataArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(viewW * i, 0, viewW, viewH);
        btn.tag = i;
        [btn sd_setImageWithURL:[NSURL URLWithString:dict[@"icon"]] forState:UIControlStateNormal];
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
