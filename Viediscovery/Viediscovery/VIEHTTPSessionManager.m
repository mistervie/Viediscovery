//
//  VIEHTTPSessionManager.m
//  Viediscovery
//
//  Created by Vie on 16/2/20.
//  Copyright © 2016年 Vie. All rights reserved.
//

#import "VIEHTTPSessionManager.h"

@implementation VIEHTTPSessionManager
static VIEHTTPSessionManager *_session;
+(instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/"];
        _session = [[super alloc]initWithBaseURL:url];
    });
    return _session;
}
@end
