//
//  NSMutableDictionary+AGSSDKInit.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/21.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  初始化分享平台相关
 */
@interface NSMutableDictionary (AGSSDKInit)
/**
 *  设置新浪微博应用信息
 *
 *  @param appKey       应用标识
 *  @param appSecret    应用密钥
 *  @param redirectUri  回调地址
 *  @param authType     授权方式。值可以是：SSDKAuthTypeSSO、SSDKAuthTypeWeb、SSDKAuthTypeBoth，分别代表SSO、网页授权、SSO＋网页授权。
 */
- (void)SSDKSetupSinaWeiboByAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri
                          authType:(NSString *)authType;

/**
 *  设置微信(微信好友，微信朋友圈、微信收藏)应用信息
 *
 *  @param appId      应用标识
 *  @param appSecret  应用密钥
 */
- (void)SSDKSetupWeChatByAppId:(NSString *)appId
                     appSecret:(NSString *)appSecret;
/**
 *  设置QQ分享平台（QQ空间，QQ好友分享）应用信息
 *
 *  @param appId          应用标识
 *  @param appKey         应用Key
 *  @param authType       授权方式。值可以是：SSDKAuthTypeSSO、SSDKAuthTypeWeb、SSDKAuthTypeBoth，分别代表SSO、网页授权、SSO＋网页授权。
 */
- (void)SSDKSetupQQByAppId:(NSString *)appId
                    appKey:(NSString *)appKey
                  authType:(NSString *)authType;
@end
