
//
//  AGShareSDK.m
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/21.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "AGShareSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <AFNetworking/AFNetworking.h>

#import "AGSSDKUser.h"
#import "AGSSDKCredential.h"
#import "AGSharedSDKError.h"
#import "NSMutableDictionary+AGSSDKShare.h"
#import "ViewController.h"
@interface AGShareSDK ()<TencentSessionDelegate,WXApiDelegate,WeiboSDKDelegate,WBHttpRequestDelegate>
{
    NSArray *_permissions;
}
@property (nonatomic,strong)NSMutableDictionary *appInfo;
@property (nonatomic,strong)TencentOAuth *tencentOAuth;
@property (nonatomic,strong)NSDictionary *platformInfoDic;
@property (nonatomic,assign)SSDKPlatformType platformType;
@property (nonatomic,assign)SSDKResponseState responseState;
@property (nonatomic,assign)SSDKCredentialType credentialType; //授权类型
@property (nonatomic,strong)SendAuthResp *authResp;
@property (nonatomic,strong)NSString *weixin_refresh_token;
@property (nonatomic,strong)NSString *weixin_access_token;
@property (nonatomic,strong)NSString *weixin_openid;
@property (nonatomic,strong)NSString *wbtoken;
@property (nonatomic,strong)NSString *wbCurrentUserID;
@property (nonatomic,strong)NSString *wbRefreshToken;
@property (nonatomic,copy)SSDKAuthorizeStateChangedHandler stateChangedHandler;
@property (nonatomic,copy)SSDKShareStateChangedHandler shareStateChangedHandler;

- (QQApiSendResultCode)resultCodeWithReq:(SendMessageToQQReq*)req withPlatformSubType:(SSDKPlatformType)platformSubType;
@end
@implementation AGShareSDK

+ (AGShareSDK *)sharedAGShareSDK
{
    static AGShareSDK *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.appInfo = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

+ (void)registerAppWithActivePlatforms:(NSArray *)activePlatforms onConfiguration:(SSDKConfigurationHandler)configurationHandler{
    NSMutableDictionary *appInfo = [AGShareSDK sharedAGShareSDK].appInfo;
    for (NSNumber *type in activePlatforms) {
        SSDKPlatformType platformType = [type unsignedIntegerValue];
        configurationHandler(platformType,appInfo);
        }
}
+ (void)authorize:(SSDKPlatformType)platformType settings:(NSDictionary *)settings onStateChanged:(SSDKAuthorizeStateChangedHandler)stateChangedHandler{
    stateChangedHandler(SSDKResponseStateBegin,nil,nil);
    [AGShareSDK sharedAGShareSDK].stateChangedHandler = stateChangedHandler;
    [AGShareSDK sharedAGShareSDK].platformInfoDic = [[AGShareSDK sharedAGShareSDK].appInfo objectForKey:[NSNumber numberWithUnsignedInteger:platformType]];
    [AGShareSDK sharedAGShareSDK].platformType = platformType;
    switch (platformType) {
        case SSDKPlatformTypeQQ:{
                NSString *appId = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"appId"];
                [AGShareSDK sharedAGShareSDK].tencentOAuth = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"TencentOAuth"];
                [AGShareSDK sharedAGShareSDK].tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:[AGShareSDK sharedAGShareSDK]];
                NSString *authType = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"authType"];
                if ([authType isEqualToString:SSDKAuthTypeSSO] || [authType isEqualToString:SSDKAuthTypeBoth]) {
                    NSArray* permissions = [NSArray arrayWithObjects:
                                            kOPEN_PERMISSION_GET_USER_INFO,
                                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                            kOPEN_PERMISSION_ADD_SHARE,
                                            nil];
                    //用户授权登录
                    [[AGShareSDK sharedAGShareSDK].tencentOAuth authorize:permissions inSafari:NO];
                    
                }else if([authType isEqualToString:SSDKAuthTypeWeb]){
                    
                }
            break;
  
        }
        case SSDKPlatformTypeWechat:{
            [[AGShareSDK sharedAGShareSDK] sendAuthRequest];
            break;

        }
        case SSDKPlatformTypeSinaWeibo:{
            [[AGShareSDK sharedAGShareSDK] weiboSendRequest];
            break;
        }
            
        default:
            break;
    }
}

+(BOOL)hasAuthorized:(SSDKPlatformType)platformTypem{
    switch (platformTypem) {
        case SSDKPlatformTypeQQ:
        {
           TencentAuthorizeState *state = [TencentOAuth authorizeState];
            if (kTencentNotAuthorizeState == state) {
                return  NO;
            }else{
                return YES;
            }
            break;

        }
        case SSDKPlatformTypeWechat:{
            if ([AGShareSDK sharedAGShareSDK].weixin_access_token) {
                return YES;

            }else{
                return NO;

            }
            break;

        }
        case SSDKPlatformTypeSinaWeibo:{
            if ([AGShareSDK sharedAGShareSDK].wbtoken) {
                return YES;
            }else{
                return NO;
            }
            break;
        }
        default:
            return NO;
            break;
    }
}

+ (void)cancelAuthorize:(SSDKPlatformType)platformType{
    switch (platformType) {
        case SSDKPlatformTypeQQ:{
            if (nil != [AGShareSDK sharedAGShareSDK].tencentOAuth
                ){
                [[AGShareSDK sharedAGShareSDK].tencentOAuth logout:nil];
            }
            break;
        }
        case SSDKPlatformTypeWechat:{
            [AGShareSDK sharedAGShareSDK].weixin_access_token = nil;
            break;

        }
        case SSDKPlatformTypeSinaWeibo:{
             [WeiboSDK logOutWithToken:[AGShareSDK sharedAGShareSDK].wbtoken delegate:[AGShareSDK sharedAGShareSDK] withTag:@"user1"];
            break;
        }
        default:
            break;
    }
}

+ (void)getUserInfo:(SSDKPlatformType)platformType onStateChanged:(SSDKGetUserStateChangedHandler)stateChangedHandler{
    stateChangedHandler(SSDKResponseStateBegin,nil,nil);
    if (![AGShareSDK sharedAGShareSDK].platformInfoDic) {
        [AGShareSDK sharedAGShareSDK].platformInfoDic = [[AGShareSDK sharedAGShareSDK].appInfo objectForKey:[NSNumber numberWithUnsignedInteger:platformType]];
    }
    switch (platformType) {
        case SSDKPlatformTypeQQ:{
            if ([AGShareSDK sharedAGShareSDK].tencentOAuth) {
                [[AGShareSDK sharedAGShareSDK].tencentOAuth getUserInfo];
            }else if([AGShareSDK sharedAGShareSDK].platformInfoDic){
                [AGShareSDK sharedAGShareSDK].tencentOAuth = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"TencentOAuth"];
                NSString *appId = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"appId"];
                [AGShareSDK sharedAGShareSDK].tencentOAuth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:[AGShareSDK sharedAGShareSDK]];
                NSArray* permissions = [NSArray arrayWithObjects:
                                        kOPEN_PERMISSION_GET_USER_INFO,
                                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                        kOPEN_PERMISSION_ADD_SHARE,
                                        nil];
                //用户授权登录
                [[AGShareSDK sharedAGShareSDK].tencentOAuth authorize:permissions inSafari:NO];
//                [[AGShareSDK sharedAGShareSDK].tencentOAuth getUserInfo];

            }else{
                [AGShareSDK sharedAGShareSDK].platformInfoDic = [[AGShareSDK sharedAGShareSDK].appInfo objectForKey:[NSNumber numberWithUnsignedInteger:platformType]];
                [AGShareSDK sharedAGShareSDK].tencentOAuth = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"TencentOAuth"];
                
                
            }
            break;

        }
        case SSDKPlatformTypeWechat:{
            [[AGShareSDK sharedAGShareSDK] sendAuthRequest];
            break;
        }
        case SSDKPlatformTypeSinaWeibo:
        {
            [[AGShareSDK sharedAGShareSDK] weiboSendRequest];
            break;

        }
            
        default:
            break;
    }
    [AGShareSDK sharedAGShareSDK].stateChangedHandler = stateChangedHandler;

}

+(void)share:(SSDKPlatformType)platformType parameters:(NSMutableDictionary *)parameters onStateChanged:(SSDKShareStateChangedHandler)stateChangedHandler{
    [AGShareSDK sharedAGShareSDK].shareStateChangedHandler = stateChangedHandler;
    stateChangedHandler(SSDKResponseStateBegin,nil,nil,nil);
    switch (platformType) {
        case SSDKPlatformTypeQQ:{
            SendMessageToQQReq* req = [parameters objectForKey:kAG_QQMessage_Key];
            SSDKPlatformType subPlatform = [[parameters objectForKey:kAG_QQPlatformSubType_Key] unsignedIntegerValue];
            QQApiSendResultCode send = [[AGShareSDK sharedAGShareSDK] resultCodeWithReq:req withPlatformSubType:subPlatform];
            [[AGShareSDK sharedAGShareSDK] handleSendResult:send];
            break;

        }
        case SSDKPlatformSubTypeQQFriend:{
            SendMessageToQQReq* req = [parameters objectForKey:kAG_QQMessage_Key];
            QQApiSendResultCode send = [[AGShareSDK sharedAGShareSDK] resultCodeWithReq:req withPlatformSubType:platformType];
            [[AGShareSDK sharedAGShareSDK] handleSendResult:send];
            break;
            
        }
        case SSDKPlatformSubTypeQZone:{
            SendMessageToQQReq* req = [parameters objectForKey:kAG_QQMessage_Key];
            QQApiSendResultCode send = [[AGShareSDK sharedAGShareSDK] resultCodeWithReq:req withPlatformSubType:platformType];
            [[AGShareSDK sharedAGShareSDK] handleSendResult:send];
            break;
            
        }
        case SSDKPlatformTypeWechat:{
            SendMessageToWXReq* req = [parameters objectForKey:kAG_WXMessage_Key];
            BOOL success = [WXApi sendReq:req];
            if (success) {
                stateChangedHandler(SSDKResponseStateSuccess,nil,nil,nil);
            }else{
                NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorUnknowError userInfo:@{NSLocalizedDescriptionKey:@"分享失败"}];
                stateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            }
            break;

        }
        case SSDKPlatformSubTypeWechatSession:{
            SendMessageToWXReq* req = [parameters objectForKey:kAG_WXMessage_Key];
            req.scene = WXSceneSession;

            BOOL success = [WXApi sendReq:req];
            if (success) {
                stateChangedHandler(SSDKResponseStateSuccess,nil,nil,nil);
            }else{
                NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorUnknowError userInfo:@{NSLocalizedDescriptionKey:@"分享失败"}];
                stateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            }
            break;
            
        }
        case SSDKPlatformSubTypeWechatTimeline:{
            SendMessageToWXReq* req = [parameters objectForKey:kAG_WXMessage_Key];
            req.scene = WXSceneTimeline;

            BOOL success = [WXApi sendReq:req];
            if (success) {
                stateChangedHandler(SSDKResponseStateSuccess,nil,nil,nil);
            }else{
                NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorUnknowError userInfo:@{NSLocalizedDescriptionKey:@"分享失败"}];
                stateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            }
            break;
            
        }
        case SSDKPlatformTypeSinaWeibo:{
            WBMessageObject *message = [parameters objectForKey:kAG_WBMessage_Key];
            WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
            //    authRequest.redirectURI = kRedirectURI;
            authRequest.scope = @"all";
            //第三方应用发送消息至微博客户端程序的消息结构体
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
            request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
            BOOL success = [WeiboSDK sendRequest:request];
            if (success) {
                stateChangedHandler(SSDKResponseStateSuccess,nil,nil,nil);
            }else{
                NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorUnknowError userInfo:@{NSLocalizedDescriptionKey:@"分享失败"}];
                stateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            }

            break;

        }
            
        default:
            break;
    }
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin
{
    if ([AGShareSDK sharedAGShareSDK].tencentOAuth.accessToken && [AGShareSDK sharedAGShareSDK].tencentOAuth.accessToken.length != 0) {
        [AGShareSDK sharedAGShareSDK].responseState = SSDKResponseStateSuccess;
        //获取用户信息
        [[AGShareSDK sharedAGShareSDK].tencentOAuth getUserInfo];
    }
    NSLog(@"%s",__FUNCTION__);
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled) {
        [AGShareSDK sharedAGShareSDK].responseState = SSDKResponseStateCancel;
        NSError *error = [NSError errorWithDomain:AGErrorDomain  code:AGErrorCodeUserCancelLogin  userInfo:@{NSLocalizedDescriptionKey:@"用户退出登录"}];
        [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateCancel,nil,error);
    }else{
        [AGShareSDK sharedAGShareSDK].responseState = SSDKResponseStateFail;
        NSError *error = [NSError errorWithDomain:AGErrorDomain  code:AGErrorUnknowError  userInfo:@{NSLocalizedDescriptionKey:@"登录失败"}];
        [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateFail,nil,error);
    }

    NSLog(@"%s",__FUNCTION__);

}

- (void)tencentDidNotNetWork
{
    [AGShareSDK sharedAGShareSDK].responseState = SSDKResponseStateFail;
    NSError *error = [NSError errorWithDomain:AGErrorDomain  code:AGErrorCodeNetworkNotAvailable  userInfo:@{NSLocalizedDescriptionKey:@"网络错误"}];
    [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateFail,nil,error);
    NSLog(@"%s",__FUNCTION__);

}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams{
    NSLog(@"%s",__FUNCTION__);

    return nil;
}
//获取用户个人信息回调
- (void)getUserInfoResponse:(APIResponse *)response{
    if (URLREQUEST_SUCCEED == response.retCode && kOpenSDKErrorSuccess == response.detailRetCode) {
        AGSSDKUser *ssdkUser = [[AGSSDKUser alloc] init];
        ssdkUser.platformType = SSDKPlatformTypeQQ;
        ssdkUser.credential = [[AGSSDKCredential alloc] init];
        ssdkUser.credential.uid = [AGShareSDK sharedAGShareSDK].tencentOAuth.openId;
        ssdkUser.credential.token = [AGShareSDK sharedAGShareSDK].tencentOAuth.accessToken;
        ssdkUser.credential.expired = [AGShareSDK sharedAGShareSDK].tencentOAuth.expirationDate;
        NSDictionary *jsonResponse = [response jsonResponse];
        ssdkUser.nickname = [jsonResponse objectForKey:@"nickname"];
        ssdkUser.icon = [jsonResponse objectForKey:@"figureurl_qq_2"];
        if ([[jsonResponse objectForKey:@"gender"] isEqualToString:@"男"]) {
            ssdkUser.gender = SSDKGenderMale;
        }else if ([[jsonResponse objectForKey:@"gender"] isEqualToString:@"女"]){
            ssdkUser.gender = SSDKGenderFemale;
        }else{
            ssdkUser.gender = SSDKGenderUnknown;
        }
        ssdkUser.level = (NSInteger)[jsonResponse objectForKey:@"level"];
        [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateSuccess,ssdkUser,nil);
    }
}
#pragma mark - 腾讯分享获得分享的结果状态值
- (QQApiSendResultCode)resultCodeWithReq:(SendMessageToQQReq*)req withPlatformSubType:(SSDKPlatformType)platformSubType{
    QQApiSendResultCode sent;
    //分享到QQ好友
    if (platformSubType == SSDKPlatformSubTypeQQFriend) {
        sent = [QQApiInterface sendReq:req];
    }else{
        //将内容分享到qzone
        sent = [QQApiInterface SendReqToQZone:req];
    }
    return sent;
}
- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPISENDSUCESS:{
            [AGShareSDK sharedAGShareSDK].shareStateChangedHandler(SSDKResponseStateSuccess,nil,nil,nil);
            break;
        }
        case EQQAPIAPPNOTREGISTED:
        {
           NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorCodeAPPNotRegistered userInfo:@{NSLocalizedDescriptionKey:@"App未注册"}];
            [AGShareSDK sharedAGShareSDK].shareStateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorCodeAPIParameterError userInfo:@{NSLocalizedDescriptionKey:@"发送参数错误"}];
            [AGShareSDK sharedAGShareSDK].shareStateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorCodeAPPNotInstall userInfo:@{NSLocalizedDescriptionKey:@"未安装手Q"}];
            [AGShareSDK sharedAGShareSDK].shareStateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorCodeAPINotSupport userInfo:@{NSLocalizedDescriptionKey:@"API接口不支持"}];
            [AGShareSDK sharedAGShareSDK].shareStateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            break;
        }
        case EQQAPISENDFAILD:
        {
            NSError *error = [NSError errorWithDomain:AGErrorDomain code:AGErrorUnknowError userInfo:@{NSLocalizedDescriptionKey:@"发送失败"}];
            [AGShareSDK sharedAGShareSDK].shareStateChangedHandler(SSDKResponseStateFail,nil,nil,error);
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - 微信应用授权登录
-(void)sendAuthRequest
{
    //构造SendAuthReq结构体 OAuth2.0授权登录
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    ViewController *vc = [[ViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:vc.view];
    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:vc.view];
//    [WXApi sendAuthReq:req viewController:[UIApplication sharedApplication].keyWindow.rootViewController delegate:[AGShareSDK sharedAGShareSDK]];
    [WXApi sendReq:req];

}
#pragma mark - WXApiDelegate
//收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
-(void) onReq:(BaseReq*)req{
    
}
//发送一个sendReq后，收到微信的回应
-(void) onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
        [AGShareSDK sharedAGShareSDK].authResp = authResp;
        NSString *appId = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"appId"];
        NSString *appSecret = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"appSecret"];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (appId) {
            [parameters setObject:appId forKey:@"appid"];
        }
        if (appSecret) {
            [parameters setObject:appSecret forKey:@"secret"];

        }
        if (authResp.code) {
            [parameters setObject:authResp.code forKey:@"code"];
        }
        [parameters setObject:@"authorization_code" forKey:@"grant_type"];
        // 通过code获取access_token
        [[AFHTTPSessionManager manager] GET:AGAPI_WEIXIN_ACCESSTOKEN_URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseDic = responseObject;
            [AGShareSDK sharedAGShareSDK].weixin_access_token = [responseDic objectForKey:@"refresh_token"];
            [AGShareSDK sharedAGShareSDK].weixin_access_token = [responseDic objectForKey:@"access_token"];
            [AGShareSDK sharedAGShareSDK].weixin_openid = [responseDic objectForKey:@"openid"];
            [self getWeiXinUserinfo];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error：%@",error.description);
        }];
        
        }
}
- (void)WeixinRefreshToken{
    //            刷新或续期access_token
    NSString *appId = [[AGShareSDK sharedAGShareSDK].platformInfoDic  objectForKey:@"appId"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (appId) {
        [parameters setObject:appId forKey:@"appid"];
    }
    [parameters setObject:@"refresh_token" forKey:@"grant_type"];
    if ([AGShareSDK sharedAGShareSDK].weixin_refresh_token) {
        [parameters setObject:[AGShareSDK sharedAGShareSDK].weixin_refresh_token forKey:@"refresh_token"];
    }
    [[AFHTTPSessionManager manager] GET:AGAPI_WEIXIN_REFRESH_TOKEN_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSLog(@"SUB responseObject:%@",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"SUB error:%@",error.description);
        
    }];

}
#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            [AGShareSDK sharedAGShareSDK].wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            [AGShareSDK sharedAGShareSDK].wbCurrentUserID = userID;
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        [AGShareSDK sharedAGShareSDK].wbtoken = [(WBAuthorizeResponse *)response accessToken];
        [AGShareSDK sharedAGShareSDK].wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        [AGShareSDK sharedAGShareSDK].wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
    }
    else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        if (accessToken)
        {
            [AGShareSDK sharedAGShareSDK].wbtoken = accessToken;
        }
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        if (userID) {
            [AGShareSDK sharedAGShareSDK].wbCurrentUserID = userID;
        }
    }
    [self getWeiboUserinfo:^(AGSSDKUser *user, NSError *error) {
        
    }];
}

- (void)getWeiXinUserinfo{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if ([AGShareSDK sharedAGShareSDK].weixin_access_token) {
        [parameters setObject:[AGShareSDK sharedAGShareSDK].weixin_access_token forKey:@"access_token"];
    }
    if ([AGShareSDK sharedAGShareSDK].weixin_openid) {
        [parameters setObject:[AGShareSDK sharedAGShareSDK].weixin_openid forKey:@"openid"];
    }
    [[AFHTTPSessionManager manager] GET:AGAPI_WEIXIN_GET_USERINFO_URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if ([responseObject objectForKey:@"errcode"]) {
            NSError *error = [NSError errorWithDomain:AGErrorDomain  code:AGErrorCodeInvalidOpenid  userInfo:@{NSLocalizedDescriptionKey:[responseObject objectForKey:@"errmsg"]}];
            [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateFail,nil,error);
            
        }else{
            AGSSDKUser *user = [[AGSSDKUser alloc] init];
            user.platformType = SSDKPlatformTypeWechat;
            user.city = [responseObject objectForKey:@"city"];
            user.country = [responseObject objectForKey:@"country"];
            user.icon = [responseObject objectForKey:@"headimgurl"];
            user.nickname = [responseObject objectForKey:@"nickname"];
            user.uid = [responseObject objectForKey:@"openid"];
            if ([[responseObject objectForKey:@"sex"] integerValue] == 1) {
                user.gender = SSDKGenderMale;
            }else if ([[responseObject objectForKey:@"sex"] integerValue] == 2){
                user.gender = SSDKGenderFemale;
            }else{
                user.gender = SSDKGenderUnknown;
                
            }
            [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateSuccess,user,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateFail,nil,error);
        
    }];

}

- (void)weiboSendRequest{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    NSString *redirectURI = [[AGShareSDK sharedAGShareSDK].platformInfoDic objectForKey:@"redirectUri"];
    request.redirectURI = redirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

#pragma mark - WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    if ([request.url isEqualToString:@"https://api.weibo.com/oauth2/revokeoauth2"]) {
        [AGShareSDK sharedAGShareSDK].wbtoken = nil;
    }
    NSString *title = nil;
    title = NSLocalizedString(@"收到网络回调", nil);
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    title = NSLocalizedString(@"请求异常", nil);
}
- (void)getWeiboUserinfo:(void(^)(AGSSDKUser *user,NSError *error))block{
    //根据用户ID获取用户信息
    if ([AGShareSDK sharedAGShareSDK].wbtoken && [AGShareSDK sharedAGShareSDK].wbCurrentUserID) {
        [WBHttpRequest requestWithAccessToken:[AGShareSDK sharedAGShareSDK].wbtoken url:AGAPI_WEIBO_GET_USERINFO_URL httpMethod:@"GET" params:@{@"access_token":[AGShareSDK sharedAGShareSDK].wbtoken,@"uid":[AGShareSDK sharedAGShareSDK].wbCurrentUserID} queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
            if (result) {
                AGSSDKUser *user = [[AGSSDKUser alloc] init];
                user.uid = [result objectForKey:@"idstr"];
                user.nickname = [result objectForKey:@"screen_name"];
                user.city = [result objectForKey:@"city"];
                user.country = [result objectForKey:@"location"];
                user.icon = [result objectForKey:@"profile_image_url"];
                if ([[result objectForKey:@"gender"] isEqualToString:@"m"]) {
                    user.gender = SSDKGenderMale;
                }else if ([[result objectForKey:@"gender"] isEqualToString:@"f"]){
                    user.gender = SSDKGenderFemale;
                }else{
                    user.gender = SSDKGenderUnknown;
                }
                user.url = [result objectForKey:@"url"];
                user.followerCount = [[result objectForKey:@"followers_count"] integerValue];
                user.friendCount = [[result objectForKey:@"friends_count"] integerValue];
                user.shareCount = [[result objectForKey:@"statuses_count"] integerValue];
                user.regAt = [[result objectForKey:@"created_at"] doubleValue];
                [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateSuccess,user,nil);
                block(user,nil);
            }else{
                [AGShareSDK sharedAGShareSDK].stateChangedHandler(SSDKResponseStateFail,nil,error);
                block(nil,error);
            }
        }];

    }
    
}
@end
