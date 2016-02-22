//
//  VIEShowMainViewController.m
//  VieWeibo
//
//  Created by 李亚飞 on 16/2/21.
//  Copyright © 2016年 李亚飞. All rights reserved.
//

#import "VIEShowMainViewController.h"
#import "VIEShowLoginViewController.h"
#import "VIEHTTPSessionManager.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>


@interface VIEShowMainViewController ()<UITableViewDataSource>
@property(copy, nonatomic)NSString *token;
@property(strong, nonatomic)UILabel *label;
@property(strong, nonatomic)NSDictionary *dic;
@property(strong, nonatomic)NSMutableArray *marray;
@property(weak, nonatomic)UITableView *tv;
@property(assign, nonatomic)NSInteger page;
@property(assign, nonatomic)NSInteger i;
@end

@implementation VIEShowMainViewController

//- (NSMutableArray *)topics
//{
//    if (!_marray) {
//        _marray = [NSMutableArray array];
//    }
//    return _marray;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"SL_Close" object:nil];
    
    self.marray = [[NSMutableArray alloc]init];
    
    UITableView *tv = [[UITableView alloc]init];
    tv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tv.dataSource = self;
    self.tv = tv;
    
    [self.view addSubview:self.tv];
    
    self.i = 0;
    self.page = 1;//设定当前刷新页为第一页
    [self setupRefresh];//加载界面后直接执行刷新方法
}


//刷新方法
-(void)setupRefresh{
    self.tv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tv.mj_header.automaticallyChangeAlpha = YES;
    [self.tv.mj_header beginRefreshing];
    
  //    .stateLabel.font = [UIFont systemFontOfSize:15];
//    self.tv.mj_header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
   
}


//下拉刷新最新数据
-(void)loadNewData{
    self.page = 1;
    NSString *path = @"2/statuses/friends_timeline.json";
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"page"] = @(self.page);
 //   NSLog(@"%d",self.page);
    [self getTokenDic];
    if (self.dic == nil) {
        NSLog(@"dic is nil,pushLogin");
        [self pushLogin];
    }else{
        md[@"access_token"]=self.dic[@"access_token"];
        VIEHTTPSessionManager *session = [VIEHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [session GET:path parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array = responseObject[@"statuses"];
            [self.marray addObjectsFromArray:array];
            [self.tv reloadData];
            [self.tv.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"--------------%@",error);
        }];
    }
    
}


//上拉刷新更多数据
-(void)loadMoreData{
    
    self.page++ ;
    NSString *path = @"2/statuses/friends_timeline.json";
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"page"]=@(self.page);
  //  NSLog(@"%d",self.page);
    [self getTokenDic];
    if (self.dic == nil) {
        NSLog(@"dic is nil,pushLogin");
        [self pushLogin];
    }else{
        md[@"access_token"]=self.dic[@"access_token"];
        VIEHTTPSessionManager *session = [VIEHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [session GET:path parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array = responseObject[@"statuses"];
            [self.marray addObjectsFromArray:array];
            [self.tv reloadData];
            [self.tv.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"--------------%@",error);
        }];
    }

}

//界面出现时执行刷新最新数据方法
-(void)viewDidAppear:(BOOL)animated{
    [self loadNewData];
}
//弹出登录界面
-(void)pushLogin{
    VIEShowLoginViewController *slv = [[VIEShowLoginViewController alloc]init];
    /*
    slv.block = ^(NSString *str){
        //block传值
    };
     */
    [self.navigationController pushViewController:slv animated:YES];
}

//从本地读取token
-(void)getTokenDic{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [cachesDirectory stringByAppendingPathComponent:@"tokenInfo.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.dic = dic;
  //  NSLog(@"%@",dic);

}



//表格行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d",self.marray.count);
    return self.marray.count;
}

//单元格属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //cell.textLabel.text = [NSString stringWithFormat:@"%@",self.marray[indexPath.row][@"id"]];
    
    NSString *time = self.marray[indexPath.row][@"created_at"];
    cell.textLabel.text = time;
    cell.detailTextLabel.text = self.marray[indexPath.row][@"text"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.marray[indexPath.row][@"user"][@"profile_image_url"]]];
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
