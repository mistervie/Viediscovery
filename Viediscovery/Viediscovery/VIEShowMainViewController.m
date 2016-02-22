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

@interface VIEShowMainViewController ()<UITableViewDataSource>
@property(copy, nonatomic)NSString *token;
@property(strong, nonatomic)UILabel *label;
@property(strong, nonatomic)NSDictionary *dic;
@property(strong, nonatomic)NSMutableArray *marray;
@property(weak, nonatomic)UITableView *tv;
@end

@implementation VIEShowMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(10, 100, 100, 30);
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:@"TEST" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushLogin) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, 150, 200, 30);
    label.backgroundColor = [UIColor whiteColor];
    self.label = label;
    
    UIButton *buttonReloadTextFiledData = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonReloadTextFiledData.frame = CGRectMake(10, 200, 100, 30);
    [buttonReloadTextFiledData setBackgroundColor:[UIColor whiteColor]];
    [buttonReloadTextFiledData setTitle:@"GetData" forState:UIControlStateNormal];
    [buttonReloadTextFiledData addTarget:self action:@selector(getTokenInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:label];
    
    [self.view addSubview:button];
    
    [self.view addSubview:buttonReloadTextFiledData];
     */
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"SL_Close" object:nil];
    [self getData];
    
    UITableView *tv = [[UITableView alloc]init];
    tv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    tv.dataSource = self;
    self.tv = tv;
    
    [self.view addSubview:self.tv];
}


-(void)viewDidAppear:(BOOL)animated{
    [self getData];
}
//弹出登录界面
-(void)pushLogin{
    VIEShowLoginViewController *slv = [[VIEShowLoginViewController alloc]init];
    slv.block = ^(NSString *str){
        //block传值
    };
    [self.navigationController pushViewController:slv animated:YES];
}

//从本地读取token
-(void)getTokenDic{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [cachesDirectory stringByAppendingPathComponent:@"tokenInfo.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.dic = dic;
    NSLog(@"%@",dic);

}

-(void)getData{
    NSString *path = @"2/statuses/friends_timeline.json";
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    [self getTokenDic];
    if (self.dic == nil) {
        NSLog(@"dic is nil,pushLogin");
        [self pushLogin];
    }else{
        md[@"access_token"]=self.dic[@"access_token"];
        VIEHTTPSessionManager *session = [VIEHTTPSessionManager manager];
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        [session GET:path parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *marray = responseObject[@"statuses"];
            self.marray = marray;
            [self.tv reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"--------------%@",error);
        }];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.marray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.marray[indexPath.row][@"text"];
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
