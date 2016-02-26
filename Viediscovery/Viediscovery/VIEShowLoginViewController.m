//
//  VIEShowLoginViewController.m
//  Viediscovery
//
//  Created by Vie on 16/2/21.
//  Copyright © 2016年 Vie. All rights reserved.
//

#import "VIEShowLoginViewController.h"
#import "VIEHTTPSessionManager.h"

@interface VIEShowLoginViewController ()<UIWebViewDelegate>
@property (nonatomic, copy) NSString *accessToken;
@end

@implementation VIEShowLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
   
    
    
    NSString *getToken_Request_URL = @"https://api.weibo.com/oauth2/authorize";
    NSString *client_id = @"3082368261";
    NSString *redirect_uri = @"https://github.com/mistervie";
    NSString *getTokenString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@",getToken_Request_URL,client_id,redirect_uri];
    NSURL *getToken_URL = [NSURL URLWithString:getTokenString];
    NSURLRequest *rq = [NSURLRequest requestWithURL:getToken_URL];
    UIWebView *wv = [[UIWebView alloc]init];
    wv.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [wv loadRequest:rq];
    wv.delegate = self;
    
    [self.view addSubview:wv];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request.URL.query);
    if ([request.URL.absoluteString hasPrefix:@"https://github.com/mistervie"]) {
        NSString *resultURL = request.URL.query;
        NSString *hasCode = @"code=";
        if ([resultURL hasPrefix:hasCode]) {
            NSLog(@"授权成功！");
            NSString *code = [resultURL substringFromIndex:hasCode.length];
            NSLog(@"%@",code);
            
            
            NSString *path = @"oauth2/access_token";
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"client_id"]=@"3082368261";
            md[@"client_secret"]=@"e8449b0a75c28da1cfcdb9bed79152e5";
            md[@"grant_type"]=@"authorization_code";
            md[@"code"]=code;
            md[@"redirect_uri"]=@"https://github.com/mistervie";
            VIEHTTPSessionManager *session = [VIEHTTPSessionManager manager];
            session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            [session POST:path parameters:md progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
                
                [self writeIntoPlist:responseObject];//把服务器返回的json写入plist文件
                [self.navigationController popToRootViewControllerAnimated:YES];//把登录界面pop掉
//                VIEMainFrameNavigationController *smvc = [[VIEMainFrameNavigationController alloc]init];
//                [self.navigationController addChildViewController:smvc];
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"-------%@",error);
            }];
          
        }else{
            NSLog(@"Fail!");
        }
    }else{
        return YES;
    }
    
    return NO;
}


//把access_token,expires_in,uid写入plist
-(void)writeIntoPlist:(NSDictionary *)dic{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [cachesDirectory stringByAppendingPathComponent:@"tokenInfo.plist"];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    mdic[@"access_token"] = dic[@"access_token"];
    mdic[@"expires_in"] = dic[@"expires_in"];
    mdic[@"uid"] = dic[@"uid"];
    [mdic writeToFile:plistPath atomically:YES];
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
