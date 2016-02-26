//
//  VIEShowMainCellModel.h
//  Viediscovery
//
//  Created by Vie on 16/2/24.
//  Copyright © 2016年 Vie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIEShowMainCellModel : NSObject

@property (nonatomic, copy) NSString *profile_image_url;
@property (nonatomic, copy) NSString *name;


//微博创建时间
@property (nonatomic, copy) NSString *created_at;

//微博内容
@property (nonatomic, copy) NSString *text;


/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
