//
//  VIEShowMainCellModel.h
//  Viediscovery
//
//  Created by 李亚飞 on 16/2/24.
//  Copyright © 2016年 李亚飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIEShowMainCellModel : NSObject

@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *name;


//微博创建时间
@property (nonatomic, copy) NSString *created_at;
@end
