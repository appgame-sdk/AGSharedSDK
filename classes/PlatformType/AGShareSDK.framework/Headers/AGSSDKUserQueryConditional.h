//
//  AGSSDKUserQueryConditional.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/21.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户查询条件
 */
@interface AGSSDKUserQueryConditional : NSObject
/**
 *  创建用户标识查询条件
 *
 *  @param uid 用户标识
 *
 *  @return 查询条件对象
 */
+ (AGSSDKUserQueryConditional *)userQueryConditionalByUserId:(NSString *)uid;

/**
 *  创建用户名称查询条件
 *
 *  @param userName 用户名称
 *
 *  @return 查询条件对象
 */
+ (AGSSDKUserQueryConditional *)userQueryConditionalByUserName:(NSString *)userName;

/**
 *  创建用户路径查询条件
 *
 *  @param path 用户主页路径
 *
 *  @return 查询条件对象
 */
+ (AGSSDKUserQueryConditional *)userQueryConditionalByPath:(NSString *)path;
@end
