//
//  AGSSUIShareActionSheetController.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/5/5.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AGSSUIShareActionSheetItem;
@interface AGSSUIShareActionSheetController : NSObject

/**
 *  分享菜单点击事件
 *
 *  @param index    索引
 *  @param item     菜单项
 */
typedef void (^SSUIShareActionSheetItemClickHandler) (NSInteger index, AGSSUIShareActionSheetItem *item);

/**
 *  分享菜单取消事件
 */
typedef void (^SSUIShareActionSheetCancelHandler) ();
/**
 *  支持点击分享菜单栏平台后直接分享的平台(不显示分享编辑页面)，默认支持微信和QQ平台。
 */
@property (nonatomic, strong) NSMutableSet *directSharePlatforms;

/**
 *  初始化分享菜单
 *
 *  @param items 菜单项集合
 *
 *  @return 分享菜单控制器对象
 */
- (instancetype)initWithItems:(NSArray *)items;

/**
 *  显示分享菜单
 *
 *  @param view     要显示菜单的视图
 */
- (void)showInView:(UIView *)view;

/**
 *  使分享菜单消失
 */
- (void)dismiss;

/**
 *  菜单项点击事件
 *
 *  @param itemClickHandler 菜单项点击事件处理器
 */
- (void)onItemClick:(SSUIShareActionSheetItemClickHandler)itemClickHandler;

/**
 *  分享菜单取消事件
 *
 *  @param cancelHandler 取消事件处理器
 */
- (void)onCancel:(SSUIShareActionSheetCancelHandler)cancelHandler;
@end
