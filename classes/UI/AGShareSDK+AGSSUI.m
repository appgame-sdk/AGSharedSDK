//
//  AGShareSDK+AGSSUI.m
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/5/5.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "AGShareSDK+AGSSUI.h"
#import "AGSSUIShareActionSheetController.h"
#import "AGSSUIShareActionSheetItem.h"
#import "AGShareSDK/AGShareSDK.h"
@implementation AGShareSDK (AGSSUI)
+(AGSSUIShareActionSheetController *)showShareActionSheet:(UIView *)view items:(NSArray *)items shareParams:(NSMutableDictionary *)shareParams onShareStateChanged:(SSUIShareStateChangedHandler)shareStateChangedHandler{
    NSMutableArray *ShareActionSheetItemArray = [NSMutableArray array];
    for (id platformType in items) {
      SSDKPlatformType platform = [platformType unsignedIntegerValue];
        switch (platform) {
            case SSDKPlatformTypeQQ:
            {
                NSArray *subPlatforms = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeQQFriend],[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeQZone], nil];
                for (id subPlatform in subPlatforms) {
                     AGSSUIShareActionSheetItem *shareActionSheetItem = [AGSSUIShareActionSheetItem itemWithPlatformType:[subPlatform unsignedIntegerValue]];
                    [ShareActionSheetItemArray addObject:shareActionSheetItem];
                }
                break;
            }
            case SSDKPlatformTypeWechat:{
                NSArray *subPlatforms = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatSession],[NSNumber numberWithUnsignedInteger:SSDKPlatformSubTypeWechatTimeline], nil];
                for (id subPlatform in subPlatforms) {
                    AGSSUIShareActionSheetItem *shareActionSheetItem = [AGSSUIShareActionSheetItem itemWithPlatformType:[subPlatform unsignedIntegerValue]];
                    [ShareActionSheetItemArray addObject:shareActionSheetItem];
                }
                break;

            }
            case SSDKPlatformTypeSinaWeibo:{
                AGSSUIShareActionSheetItem *shareActionSheetItem = [AGSSUIShareActionSheetItem itemWithPlatformType:SSDKPlatformTypeSinaWeibo];
                [ShareActionSheetItemArray addObject:shareActionSheetItem];
                break;

            }
            default:
                break;
        }
        
    }
    AGSSUIShareActionSheetController *shareActionSheetController = [[AGSSUIShareActionSheetController alloc] initWithItems:ShareActionSheetItemArray];
    [shareActionSheetController showInView:view];
    __weak typeof (AGSSUIShareActionSheetController*) weakShareActionSheetController = shareActionSheetController;
    [shareActionSheetController onItemClick:^(NSInteger index, AGSSUIShareActionSheetItem *item) {
        if ([item.label isEqualToString:@"QQ好友"]) {
            [AGShareSDK share:SSDKPlatformSubTypeQQFriend parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, AGSSDKContentEntity *contentEntity, NSError *error) {
                shareStateChangedHandler(state,SSDKPlatformSubTypeQQFriend,nil,nil,error,YES);
            }];
        }else if ([item.label isEqualToString:@"QQ空间"]){
            [AGShareSDK share:SSDKPlatformSubTypeQZone parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, AGSSDKContentEntity *contentEntity, NSError *error) {
                shareStateChangedHandler(state,SSDKPlatformSubTypeQZone,nil,nil,error,YES);

            }];
        }else if ([item.label isEqualToString:@"微信好友"]){
            [AGShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, AGSSDKContentEntity *contentEntity, NSError *error) {
                shareStateChangedHandler(state,SSDKPlatformSubTypeWechatSession,nil,nil,error,YES);

                
            }];
        }else if ([item.label isEqualToString:@"微信朋友圈"]){
            [AGShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, AGSSDKContentEntity *contentEntity, NSError *error) {
                shareStateChangedHandler(state,SSDKPlatformSubTypeWechatTimeline,nil,nil,error,YES);

                
            }];
        }else if ([item.label isEqualToString:@"新浪微博"]){
            [AGShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, AGSSDKContentEntity *contentEntity, NSError *error) {
                shareStateChangedHandler(state,SSDKPlatformTypeSinaWeibo,nil,nil,error,YES);

            }];
        }
        [weakShareActionSheetController dismiss];

    }];
    return shareActionSheetController;
}
@end
