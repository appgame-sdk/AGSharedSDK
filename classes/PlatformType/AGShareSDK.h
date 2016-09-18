//
//  AGShareSDK.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/21.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableDictionary+AGSSDKInit.h"
#import "AGSSDKTypeDefine.h"
#import "AGSSDKUserQueryConditional.h"
#import "NSMutableDictionary+AGSSDKShare.h"
//#import "WXApi.h"

/**
 *  AGShareSDK APIs
 */
@interface AGShareSDK : NSObject

+ (AGShareSDK *)sharedAGShareSDK;
/**
 *  注册分享平台应用
 *
 *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
 *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
 */
+ (void)registerAppWithActivePlatforms:(NSArray *)activePlatforms
    onConfiguration:(SSDKConfigurationHandler)configurationHandler;
#pragma mark - 授权

/**
 *  分享平台授权
 *
 *  @param platformType       平台类型
 *  @param @param settings    授权设置,目前只接受SSDKAuthSettingKeyScopes属性设置，如新浪微博关注官方微博：@{SSDKAuthSettingKeyScopes : @[@"follow_app_official_microblog"]}，类似“follow_app_official_microblog”这些字段是各个社交平台提供的。
 *  @param stateChangeHandler 授权状态变更回调处理
 */
+ (void)authorize:(SSDKPlatformType)platformType
         settings:(NSDictionary *)settings
   onStateChanged:(SSDKAuthorizeStateChangedHandler)stateChangedHandler;
/**
 *  判断分享平台是否授权
 *
 *  @param platformType 平台类型
 *  @return YES 表示已授权，NO 表示尚未授权
 */
+ (BOOL)hasAuthorized:(SSDKPlatformType)platformTypem;
/**
 *  取消分享平台授权
 *
 *  @param platformType  平台类型
 */
+ (void)cancelAuthorize:(SSDKPlatformType)platformType;
#pragma mark - 用户

/**
 *  获取授权用户信息
 *
 *  @param platformType       平台类型
 *  @param stateChangeHandler 状态变更回调处理
 */
+ (void)getUserInfo:(SSDKPlatformType)platformType
     onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler;

#pragma mark - 分享

/**
 *  分享内容
 *
 *  @param platformType             平台类型
 *  @param parameters               分享参数
 *  @param stateChangeHandler       状态变更回调处理
 */
+ (void)share:(SSDKPlatformType)platformType
   parameters:(NSMutableDictionary *)parameters
onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler;

@end
