//
//  AGSSUIShareActionSheetItem.m
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/5/5.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "AGSSUIShareActionSheetItem.h"

#import "UIView+BlocksKit.h"
@interface AGSSUIShareActionSheetItem()
@property (nonatomic,strong)UIView *containerView;
@end
@implementation AGSSUIShareActionSheetItem

+(instancetype)itemWithPlatformType:(SSDKPlatformType)platformType{
    AGSSUIShareActionSheetItem *item = [[AGSSUIShareActionSheetItem alloc] init];
    switch (platformType) {
        case SSDKPlatformSubTypeQQFriend:
        {
            item.icon = [[UIImage alloc] init];
            item.icon = [UIImage imageNamed:@"sns_icon_24"];
            item.label = @"QQ好友";
            break;

        }
        case SSDKPlatformSubTypeQZone:{
            item.icon = [UIImage imageNamed:@"sns_icon_6"];
            item.label = @"QQ空间";
            break;

        }
        case SSDKPlatformSubTypeWechatSession:{
            item.icon = [UIImage imageNamed:@"sns_icon_22"];
            item.label = @"微信好友";
            break;

        }
        case SSDKPlatformSubTypeWechatTimeline:{
            item.icon = [UIImage imageNamed:@"sns_icon_23"];
            item.label = @"微信朋友圈";
            break;

        }
        case SSDKPlatformTypeSinaWeibo:{
            item.icon = [UIImage imageNamed:@"sns_icon_1"];
            item.label = @"新浪微博";
            break;
        }
        default:
            break;
    }
   
    return item;
}

+(instancetype)itemWithIcon:(UIImage *)icon label:(NSString *)label onClick:(void (^)())clickHandler{
    AGSSUIShareActionSheetItem *item = [[AGSSUIShareActionSheetItem alloc] init];
    item.icon = icon;
    item.label = label;
    item.containerView = [[UIView alloc] init];
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:icon];
    UILabel *labelLabel = [[UILabel alloc] init];
    [labelLabel setText:label];
    [item.containerView addSubview:iconImageView];
    [item.containerView addSubview:labelLabel];
    [iconImageView bk_whenTapped:^{
        clickHandler();
    }];
    return item;
}

@end
