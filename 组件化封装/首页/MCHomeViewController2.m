//
//  MCHomeViewController2.m
//  Project
//
//  Created by Ning on 2019/12/6.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCHomeViewController2.h"
#import "MCCustomMenuView.h"  // 主副功能区
#import "MCRunLightView.h"    //跑马灯
#import "MCTitleCustomView.h" //标题和竖条颜色
#import "MCSafeCustomView.h"  //保险
#import "MCNewsView.h"        //资讯

// 竖条顶部高度
#define kTitleCustomTopSpaceHeight   10
// 账户安全顶部高度
#define kSafeTopSpaceHeight          10
@interface MCHomeViewController2 ()<UITableViewDelegate, UITableViewDataSource>
/** 主功能区 */
@property(nonatomic,readwrite,strong)  MCCustomMenuView *mainMenuView;
/** 副功能区 */
@property(nonatomic,readwrite,strong)  MCCustomMenuView *viceMenuView;
/** 标题和竖条 */
@property(nonatomic,readwrite,strong)  MCTitleCustomView *titleCustomView;
/** 广告位 */
@property(nonatomic,readwrite,strong)  MCBannerView *adView;
/** 跑马灯 */
@property(nonatomic,readwrite,strong)  MCRunLightView *runLightView;
/** 保险 */
@property(nonatomic,readwrite,strong)  MCSafeCustomView *safeCustomView;
/** 资讯 */
@property(nonatomic,readwrite,strong)  MCNewsView   *newsView;

/*******************************分类***************************************/
/** 主功能区整体视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_mainview;
/** 副功能区整体视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_viceview;
/** 广告整体视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_adview;
/** 跑马灯视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_runlighview;
/** 保险视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_safeview;
/** 资讯视图 */
@property(nonatomic,readwrite,strong)  UIView *mc_newsview;
/** 模块视图数据源 */
@property(nonatomic,readwrite,strong)  NSMutableArray *moduleDataSource;
@end

@implementation MCHomeViewController2

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self  configData];
    [self  configUI];
    [self  setCustomView];
    [self  requestData];
    [self  addRefresh];
}
#pragma mark - Private Methods
- (void)configData{
    
    self.za_tableview.frame = CGRectMake(0, 0, kScreenW, kScreenH - LY_TabbarHeight);
    self.za_tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.za_tableview.delegate  = self;
    self.za_tableview.dataSource = self;
}

- (void)configUI{
    [self.view addSubview:self.za_tableview];
}

- (void)addRefresh{
    __weak __typeof(self)weakSelf = self;
    self.za_tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf.mainMenuView refreshData];
        [strongSelf.viceMenuView refreshData];
        [strongSelf requestData];
    }];
}
/**
 * 更新视图高度.
 */
- (void) updataViewHeight:(UIView*) supView viewHeight:(CGFloat) height{
    supView.frame = CGRectMake(0, 0,supView.width, height);
}

#pragma mark - Network Methods
- (void) requestData{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setNoNullObject:[MCBrandConfig sharedConfig].brand_id forKey:@"brandId"];
    
    NSString *path = ([NSString stringWithFormat:@"%@%@%@", [MCBrandConfig sharedConfig].baseUrl, KBanben,@"/user/app/select/topup/home/BrandMiddle/"]);
    NSString* token  = [UserInfoManager getUserInfo].userToken;
    [LXServer postDataFromAction:path parameters:params config:@{@"authToken":token} result:^(id  _Nullable data, NSError * _Nullable error) {
        [[LXToast shared]hideLoading];
        if(error){
            [LXToast showMessage:error.domain];
        }else{
            NSArray* tempArray = @[self.mc_adview,self.mc_mainview,self.mc_runlighview,self.mc_viceview,self.mc_newsview,self.mc_safeview];
            
            NSArray* result = data[@"result"];
            for (NSInteger i = 0; i < result.count; i++) {
                NSDictionary* innerDict = result[i];
                NSString* status = [NSString stringWithFormat:@"%@",innerDict[@"status"]];
                NSUInteger locationName = [[NSString stringWithFormat:@"%@",innerDict[@"accountDetails"]] integerValue];
                UIView* tempView = tempArray[locationName];
                if ([status isEqualToString:@"1"]) {// 上架
                    tempView.tag = i;
                    [self.moduleDataSource replaceObjectAtIndex:i withObject:tempView];
                }else{
                    [self.moduleDataSource replaceObjectAtIndex:locationName withObject:[[UIView alloc]initWithFrame:CGRectZero]];
                }
                if (locationName == 5) {// 安全区
                    [self.safeCustomView updataWithIconeUrl:innerDict[@"messageBar"]];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.za_tableview reloadData];
            [self.za_tableview.mj_header endRefreshing];
        });
    }];
}

/**
 * 只需要布局就行
 */
- (void)setCustomView {
    __weak typeof(self) weakSelf = self;
    self.mainMenuView.menuViewHeight = ^(CGFloat menuViewHeight) {
        __strong __typeof(self) strongSelf = weakSelf;
        //更新数据
        [strongSelf updataViewHeight:strongSelf.mc_mainview viewHeight:menuViewHeight];
        NSLog(@"strongSelf.mc_mainview.tag---%ld",weakSelf.mc_mainview.tag);
        
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:weakSelf.mc_mainview.tag];
            [weakSelf.za_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    };

    self.viceMenuView.menuViewHeight = ^(CGFloat menuViewHeight) {
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf updataViewHeight:strongSelf.mc_viceview viewHeight:(self.titleCustomView.height+menuViewHeight+kTitleCustomTopSpaceHeight)];
        NSLog(@"strongSelf.mc_viceview.tag---%ld",strongSelf.mc_viceview.tag);
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:strongSelf.mc_viceview.tag];
            [strongSelf.za_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    };
    
    self.newsView.height = ^(CGFloat height) {
        __strong __typeof(self) strongSelf = weakSelf;
        [strongSelf updataViewHeight:strongSelf.mc_newsview viewHeight:height];
        NSLog(@"height---%f",height);
        [UIView performWithoutAnimation:^{
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:strongSelf.mc_newsview.tag];
            [strongSelf.za_tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    };
 
}
#pragma mark - Protocol Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.moduleDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView* subView = self.moduleDataSource[indexPath.section];
    return subView.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *cellID = @"ReusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:cellID];
    }
    [cell.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (self.moduleDataSource.count > 0) {
        UIView* subView = self.moduleDataSource[indexPath.section];
        [cell addSubview:subView];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - Action Methods

#pragma mark - Setter And Getter Method
- (UIView*) mc_mainview {
    if (nil == _mc_mainview) {
        _mc_mainview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,0)];
        [_mc_mainview addSubview:self.mainMenuView];
//        [self updataViewHeight:_mc_mainview viewHeight:self.mainMenuView.height];
    }
    return _mc_mainview;
}

- (UIView*) mc_viceview{
    if (nil == _mc_viceview) {
        _mc_viceview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,0)];
        _mc_viceview.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        [_mc_viceview addSubview:self.titleCustomView];
        [_mc_viceview addSubview:self.viceMenuView];
        [self updataViewHeight:_mc_viceview viewHeight:(self.viceMenuView.height)];
    }
    return _mc_viceview;
}

- (UIView*) mc_adview {
    if (nil == _mc_adview) {
        _mc_adview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,100)];
        [_mc_adview addSubview:self.adView];
        [self updataViewHeight:_mc_adview viewHeight:(self.adView.height)];
    }
    return _mc_adview;
}

- (UIView*) mc_runlighview {
    if (nil == _mc_runlighview) {
        _mc_runlighview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,100)];
        [_mc_runlighview addSubview:self.runLightView];
        [self updataViewHeight:_mc_runlighview viewHeight:self.runLightView.height];
    }
    return _mc_runlighview;
}

- (UIView*) mc_safeview {
    if (nil == _mc_safeview) {
        
        _mc_safeview = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenW,100)];
        _mc_safeview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_mc_safeview addSubview:self.safeCustomView];
        [self updataViewHeight:_mc_safeview viewHeight:self.safeCustomView.height+kSafeTopSpaceHeight*2];
    }
    return _mc_safeview;
}

- (UIView*) mc_newsview {
    if (nil == _mc_newsview) {
        _mc_newsview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,0)];
        _mc_newsview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_mc_newsview addSubview:self.newsView];
        [self updataViewHeight:_mc_newsview viewHeight:49 + 93 * 3 + 15 + 10];
    }
    return _mc_newsview;
}

- (MCCustomMenuView*) mainMenuView {
    if (nil == _mainMenuView) {
        _mainMenuView = [[MCCustomMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,80) dataType:MCCustomMenuViewTypeMain];
        _mainMenuView.itemColor = [UIColor clearColor];
        _mainMenuView.iconeWidth = 54;
        _mainMenuView.iconeHeight = 292 - LY_StatusBarAndNavigationBarHeight;
    }
    return _mainMenuView;
}
- (MCCustomMenuView*) viceMenuView {
    if (nil == _viceMenuView) {
        _viceMenuView = [[MCCustomMenuView alloc] initWithFrame:CGRectMake(0, 0,kScreenW,190) dataType:MCCustomMenuViewTypeVice];
    }
    return _viceMenuView;
}
- (MCBannerView*) adView {
    if (nil == _adView) {
        _adView = [[MCBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,200) Type:@"0"];
    }
    return _adView;
}

- (MCRunLightView*) runLightView {
    if (nil == _runLightView) {
        _runLightView = [[MCRunLightView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,40)];
        _runLightView.backgroundColor = [UIColor colorWithHexString:@"#F7F9FB"];
    }
    return _runLightView;
}

//- (MCTitleCustomView*) titleCustomView {
//    if (nil == _titleCustomView) {
//        _titleCustomView = [[MCTitleCustomView alloc] initWithFrame:CGRectMake(0,kTitleCustomTopSpaceHeight,kScreenW ,21)];
//        _titleCustomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        _titleCustomView.titleName.text = @"欢乐付服务";
//    }
//    return _titleCustomView;
//}

- (MCSafeCustomView*) safeCustomView {
    if (nil == _safeCustomView) {
        _safeCustomView = [[MCSafeCustomView alloc] initWithFrame:CGRectMake(0,kSafeTopSpaceHeight,kScreenW ,21)];
        _safeCustomView.backgroundColor = [UIColor clearColor];
    }
    return _safeCustomView;
}

- (MCNewsView*) newsView {
    if (nil == _newsView) {
        _newsView = [[MCNewsView alloc] initWithFrame:CGRectMake(0,0,kScreenW,100)];
        _newsView.backgroundColor = [UIColor clearColor];
    }
    return _newsView;
}

- (NSMutableArray*) moduleDataSource {
    if (nil == _moduleDataSource) {
        _moduleDataSource = @[[[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero],
        [[UIView alloc]initWithFrame:CGRectZero]].mutableCopy;
    }
    return _moduleDataSource;
}

@end
