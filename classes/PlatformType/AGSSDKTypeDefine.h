//
//  AGSSDKTypeDefine.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/20.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AGSSDKUser;
@class AGSSDKContentEntity;

#define AGAPI_WEIXIN_ACCESSTOKEN_URL @"https://api.weixin.qq.com/sns/oauth2/access_token?"    //通过code获取access_token
#define AGAPI_WEIXIN_REFRESH_TOKEN_URL @"https://api.weixin.qq.com/sns/oauth2/refresh_token?"    //刷新或续期access_token使用
#define AGAPI_WEIXIN_IS_ACCESS_TOKEN_URL  @"https://api.weixin.qq.com/sns/auth?" //检验授权凭证（access_token）是否有效
#define AGAPI_WEIXIN_GET_USERINFO_URL @"https://api.weixin.qq.com/sns/userinfo?" //获取用户个人信息
#define AGAPI_WEIBO_GET_USERINFO_URL @"https://api.weibo.com/2/users/show.json"
/**
 *  结合SSO和Web授权方式
 */
extern NSString *const SSDKAuthTypeBoth;
/**
 *  SSO授权方式
 */
extern NSString *const SSDKAuthTypeSSO;
/**
 *  网页授权方式
 */
extern NSString *const SSDKAuthTypeWeb;

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, SSDKPlatformType){
    /**
     *  未知
     */
    SSDKPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    SSDKPlatformTypeSinaWeibo           = 1,
    /**
     *  QQ空间
     */
    SSDKPlatformSubTypeQZone            = 2,
    /**
     *  QQ好友
     */
    SSDKPlatformSubTypeQQFriend         = 3,
    
    /**
     *  微信好友
     */
    SSDKPlatformSubTypeWechatSession    = 4,
    /**
     *  微信朋友圈
     */
    SSDKPlatformSubTypeWechatTimeline   = 5,
    /**
     *  微信收藏
     */
    SSDKPlatformSubTypeWechatFav        = 6,
        /**
     *  微信平台,
     */
    SSDKPlatformTypeWechat              = 997,
    /**
     *  QQ平台
     */
    SSDKPlatformTypeQQ                  = 998,
    /**
     *  任意平台
     */
    SSDKPlatformTypeAny                 = 999
};
/**
 *  回复状态
 */
typedef NS_ENUM(NSUInteger, SSDKResponseState){
    
    /**
     *  开始
     */
    SSDKResponseStateBegin     = 0,
    
    /**
     *  成功
     */
    SSDKResponseStateSuccess    = 1,
    
    /**
     *  失败
     */
    SSDKResponseStateFail       = 2,
    
    /**
     *  取消
     */
    SSDKResponseStateCancel     = 3
};
/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, SSDKContentType){
    
    /**
     *  自动适配类型，视传入的参数来决定
     */
    SSDKContentTypeAuto         = 0,
    
    /**
     *  文本
     */
    SSDKContentTypeText         = 1,
    
    /**
     *  图片
     */
    SSDKContentTypeImage        = 2,
    
    /**
     *  网页
     */
    SSDKContentTypeWebPage      = 3,
    
    /**
     *  应用
     */
    SSDKContentTypeApp          = 4,
    
    /**
     *  音频
     */
    SSDKContentTypeAudio        = 5,
    
    /**
     *  视频
     */
    SSDKContentTypeVideo        = 6,
    
    /**
     *  文件类型(暂时仅微信可用)
     */
    SSDKContentTypeFile         = 7
    
};
/**
 *  配置分享平台回调处理器
 *
 *  @param platformType 需要初始化的分享平台类型
 *  @param appInfo      需要初始化的分享平台应用信息
 */
typedef void(^SSDKConfigurationHandler) (SSDKPlatformType platformType, NSMutableDictionary *appInfo);

/**
 *  导入原平台SDK回调处理器
 *
 *  @param platformType 需要导入原平台SDK的平台类型
 */
typedef void(^SSDKImportHandler) (SSDKPlatformType platformType);

/**
 *  授权视图显示回调处理器
 *
 *  @param view 授权视图
 */
//typedef void(^SSDKAuthorizeViewDisplayHandler) (UIView<ISSDKAuthView> *view);
/**
 *  授权状态变化回调处理器
 *
 *  @param state      状态
 *  @param user       授权用户信息，当且仅当state为SSDKResponseStateSuccess时返回
 *  @param error      错误信息，当且仅当state为SSDKResponseStateFail时返回
 */
typedef void(^SSDKAuthorizeStateChangedHandler) (SSDKResponseState state, AGSSDKUser *user, NSError *error);

/**
 *  获取用户状态变更回调处理器
 *
 *  @param state 状态
 *  @param user  用户信息，当且仅当state为SSDKResponseStateSuccess时返回
 *  @param error 错误信息，当且仅当state为SSDKResponseStateFail时返回
 */
typedef void(^SSDKGetUserStateChangedHandler) (SSDKResponseState state, AGSSDKUser *user, NSError *error);

/**
 *  分享内容状态变更回调处理器
 *
 *  @param state            状态
 *  @param userData         附加数据, 返回状态以外的一些数据描述，如：邮件分享取消时，标识是否保存草稿等
 *  @param contentEntity    分享内容实体,当且仅当state为SSDKResponseStateSuccess时返回
 *  @param error            错误信息,当且仅当state为SSDKResponseStateFail时返回
 */
typedef void(^SSDKShareStateChangedHandler) (SSDKResponseState state, NSDictionary *userData, AGSSDKContentEntity *contentEntity,  NSError *error);
/**
 *  调用API状态变更回调处理器
 *
 *  @param state            状态
 *  @param data             返回数据
 *  @param error            错误信息
 */
typedef void(^SSDKCallApiStateChangedHandler)(SSDKResponseState state, id data, NSError *error);

/**
 *  需要授权回调处理器
 *
 *  @param authorizeStateChangedHandler 授权状态回调
 */
typedef void(^SSDKNeedAuthorizeHandler)(SSDKAuthorizeStateChangedHandler authorizeStateChangedHandler);
