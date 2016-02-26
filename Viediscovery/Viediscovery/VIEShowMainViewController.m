//
//  VIEShowMainViewController.m
//  Viediscovery
//
//  Created by Vie on 16/2/21.
//  Copyright © 2016年 Vie. All rights reserved.
//

#import "VIEShowMainViewController.h"
#import "VIELoginViewController.h"
#import "VIEHTTPSessionManager.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "VIEShowMainTableViewCell.h"
#import "VIEShowMainCellModel.h"
#import <MJExtension/MJExtension.h>

@interface VIEShowMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(copy, nonatomic)NSString *token;
@property(strong, nonatomic)UILabel *label;
@property(strong, nonatomic)NSDictionary *dic;

@property(weak, nonatomic)UITableView *tv;
@property(assign, nonatomic)NSInteger page;
@property(assign, nonatomic)NSInteger i;


@property(strong, nonatomic) NSMutableArray *topics;

@end

@implementation VIEShowMainViewController

- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}


static NSString * const CellID = @"showMainTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"SL_Close" object:nil];
    
    UIBarButtonItem *bt = [[UIBarButtonItem alloc]init];
    bt.title = @"TEST";
    [self.navigationItem setLeftBarButtonItem:bt];
    
    [self setupTableView];
    
}

//初始化主界面的TableView
-(void)setupTableView{
    
    UITableView *tv = [[UITableView alloc]init];
    tv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tv.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    // 设置滚动条的内边距
    tv.scrollIndicatorInsets = tv.contentInset;
    
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.backgroundColor = [UIColor clearColor];
    tv.dataSource = self;
    tv.delegate = self;//不要忘记设置代理
    
   // tv.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
    [tv registerNib:[UINib nibWithNibName:NSStringFromClass([VIEShowMainTableViewCell class]) bundle:nil] forCellReuseIdentifier:CellID];
    
    
    
    [self.view addSubview:tv];
    self.tv = tv;
    self.i = 0;
    self.page = 1;//设定当前刷新页为第一页
}

//刷新方法
-(void)setupRefresh{
    self.tv.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tv.mj_header.automaticallyChangeAlpha = YES;
    
    
    [self.tv.mj_header beginRefreshing];

    self.tv.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
   
}


//下拉刷新最新数据
-(void)loadNewData{
    [self.tv.mj_header endRefreshing];
    self.page = 1;
    NSString *path = @"2/statuses/friends_timeline.json";
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"page"] = @(self.page);
 //   NSLog(@"%d",self.page);
    [self getTokenDic];
    if (self.dic == nil) {
        NSLog(@"dic is nil,again");
        [self pushLogin];
    }else{
        md[@"access_token"]=self.dic[@"access_token"];
        VIEHTTPSessionManager *session = [VIEHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [session GET:path parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *topicArrays = responseObject[@"statuses"];
            NSMutableArray *marray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in topicArrays) {
                VIEShowMainCellModel *smcm = [[VIEShowMainCellModel alloc]init];
                smcm.created_at = dic[@"created_at"];
                smcm.profile_image_url = dic[@"user"][@"profile_image_url"];
                smcm.name = dic[@"user"][@"name"];
                smcm.text = dic[@"text"];
            //    NSLog(@"-------%@",smcm.text);
                [marray addObject:smcm];
            }
        //    [self.topics addObjectsFromArray:marray];
            self.topics = marray;
            [self.tv.mj_header endRefreshing];
            [self.tv reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"--------------%@",error);
        }];
    }
    
}


//上拉刷新更多数据
-(void)loadMoreData{
    [self.tv.mj_header endRefreshing];
    self.page++ ;
    NSString *path = @"2/statuses/friends_timeline.json";
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"page"]=@(self.page);
  //  NSLog(@"%d",self.page);
    [self getTokenDic];
    if (self.dic == nil) {
        NSLog(@"dic is nil,getTokenDic again");
        [self pushLogin];
    }else{
        md[@"access_token"]=self.dic[@"access_token"];
        VIEHTTPSessionManager *session = [VIEHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [session GET:path parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *topicArrays = responseObject[@"statuses"];
            NSMutableArray *marray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in topicArrays) {
                VIEShowMainCellModel *smcm = [[VIEShowMainCellModel alloc]init];
                smcm.created_at = dic[@"created_at"];
                smcm.profile_image_url = dic[@"user"][@"profile_image_url"];
                smcm.name = dic[@"user"][@"name"];
                smcm.text = dic[@"text"];
            //    NSLog(@"-------%@",smcm.text);

                [marray addObject:smcm];
            }
            [self.topics addObjectsFromArray:marray];
            [self.tv reloadData];
            [self.tv.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"--------------%@",error);
        }];
    }

}

//界面出现时执行刷新最新数据方法
-(void)viewDidAppear:(BOOL)animated{
    
    [self setupTableView];
    [self setupRefresh];
    
  //  [self loadNewData];
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

//弹出登录界面
-(void)pushLogin{
    VIELoginViewController *lvc = [[VIELoginViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:YES];
}


//表格行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d",self.topics.count);
    return self.topics.count;
}

//单元格属性
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VIEShowMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    cell.topic = self.topics[indexPath.row];
    return cell;
}


//单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VIEShowMainCellModel *smcm = self.topics[indexPath.row];
    NSLog(@"-----%f",smcm.cellHeight);
    return smcm.cellHeight;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
