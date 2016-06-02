//
//  BusinessViewController.m
//  Business_List1.0
//
//  Created by 冀柳冲 on 16/6/2.
//  Copyright © 2016年 JLC. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessTableViewCell.h"
#import "NetStatusHelper.h"
#import "Account.h"
#import "MBProgressHUD.h"
#import "DataBaseTool.h"
#import "AFNtool.h"
@interface BusinessViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL isLoaded;//加载完毕后显示数据
    /**
     *  判断网络是否连接
     */
    //  BOOL isLinked;
}

/**
 *  菊花控件
 */
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NetStatusHelper *statusHelper;
@property(nonatomic,assign)BOOL isLinked;
@property(nonatomic,strong)Account *account;

/**
 *  存储解析出来的model(商家信息)
 */
@property(nonatomic,strong)NSMutableArray *modelArray;
/**
 *  通讯新天地
 */
@property(nonatomic,strong)NSMutableArray *xtdArray;
/**
 *  凯盛
 */
@property(nonatomic,strong)NSMutableArray *ksArray;
/**
 *  通讯大世界
 */
@property(nonatomic,strong)NSMutableArray *dsjArray;
/**
 *  裕泰通讯
 */
@property(nonatomic,strong)NSMutableArray *ytArray;
/**
 *  其他分类
 */
@property(nonatomic,strong)NSMutableArray *otherArray;


@property(nonatomic,strong)UITableView *tableView;
/**
 *  存储解析出来的model的商家名称
 */
@property(nonatomic,strong)NSMutableArray *nameArray;
/**
 *  存储解析出来的model的商家门牌号
 */
@property(nonatomic,strong)NSMutableArray *numberArray;



@property(nonatomic,strong)DataBaseTool *dbTool;


@end


static NSString * businessIdent = @"business";

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家列表";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
    //防止tableheaderView被导航栏遮挡
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置导航栏不透明
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;


    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView registerClass:[BusinessTableViewCell class] forCellReuseIdentifier:businessIdent];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColorFromRGB(887478);
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
  



}

//整理从数据库获取到的所有数据
-(void)setAllDataFromSqliteWithNetwork:(BOOL)isLink
{
    NSLog(@"hahah%@",[NSNumber numberWithBool:_isLinked]);
    if (isLink == YES) {
       // [self showHUBWithString:@"数据加载中,请稍后..."];
        [AFNtool JSwithUrl:BusinessUrl sucess:^(id obj) {
            
            NSString * totalCount = obj[@"total"];
            NSLog(@"total:%@",totalCount);
            NSArray *array = obj[@"data"];
            
            [_dbTool creatTable];
            for (NSDictionary *dic in array) {
                BusinessModel *model = [BusinessModel new];
                [model setValuesForKeysWithDictionary:dic];
                if( ![self isAllNum:model.userID]){//剔除登录名是纯数字的
                    if ([self isAllNum:model.SName] ) {//剔除商家名称是纯数字的
                        continue;
                    }
                    //    NSLog(@"userID = %@",model.userID);
                    [self.modelArray addObject:model];
                }
            }
            //NSLog(@"arrayCount: %ld",self.modelArray.count);
            [_dbTool insertBusinessInfoArray:self.modelArray Block:^(NSString *result) {
                NSLog(@"%@",result);
                //                [[NSUserDefaults standardUserDefaults] setInteger:self.modelArray.count forKey:@"BUSINESS_COUNT"];
                //                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
            //整理数据
            [self orderbusinessData];
            
            // [self hideHUDandTimeDelay:1.0];
            //刷新UI
            [self.tableView reloadData];
           // [self hideHUDandTimeDelay:1.0];
        } faile:^(id obj) {
            NSLog(@"ERROR:%@",obj);
        }];
    }else{
        // [self showHUBWithString:@"数据加载中,请稍后..."];
        [_dbTool selectAllBusiness];
        [self.modelArray removeAllObjects];
        self.modelArray = _dbTool.allDataArray;
        [self orderbusinessData];
        [self.tableView reloadData];
        // [self hideHUDandTimeDelay:1.0];
    }
}
/**
 *  对解析出来的(或者从数据库获取的)数据进行分析整理,分为通讯新天地,凯盛,大世界,其他
 */
- (void)orderbusinessData
{
    if(self.modelArray)
    {
        
        for (BusinessModel *model in _modelArray) {
            //根据用户登录名判断第一位是数字的以及包含XTD的,是通讯新天地的
            NSString *str = [model.userID substringWithRange:NSMakeRange(0, 1)];
            if([model.userID hasPrefix:@"XTD"] ||([str compare:@"1"]>=0 && [str compare:@"9"]<=0) ){
                [self.xtdArray addObject:model];
            }
            else if([model.userID hasPrefix:@"KS"])
            {
                [self.ksArray addObject:model];
            }
            else if([model.userID rangeOfString:@"DSJ"].location != NSNotFound)
            {
                [self.dsjArray addObject:model];
            }else if ([model.userID rangeOfString:@"YT"].location != NSNotFound){
                [self.ytArray addObject:model];
            }
            else
                [self.otherArray addObject:model];
        }
        
        [self sortedArray:self.xtdArray ];
        [self sortedArray:self.ksArray];
        [self sortedArray:self.dsjArray];
        [self sortedArray:self.ytArray];
        [self sortedArray:self.otherArray];
    }
}


/**
 *  对数组进行排序
 *
 *  @param array 排序
 */
- (void)sortedArray:(NSMutableArray *)array
{
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        BusinessModel *model1 = (BusinessModel *)obj1;
        BusinessModel *model2 = (BusinessModel *)obj2;
        if([model1.userID compare:model2.userID]>0)
        {
            return NSOrderedDescending;
        }else if ([model1.userID compare:model2.userID]<0){
            return NSOrderedAscending;
        }else
            return NSOrderedSame;
    }];
    
    
}





/**
 *  判断是否是纯数字  C语言的方法
 *
 *  @param string SName
 *
 *  @return 是的话返回YES
 */
- (BOOL)isAllNum:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%s",__FUNCTION__);
    return 30;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Kheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:businessIdent forIndexPath:indexPath];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
