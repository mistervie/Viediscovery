//
//  VIEShowLoginViewController.h
//  VieWeibo
//
//  Created by 李亚飞 on 16/2/21.
//  Copyright © 2016年 李亚飞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnTokenBlock)(NSString *str);

@interface VIEShowLoginViewController : UIViewController
@property (copy, nonatomic) returnTokenBlock block;
@end
