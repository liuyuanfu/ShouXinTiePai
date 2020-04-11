//
//  MCMenuManager.m
//  Project
//
//  Created by Ning on 2019/11/14.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCMenuManager.h"


#import "NBNPCollectController.h"

#import "ZCInputActiveCodeView.h"
#import "ZCActiveCodeViewController.h"
#import "CommunityController.h"
#import "CommonShareArticalVC.h"
#import "Common_SettingVC.h"
#import "MineWebViewController.h"
#import "CommonEncourageVC.h"

@implementation MCMenuManager
+ (instancetype)sharedConfig {
    static dispatch_once_t oneceToken;
    static MCMenuManager *_singleConfig = nil;
    dispatch_once(&oneceToken, ^{
        if (_singleConfig == nil) {
            _singleConfig = [[self alloc] init];
        }
    });
    return _singleConfig;
}
- (void) pushModuleWithData:(NSDictionary*)data{
    BOOL realName = [data[@"realname"] boolValue];
    if (realName) {
        [MCVerifyStore verifyRealName:^(NSDictionary * _Nonnull info) {
            [self verfyGrade:data];
        }];
    } else {
        [self verfyGrade:data];
    }
}

- (void)verfyGrade:(NSDictionary *)dict {
    NSInteger grade = [dict[@"grade"] integerValue];
    [MCModelStore getUserInfo:^(MCUserInfo * _Nonnull info) {
        if (info.grade.integerValue < grade) {
            [MCGradeName getGradeNameWithGrade:[NSString stringWithFormat:@"%ld", (long)grade] callBack:^(NSString * _Nonnull gradeName) {
                [MCAlertStore showWithTittle:@"温馨提示" message:[NSString stringWithFormat:@"只有《%@》级别及以上才能查看此内容,是否前往充值升级？",gradeName] buttonTitles:@[@"暂不需要",@"前往升级"] sureBlock:^{
                    [MCPagingStore paging_升级];
                }];
            }];
        } else {
            [self paging:dict];
        }
    }];
}
- (void)paging:(NSDictionary *)dict {
    
    
    NSString* sortType = dict[@"sortType"];
    NSString* title = dict[@"title"];
    NSString* isAddParam = dict[@"param"];
    NSString* sortt = [NSString stringWithFormat:@"%@",dict[@"sortt"]];
    NSString* sorttValue = [NSString stringWithFormat:@"%@",dict[@"sortValue"]];
    if (![sortType isEqualToString:@"0"]) {
        //web
        if ([isAddParam isEqualToString:@"1"]) {
            [self pushWebWithUrl:[self appendOtherParams:sorttValue] title:title];
        }else{
            [self pushWebWithUrl:sorttValue title:title];
        }
    }else{
        if ([sortt containsString:@"NP收款"]) {
            [MCPagingStore paging_np收款];
            return;
        }
        if ([sortt isEqualToString:@"幸运转盘"]) {
            [[MCControllerStore getCurrentViewController].navigationController pushViewController:[CommonEncourageVC new] animated:YES];
            return;
        }
        //0原生
        if ([sortt containsString:@"收款"]) {
            [MCPagingStore paging_收款];
            return;
        }
        if ([sortt containsString:@"升级"]) {
            [MCPagingStore paging_升级];
            return;
        }
        
        if ([sortt containsString:@"我要激活"]) {
            ZCInputActiveCodeView *view = [ZCInputActiveCodeView newFromNib];
            
            [view show];
            return;
        }
        if ([sortt containsString:@"账户余额"]) {
            [MCPagingStore paging_余额];
            return;
        }
        if ([sortt containsString:@"我的激活码"]) {
            [MCPagingStore pagingController:[ZCActiveCodeViewController new]];
            return;
        }
        if ([sortt containsString:@"卡片管理"]) {
            [MCPagingStore paging_银行卡管理];
            return;
        }
        if ([sortt containsString:@"我的收益"]) {
            [MCPagingStore paging_收益];
            return;
        }
        if ([sortt containsString:@"我的费率"]) {
            [MCPagingStore paging_我的费率];
            return;
        }
        if ([sortt containsString:@"我的团队"]) {
            [MCPagingStore paging_团队];
            return;
        }
        if ([sortt containsString:@"交易明细"]) {
            [MCPagingStore paging_账单];
            return;
        }
        if ([sortt containsString:@"收益排行"]) {
            [MCPagingStore paging_收益排行];
            return;
        }
        if ([sortt containsString:@"信用社区"]) {
            [MCPagingStore pagingController:[CommunityController new]];
            return;
        }
        if ([sortt containsString:@"操作手册"]) {
            [MCPagingStore paging_操作手册];
            return;
        }
        if ([sortt containsString:@"信用秘籍"]) {
            [MCPagingStore paging_分类列表:@"信用秘籍"];
            return;
        }
        if ([sortt containsString:@"视频教程"]) {
            [MCPagingStore paging_视频教程];
            return;
        }
        if ([sortt containsString:@"朋友圈"]) {
            [MCPagingStore pagingController:[CommonShareArticalVC new]];
            return;
        }
        if ([sortt containsString:@"密码管理"]) {
            [MCPagingStore paging_修改密码];
            return;
        }
        if ([sortt containsString:@"联系客服"]) {
            [MCPagingStore paging_客服];
            return;
        }
        if ([sortt containsString:@"实名认证"]) {
            [MCVerifyStore verifyRealName];
            return;
        }
        if ([sortt containsString:@"签到"]) {
            [MCPagingStore paging_签到];
            return;
        }
        if ([sortt containsString:@"设置"]) {
            [MCPagingStore pagingController:[Common_SettingVC new]];
            return;
        }
        if ([sortt containsString:@"消息"]) {
            [MCPagingStore paging_消息];
            return;
        }

        [MCToast showMessage:@"暂未开通，请检查配置是否正确或升级app"];
    }
    
}
- (void)pushWebWithUrl:(NSString*)url title:(NSString*)title{
    MineWebViewController *web = [[MineWebViewController alloc] init];
    web.navTitle = title;
    NSString *urlNew = [MCVerifyStore verifyURL:url];
    if (!urlNew) {
        urlNew = @"http://mc.mingchetech.com/link/soon.html";
    }
    web.url = urlNew;
    [[MCConvenientStore getCurrentViewController].navigationController pushViewController:web animated:YES];
}
- (NSString*)appendOtherParams:(NSString*)url{
    NSString *phone = [UserInfoManager getUserInfo].phone;
    NSString *token = [UserInfoManager getUserInfo].userToken;
    NSString *userID = [UserInfoManager getUserInfo]._id;
    NSString *ip = [MCBrandConfig sharedConfig].host;
    url = [NSString stringWithFormat:@"%@?phone=%@&token=%@&brandid=%@&userid=%@&ip=%@", url,phone,token,[MCBrandConfig sharedConfig].brand_id,userID,ip];
    return url;
}
@end
