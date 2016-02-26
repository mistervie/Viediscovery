//
//  VIELoginViewController.m
//  Viediscovery
//
//  Created by 李亚飞 on 16/2/26.
//  Copyright © 2016年 Vie. All rights reserved.
//

#import "VIELoginViewController.h"
#import "VIEShowLoginViewController.h"


@interface VIELoginViewController ()



@end

@implementation VIELoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


- (IBAction)pushLoginView:(UIButton *)sender {
    
    VIEShowLoginViewController *lv = [[VIEShowLoginViewController alloc]init];
    [self.navigationController pushViewController:lv animated:YES];
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
