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
#import "BusInfoViewController.h"
#import "BusGroupHeaderView.h"
#import "BusinessGroupModel.h"

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

-(void)netStatus{
    [_statusHelper netWorkStatus:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            _isLinked = NO;
        }else{
            _isLinked = YES;
        }
    }];
}
-(void)loadingNetWorking{
    [_statusHelper netWorkStatus:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            [self showInfoTheNetStatusWithTitle:@"网络出现错误,请检查网络是否已经连接"];
            _statusHelper.isHave = NO;
        }else{
            
            _statusHelper.isHave = YES;
        }
    }];
}
-(void)showHUBWithString:(NSString *)str{
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = str;
    _hud.margin = 10.f;
    _hud.yOffset = 0.f;
    
}

-(void)hideHUDandTimeDelay:(NSTimeInterval)delay{
    _hud.removeFromSuperViewOnHide = YES;
    [_hud hide:YES afterDelay:1.0];
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


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.modelArray.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    
    
    
    
    
    
    
    
    
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    view.backgroundColor = UIColorFromRGB(0X0172C3C);
    if(section == 0)
    {
        label.text = @"通讯新天地";
    }
    if(section == 1)
    {
        label.text = @"凯盛通讯";
    }
    if(section == 2)
    {
        label.text = @"通讯大世界";
    }
    if (section == 3){
        label.text = @"裕泰通讯";
    }else if (section == 4){
        label.text = @"其他";
    }
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    return view;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Kheight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:businessIdent forIndexPath:indexPath];
    UIView *view_bg = [[UIView alloc]initWithFrame:cell.frame];
    view_bg.backgroundColor = UIColorFromRGB(0x089BEB2);
    cell.selectedBackgroundView = view_bg;
    if(indexPath.section == 0){
        if(self.xtdArray){
            BusinessModel *model = self.xtdArray[indexPath.row];
            cell.nameInfo.text = model.SName;
            cell.numberInfo.text = model.SNo;
            return cell;
        }else return cell;
    }
    if(indexPath.section == 1){
        if(self.ksArray){
            BusinessModel *model = self.ksArray[indexPath.row];
            cell.nameInfo.text = model.SName;
            cell.numberInfo.text = model.SNo;
            return cell;
        } else return cell;
    }
    if(indexPath.section == 2){
        if(self.dsjArray){
            BusinessModel *model = self.dsjArray[indexPath.row];
            cell.nameInfo.text = model.SName;
            cell.numberInfo.text = model.SNo;
            return cell;
        }else return cell;
    }else if (indexPath.section == 3){
        if(self.ytArray){
            BusinessModel *model = self.ytArray[indexPath.row];
            cell.nameInfo.text = model.SName;
            cell.numberInfo.text = model.SNo;
            return cell;
        }else return cell;
    }else if (indexPath.row == 4){
        if(self.otherArray){
            BusinessModel *model = self.otherArray[indexPath.row];
            cell.nameInfo.text = model.SName;
            cell.numberInfo.text = model.SNo;
            return cell;
        }else return cell;
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_statusHelper.isHave == NO) {
//        [self showInfoTheNetStatusWithTitle:@"网络出现问题，请稍后再试!!!"];
//        return;
//    }
//    if (_account.status != 1) {
//        [self LoginInfo];
//        return;
//    }
    BusInfoViewController *infoVC = [[BusInfoViewController alloc]init];
    if(indexPath.section == 0)
    {
        BusinessModel *model = _xtdArray[indexPath.row];
        infoVC.infoModel = model;
        infoVC.userID = model.userID;
    }
    if(indexPath.section == 1)
    {
        BusinessModel *model = _ksArray[indexPath.row];
        infoVC.infoModel = model;
        infoVC.userID = model.userID;
        //infoVC.infoModel = _ksArray[indexPath.row];
    }
    if(indexPath.section == 2)
    {
        BusinessModel *model = _dsjArray[indexPath.row];
        infoVC.infoModel = model;
        infoVC.userID = model.userID;
        //infoVC.infoModel = _dsjArray[indexPath.row];
    }
    if (indexPath.section == 3){
        BusinessModel *model = _ytArray[indexPath.row];
        infoVC.infoModel = model;
        infoVC.userID = model.userID;
        //infoVC.infoModel = _ytArray[indexPath.row];
    }else if (indexPath.section == 4){
        BusinessModel *model = _otherArray[indexPath.row];
        infoVC.infoModel = model;
        infoVC.userID = model.userID;
        //infoVC.infoModel = _otherArray[indexPath.row];
        NSLog(@"%@",infoVC.infoModel);
    }
    [self.navigationController pushViewController:infoVC animated:YES];
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

-(void)showInfoTheNetStatusWithTitle:(NSString *)title{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    
    [self.navigationController presentViewController:alert animated:YES completion:^{
        
    }];
    
    
}

@end
