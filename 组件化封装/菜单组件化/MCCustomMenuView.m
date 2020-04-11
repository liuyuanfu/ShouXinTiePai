//
//  MCCustomMenuView.m
//  Project
//
//  Created by Ning on 2019/11/5.
//  Copyright © 2019 LY. All rights reserved.
//

#import "MCCustomMenuView.h"
#import "MCMenuItemView.h"
#import "MCDataProfessor.h"
#import "MCMenuManager.h"
#import "MHMainView.h"
#define kRow                4   // 列数
#define kRowSpacing         10  // 列间距
#define kLineSpacing        10  // 行间距
#define kMenuHeight         80.0f // item高度
#define KMainHight          180.0f // 主功能区高度
#define kMenuWidth          (self.frame.size.width - (kRowSpacing * (kRow+1))) / kRow

@interface MCCustomMenuView ()<MCMenuItemViewDelegate, MHMainViewDelegate>
/** 数据源 */
@property(nonatomic,readwrite,strong)  NSMutableArray *datasource;
/** 视图容器 */
@property(nonatomic,readwrite,strong)  NSMutableArray *menuItemArray;
/** 排序后的正常数据 */
@property(nonatomic,readwrite,strong)  NSMutableArray *sortArray;
/** 行数 */
@property(nonatomic,readwrite,assign)  NSInteger row;
/** 列数 */
@property(nonatomic,readwrite,assign)  NSInteger columnn;
/** 视图高度 */
@property(nonatomic,readwrite,assign)  CGFloat height;
/** 功能区类型 */
@property(nonatomic,readwrite,assign)  MCCustomMenuViewDataType dataType;

@end
@implementation MCCustomMenuView

#pragma mark - Public Methods
- (instancetype)initWithFrame:(CGRect)frame
                     dataType:(MCCustomMenuViewDataType)dataType{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataType = dataType;
        [self p_baseDataSet];
        [self p_setUI];
        [self refreshData];
    }
    return self;
}

- (void) refreshData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self p_getMenuComponentData];
    });
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self p_setUI];
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    if (self.menuViewHeight) {
//        self.menuViewHeight(self.height);
//    }
}
/// 自定义视图的位置
/// @param lineSpacing 行间距
/// @param rowSpacing 列间距
/// @param menuWidth 单个视图宽度
/// @param menuHeight 单个视图高度
- (void) resetLineSpacing:(CGFloat)lineSpacing
               rowSpacing:(CGFloat)rowSpacing
                  menuWidth:(CGFloat)menuWidth
                  menuHeight:(CGFloat)menuHeight{
    for (NSInteger i = 0; i < self.menuItemArray.count; i++) {
        MCMenuItemView* itemView = self.menuItemArray[i];
        itemView.frame = CGRectMake(rowSpacing + i%self.columnn * (menuWidth + rowSpacing),lineSpacing + i/self.columnn * (menuHeight + lineSpacing),menuWidth, menuHeight);
        [itemView refreshUI];
    }
    //计算高度
    self.height = lineSpacing * (self.row+1) + menuHeight*self.row;
    if (self.menuViewHeight) {
        if (self.height > 0) {
            self.menuViewHeight(self.height);
        }
    }
}

#pragma mark - Private Methods
/// 界面设置
- (void) p_setUI{
    self.row = 0;
    self.columnn = 1;
    self.backgroundColor = [UIColor whiteColor];
}
- (void) p_baseDataSet{
    if (!self.itemColor) {
       self.itemColor = [UIColor whiteColor];
    }
    if (!self.itemFont) {
        self.itemFont = [UIFont systemFontOfSize:14];
    }
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
            [self p_parseDataSource:datasource];
        }
    }];
}

- (void)p_parseDataSource:(NSArray*)datasource{
    switch (self.dataType) {
        case MCCustomMenuViewTypeMain:{
            self.datasource = [[MCDataProfessor sharedConfig] getShelvesWithDatasource:datasource isMain:YES].mutableCopy;
        }
        break;
        case MCCustomMenuViewTypeVice:{
            self.datasource = [[MCDataProfessor sharedConfig] getShelvesWithDatasource:datasource isMain:NO].mutableCopy;
        }
        break;
        default:
        break;
    }
}

- (void) p_creatMenuList{
    self.row = [[MCDataProfessor sharedConfig] getMaxRow:self.datasource];
    self.columnn = [[MCDataProfessor sharedConfig] getMaxColumnn:self.datasource];
    
    // 默认高度
    CGFloat width = (kScreenW - (self.columnn+1)*kRowSpacing)/self.columnn;
    CGFloat height = kMenuHeight;
    if (self.dataType == MCCustomMenuViewTypeMain) {
        MHMainView *mainView = [[MHMainView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 119)];
        mainView.delegate = self;
        mainView.dataArray = self.datasource;
        [self addSubview:mainView];
        
        self.height = 119;
        self.menuViewHeight(119);
    } else {
        for (NSUInteger i = 0; i < self.datasource.count; i++) {
            NSDictionary* menuDictionary = self.datasource[i];
            NSInteger row = [[NSString stringWithFormat:@"%@",menuDictionary[@"row"]] integerValue]-1;
            NSInteger columnn = [[NSString stringWithFormat:@"%@",menuDictionary[@"columnn"]] integerValue]-1;
            
            MCMenuItemView* itemView = [[MCMenuItemView alloc] initWithFrame:CGRectMake(kRowSpacing + columnn * (width + kRowSpacing),kLineSpacing + row * (height + kLineSpacing),width, height)];
            itemView.tag = i;
            itemView.delegate = self;
            [itemView updataBackgroundColor:self.itemColor titlesFont:self.itemFont iconeWidth:self.iconeWidth iconeHeight:self.iconeHeight];
            [itemView updataWithDataSource:menuDictionary];
            [self addSubview:itemView];

            [self.menuItemArray addObject:itemView];
            [self.sortArray addObject:menuDictionary];
            
            itemView.layer.cornerRadius = 5;
            itemView.layer.masksToBounds = YES;
        }
        //计算高度
        self.height = kLineSpacing * (self.row+1) + height*self.row;
        if (self.menuViewHeight) {
            if (self.height > 0) {
                self.menuViewHeight(self.height);
            }
        }
    }
    
    
}

- (void) p_clearView{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - Protocol Methods
- (void)didSeletedMenuItemWithTag:(NSUInteger)aTag{
    if (self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary) {
        self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary(aTag, self.sortArray[aTag]);
    }
    [[MCMenuManager sharedConfig] pushModuleWithData:self.sortArray[aTag]];
}
- (void)didSeletedMainViewWithTag:(NSUInteger)aTag
{
    if (self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary) {
        self.didSeletedMenuItemWithSeletedItemIndexAndSeletedDictionary(aTag, self.sortArray[aTag]);
    }
    [[MCMenuManager sharedConfig] pushModuleWithData:self.datasource[aTag]];
}
#pragma mark - Setter And Getter Method
- (void)setHeight:(CGFloat)height{
    _height = height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height);
}

- (void)setDatasource:(NSMutableArray *)datasource{
    _datasource = datasource;
    [self p_clearView];
    [self p_creatMenuList];
}

- (NSMutableArray*) menuItemArray {
    if (nil == _menuItemArray) {
        _menuItemArray = [[NSMutableArray alloc] init];
    }
    return _menuItemArray;
}

- (NSMutableArray*) sortArray {
    if (nil == _sortArray) {
        _sortArray = [[NSMutableArray alloc] init];
    }
    return _sortArray;
}
@end
