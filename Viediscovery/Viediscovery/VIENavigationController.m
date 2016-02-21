//
//  VIENavigationController.m
//  VieWeibo
//
//  Created by 李亚飞 on 16/2/20.
//  Copyright © 2016年 李亚飞. All rights reserved.
//

#import "VIENavigationController.h"
#import "VIEShowMainViewController.h"

@interface VIENavigationController ()

@end

@implementation VIENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    VIEShowMainViewController *smvc = [[VIEShowMainViewController alloc]init];
   // [self pushViewController:smvc animated:YES];
    [self addChildViewController:smvc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
}

- (void)tongzhi:(NSNotification *)text{
    [self popViewControllerAnimated:YES];
    NSLog(@"－－－－－接收到通知------");
    
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
