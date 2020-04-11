//
//  MCNewsView.m
//  Project
//
//  Created by Nitch Zheng on 2019/12/10.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCNewsView.h"
#import "MCNewsCell.h"
#import "HomeModel.h"
#import "MineWebViewController.h"
#import "SKListViewController.h"
static NSString *api_getnews = @"/user/app/news/getnewsby/brandidandclassification/andpage";


@interface MCNewsView ()<UITableViewDelegate,UITableViewDataSource>
/** 主视图 */
@property(nonatomic,readwrite,strong) UITableView* za_tableview;

/**  header */
@property(nonatomic,readwrite,strong) UIView *headView;
/**  标题 */
@property(nonatomic,readwrite,strong) UILabel *headTitleLabel;
/**  line */
@property(nonatomic,readwrite,strong) UILabel *line;
/**  更多 */
@property(nonatomic,readwrite,strong) UILabel *moreLabel;
/**  箭头 */
@property(nonatomic,readwrite,strong) UIImageView *moreIcone;

/** 数据源 */
@property(nonatomic,readwrite,strong)  NSMutableArray *datasource;
@end

@implementation MCNewsView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self requestData];
    }
    return self;
}

- (void)initView{
    [self addSubview:self.za_tableview];
}

- (void) requestData{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setNoNullObject:[MCBrandConfig sharedConfig].brand_id forKey:@"brandId"];

    NSString *path = [NSString stringWithFormat:@"%@%@%@", [MCBrandConfig sharedConfig].baseUrl,KBanben,api_getnews];
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setNoNullObject:@"资讯" forKey:@"classifiCation"];
    [param setNoNullObject:[MCBrandConfig sharedConfig].brand_id forKey:@"brandId"];
    [param setNoNullObject:@"20" forKey:@"size"];
    [param setNoNullObject:@"0" forKey:@"page"];
    
    NSString* token  = [UserInfoManager getUserInfo].userToken;
    [LXServer postDataFromAction:path parameters:param config:@{@"authToken":token} result:^(id  _Nullable data, NSError * _Nullable error) {
        [[LXToast shared]hideLoading];
        if(error){
        }else{
            NSArray * newsList = data[@"result"][@"content"];
            if (newsList.count > 0) {
                [self.datasource removeAllObjects];
                for (NSInteger i = 0; i < newsList.count; i++) {
                    HomeModel* model=[[HomeModel alloc]initWithDictionary:newsList[i]];
                    [self.datasource addObject:model];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updataHeight];
            [self.za_tableview reloadData];
        });
    }];
}
- (void)updataHeight{
    if (self.datasource.count < 4) {
        if (self.datasource.count == 0) {
            self.frame = CGRectMake(self.ly_x, self.ly_y, self.ly_width,0);
        }else{
            self.frame = CGRectMake(self.ly_x, self.ly_y, self.ly_width,100 * self.datasource.count + 50);
        }
        if (self.height) {
            self.height(self.ly_height);
        }
        self.za_tableview.frame = CGRectMake(0, 0,self.width,self.ly_height);
    }else{
        self.frame = CGRectMake(self.ly_x, self.ly_y, self.ly_width,100 * 4 + 50);
        if (self.height) {
            self.height(self.ly_height);
        }
        self.za_tableview.frame = CGRectMake(0, 0,self.width,self.ly_height);
    }
}

#pragma mark - Protocol Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count > 4 ? 4 : self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    MCNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    [cell updataWithModel:self.datasource[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel* model = self.datasource[indexPath.row];
    NSString* isAddParam = [NSString stringWithFormat:@"%@",model.publisher];
    [MCPagingStore pushWebTitle:model.title classifiCation:@"资讯"];
//    if ([isAddParam isEqualToString:@"add"]) {
//        [self pushWebWithUrl:[self appendOtherParams:model.content] title:model.title];
//    }else{
//        [self pushWebWithUrl:model.content title:model.title];
//    }
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

#pragma mark - Action
- (void) headAction{
    [[MCConvenientStore getCurrentViewController].navigationController pushViewController:[[SKListViewController alloc] initWithClassification:@"资讯"]  animated:YES];
}

- (UITableView *)za_tableview {
    if (!_za_tableview) {
        _za_tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.width,350) style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _za_tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _za_tableview.scrollEnabled = NO;
        _za_tableview.backgroundColor = [UIColor whiteColor];
        _za_tableview.delegate = self;
        _za_tableview.dataSource = self;
       [_za_tableview registerNib:[UINib nibWithNibName:@"MCNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
        UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width,15)];
        _za_tableview.tableFooterView = footView;
    }
    return _za_tableview;
}
- (UILabel*)headTitleLabel{
    if (nil == _headTitleLabel) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, (49 - 15) * 0.5, 2, 15)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#2794FF"];
        [_headView addSubview:lineView];
        
        _headTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(28, 0,self.width-44,49)];
        _headTitleLabel.text = @"最新资讯";
        _headTitleLabel.font = [UIFont systemFontOfSize:15];
        _headTitleLabel.textColor = [UIColor colorWithHexString:@"#3C3C3C"];
    }
    return _headTitleLabel;
}

- (UILabel*)line{
    if (nil == _line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(20,48,self.width - 20 * 2,1)];
        _line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _line;
}

- (UILabel*)moreLabel{
    if (nil == _moreLabel) {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ly_width-26.5-25,15,30,20)];
        _moreLabel.textColor = [UIColor mainColor];
        _moreLabel.font = [UIFont systemFontOfSize:14];
        _moreLabel.textAlignment = NSTextAlignmentLeft;
        _moreLabel.text = @"更多";
    }
    return _moreLabel;
}
- (UIImageView*)moreIcone{
    if (nil == _moreIcone) {
        _moreIcone = [[UIImageView alloc] initWithFrame:CGRectMake(self.moreLabel.LY_right+5,18.5, 7, 12.5)];
        _moreIcone.image = [[UIImage imageNamed:@"CreditsExchangeFooterArrow"] imageWithColor:[UIColor mainColor]];
    }
    return _moreIcone;
}
- (UIView*) headView {
    if (nil == _headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,50)];
        _headView. userInteractionEnabled = YES;
        [_headView addSubview:self.headTitleLabel];
        [_headView addSubview:self.line];
        [_headView addSubview:self.moreLabel];
        [_headView addSubview:self.moreIcone];
        
        //添加手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headAction)];
        [_headView addGestureRecognizer:tap];
    }
    return _headView;
}
- (NSMutableArray*) datasource {
    if (nil == _datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}
@end
