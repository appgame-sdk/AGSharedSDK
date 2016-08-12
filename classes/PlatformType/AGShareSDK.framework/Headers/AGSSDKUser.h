//
//  AGSSDKUser.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/20.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSSDKTypeDefine.h"
@class AGSSDKCredential;
/**
 *  性别
 */
typedef NS_ENUM(NSUInteger, SSDKGender){
    /**
     *  男
     */
    SSDKGenderMale      = 0,
    /**
     *  女
     */
    SSDKGenderFemale    = 1,
    /**
     *  未知
     */
    SSDKGenderUnknown   = 2,
};


@interface AGSSDKUser : NSObject
/**
 *  平台类型
 */
@property (nonatomic) SSDKPlatformType platformType;

/**
 *  授权凭证， 为nil则表示尚未授权
 */
@property (nonatomic, retain) AGSSDKCredential *credential;

/**
 *  用户标识
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  城市
 */
@property (nonatomic, copy) NSString *city;
/**
 *  国家
 */
@property (nonatomic, copy) NSString *country;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  性别
 */
@property (nonatomic) SSDKGender gender;

/**
 *  用户主页
 */
@property (nonatomic, copy) NSString *url;

/**
 *  用户简介
 */
@property (nonatomic, copy) NSString *aboutMe;

/**
 *  认证用户类型
 */
@property (nonatomic) NSInteger verifyType;

/**
 *  认证描述
 */
@property (nonatomic, copy) NSString *verifyReason;

/**
 *  生日
 */
@property (nonatomic, strong) NSDate *birthday;

/**
 *  粉丝数
 */
@property (nonatomic) NSInteger followerCount;

/**
 *  好友数
 */
@property (nonatomic) NSInteger friendCount;

/**
 *  分享数
 */
@property (nonatomic) NSInteger shareCount;

/**
 *  注册时间
 */
@property (nonatomic) NSTimeInterval regAt;

/**
 *  用户等级
 */
@property (nonatomic) NSInteger level;

/**
 *  教育信息
 */
@property (nonatomic, retain) NSArray *educations;

/**
 *  职业信息
 */
@property (nonatomic, retain) NSArray *works;

/**
 *  原始数据
 */
@property (nonatomic, retain) NSDictionary *rawData;

@end
