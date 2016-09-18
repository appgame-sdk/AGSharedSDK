//
//  AGSSDKUser.m
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/20.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "AGSSDKUser.h"

@implementation AGSSDKUser

- (NSString *)description{
    NSString *str = [NSString stringWithFormat:@"nickname:%@, uid:%@, icon:%@",_nickname,_uid,_icon];
    return str;
}

@end
