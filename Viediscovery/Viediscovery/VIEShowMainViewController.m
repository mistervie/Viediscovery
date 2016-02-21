//
//  VIEShowMainViewController.m
//  VieWeibo
//
//  Created by 李亚飞 on 16/2/21.
//  Copyright © 2016年 李亚飞. All rights reserved.
//

#import "VIEShowMainViewController.h"
#import "VIEShowLoginViewController.h"

@interface VIEShowMainViewController ()
@property(strong, nonatomic)UILabel *label;
@end

@implementation VIEShowMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}

-(void)pushLogin{
    VIEShowLoginViewController *slv = [[VIEShowLoginViewController alloc]init];
//    slv.block = ^(NSString *str){
//        self.label.text = str;
//    };
    [self.navigationController pushViewController:slv animated:YES];
}

-(void)getTokenInfo{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [cachesDirectory stringByAppendingPathComponent:@"tokenInfo.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSLog(@"%@",dic);

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
