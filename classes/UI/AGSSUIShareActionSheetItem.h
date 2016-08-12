//
//  AGSSUIShareActionSheetItem.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/5/5.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AGShareSDK/AGSSDKTypeDefine.h"

@interface AGSSUIShareActionSheetItem : NSObject
{
    UIImage *_icon;
    NSString *_label;
}

/**
 *  图标
 */
@property (nonatomic, strong) UIImage *icon;

/**
 *  标签
 */
@property (nonatomic, copy) NSString *label;

/**
 *  创建平台分享菜单项
 *
 *  @param platformType 平台类型
 *  @param index 数组下标
 *
 *  @return 分享菜单项
 */
+ (instancetype)itemWithPlatformType:(SSDKPlatformType)platformType;

/**
 *  创建自定义分享菜单项
 *
 *  @param icon         图标
 *  @param label        标签
 *  @param clickHandler 点击事件处理
 *
 *  @return 分享菜单项
 */
+ (instancetype)itemWithIcon:(UIImage *)icon label:(NSString *)label onClick:(void(^)())clickHandler;
@end
