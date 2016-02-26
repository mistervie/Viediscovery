//
//  VIENavigationController.m
//  Viediscovery
//
//  Created by Vie on 16/2/20.
//  Copyright © 2016年 Vie. All rights reserved.
//

#import "VIENavigationController.h"
#import "VIELoginViewController.h"
#import "VIEShowMainViewController.h"

@interface VIENavigationController ()

@end

@implementation VIENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIViewController *vc = [[UIViewController alloc]init];
//    [self addChildViewController:vc];
    self.view.backgroundColor = [UIColor lightGrayColor];
    VIEShowMainViewController *smvc = [[VIEShowMainViewController alloc]init];
    [self pushViewController:smvc animated:YES];
    
    
}


@end
