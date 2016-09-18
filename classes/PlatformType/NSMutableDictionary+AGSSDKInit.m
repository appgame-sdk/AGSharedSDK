//
//  NSMutableDictionary+AGSSDKInit.m
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/21.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "NSMutableDictionary+AGSSDKInit.h"
#import "AGSSDKTypeDefine.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import <WeiboSDK/WeiboSDK.h>
#import "AGShareSDK.h"

@implementation NSMutableDictionary (AGSSDKInit)

- (void)SSDKSetupQQByAppId:(NSString *)appId appKey:(NSString *)appKey authType:(NSString *)authType{
    //app注册
    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:nil];
    NSDictionary *PlatformDic = [NSDictionary dictionaryWithObjectsAndKeys:appId,@"appId",appKey,@"appKey",authType,@"authType",tencentOAuth,@"TencentOAuth" ,nil];
    [self setObject:PlatformDic forKey:[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeQQ]];
    
}

- (void)SSDKSetupWeChatByAppId:(NSString *)appId appSecret:(NSString *)appSecret{
    [WXApi registerApp:appId];
//    [WXApi handleOpenURL:nil delegate:[AGShareSDK sharedAGShareSDK]];
    NSDictionary *PlatformDic = [NSDictionary dictionaryWithObjectsAndKeys:appId,@"appId",appSecret,@"appSecret",nil];
    [self setObject:PlatformDic forKey:[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeWechat]];
}

- (void)SSDKSetupSinaWeiboByAppKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectUri:(NSString *)redirectUri authType:(NSString *)authType{
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:appKey];
    [WeiboSDK handleOpenURL:nil delegate:[AGShareSDK sharedAGShareSDK]];

    NSDictionary *PlatformDic = [NSDictionary dictionaryWithObjectsAndKeys:appKey,@"appKey",appSecret,@"appSecret",redirectUri,@"redirectUri",nil];
    [self setObject:PlatformDic forKey:[NSNumber numberWithUnsignedInteger:SSDKPlatformTypeSinaWeibo]];
}
#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin{
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams{
    return nil;
}


@end
