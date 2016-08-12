//
//  AGShareSDK+AGSSUI.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/5/5.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "AGShareSDK/AGShareSDK.h"
@class AGSSUIShareActionSheetController;
@class AGSSDKContentEntity;

/**
 *  分享状态变更
 *
 *  @param state         返回状态
 *  @param platformType  平台类型
 *  @param userData      用户数据
 *  @param contentEntity 分享内容实体
 *  @param error         错误信息
 *  @param end           是否已经结束本次分享标识
 */
typedef void (^SSUIShareStateChangedHandler) (SSDKResponseState state,
                                              SSDKPlatformType platformType,
                                              NSDictionary *userData,
                                              AGSSDKContentEntity *contentEntity,
                                              NSError *error,
                                              BOOL end);

@interface AGShareSDK (AGSSUI)
/**
 *  显示分享菜单
 *
 *  @param view                     要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图
 *  @param items                    菜单项，如果传入nil，则显示已集成的平台列表
 *  @param shareParams              分享内容参数
 *  @param shareStateChangedHandler 分享状态变更事件
 *
 *  @return 分享菜单控制器
 */
+ (AGSSUIShareActionSheetController *)showShareActionSheet:(UIView *)view
                                                   items:(NSArray *)items
                                             shareParams:(NSMutableDictionary *)shareParams
                                     onShareStateChanged:(SSUIShareStateChangedHandler)shareStateChangedHandler;


@end
