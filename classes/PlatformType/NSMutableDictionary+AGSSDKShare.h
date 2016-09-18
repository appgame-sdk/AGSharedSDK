//
//  NSMutableDictionary+AGSSDKShare.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/26.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGSSDKTypeDefine.h"
#import <UIKit/UIKit.h>

#define kAG_WBMessage_Key @"WBMessageKey"
#define kAG_WXMessage_Key @"WXMessageKey"
#define kAG_QQMessage_Key @"QQMessageKey"
#define kAG_QQPlatformSubType_Key @"QQPlatformSubTypeKey"
#define kAG_WXScene_Key @"WXSceneKey"

/**
 *  分享参数构造相关
 */
@interface NSMutableDictionary (AGSSDKShare)
/**
 *  设置分享参数
 *
 *  @param text     文本
 *  @param images   图片集合,传入参数可以为单张图片信息，也可以为一个NSArray，数组元素可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage。如: @"http://www.mob.com/images/logo_black.png" 或 @[@"http://www.mob.com/images/logo_black.png"]
 *  @param url      网页路径/应用路径
 *  @param title    标题
 *  @param type     分享类型
 */
- (void)SSDKSetupShareParamsByText:(NSString *)text
                            images:(id)images
                               url:(NSURL *)url
                             title:(NSString *)title
                              type:(SSDKContentType)type;

/**
 *  设置新浪微博分享参数
 *
 *  @param text      文本
 *  @param title     标题
 *  @param image     图片对象，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 *  @param url       分享链接
 *  @param latitude  纬度
 *  @param longitude 经度
 *  @param objectID  对象ID，标识系统内内容唯一性，应传入系统中分享内容的唯一标识，没有时可以传入nil
 *  @param type      分享类型，仅支持Text、Image、WebPage（客户端分享时）类型
 */
- (void)SSDKSetupSinaWeiboShareParamsByText:(NSString *)text
                                      title:(NSString *)title
                                      image:(id)image
                                        url:(NSURL *)url
                                   latitude:(double)latitude
                                  longitude:(double)longitude
                                   objectID:(NSString *)objectID
                                       type:(SSDKContentType)type;
/**
 *  设置微信分享参数
 *
 *  @param text         文本
 *  @param title        标题
 *  @param url          分享链接
 *  @param thumbImage   缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 *  @param image        图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 *  @param musicFileURL 音乐文件链接地址
 *  @param extInfo      扩展信息
 *  @param fileData     文件数据，可以为NSData、UIImage、NSString、NSURL（文件路径）、SSDKData、SSDKImage
 *  @param emoticonData 表情数据，可以为NSData、UIImage、NSURL（文件路径）、SSDKData、SSDKImage
 *  @param type         分享类型，支持SSDKContentTypeText、SSDKContentTypeImage、SSDKContentTypeWebPage、SSDKContentTypeApp、SSDKContentTypeAudio和SSDKContentTypeVideo
 *  @param platformType 平台子类型，只能传入SSDKPlatformTypeWechatSession、SSDKPlatformTypeWechatTimeline和SSDKPlatformTypeWechatFav其中一个
 *
 *  分享文本时：
 *  设置type为SSDKContentTypeText, 并填入text参数
 *
 *  分享图片时：
 *  设置type为SSDKContentTypeImage, 非gif图片时：填入title和image参数，如果为gif图片则需要填写title和emoticonData参数
 *
 *  分享网页时：
 *  设置type为SSDKContentTypeWebPage, 并设置text、title、url以及thumbImage参数，如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作。
 *
 *  分享应用时：
 *  设置type为SSDKContentTypeApp，并设置text、title、extInfo（可选）以及fileData（可选）参数。
 *
 *  分享音乐时：
 *  设置type为SSDKContentTypeAudio，并设置text、title、url以及musicFileURL（可选）参数。
 *
 *  分享视频时：
 *  设置type为SSDKContentTypeVideo，并设置text、title、url参数
 */
- (void)SSDKSetupWeChatParamsByText:(NSString *)text
                              title:(NSString *)title
                                url:(NSURL *)url
                         thumbImage:(id)thumbImage
                              image:(id)image
                       musicFileURL:(NSURL *)musicFileURL
                            extInfo:(NSString *)extInfo
                           fileData:(id)fileData
                       emoticonData:(id)emoticonData
                               type:(SSDKContentType)type
                 forPlatformSubType:(SSDKPlatformType)platformSubType;

/**
 *  设置微信分享参数
 *
 *  @param text                 文本
 *  @param title                标题
 *  @param url                  分享链接
 *  @param thumbImage           缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 *  @param image                图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 *  @param musicFileURL         音乐文件链接地址
 *  @param extInfo              扩展信息
 *  @param fileData             文件数据，可以为NSData、UIImage、NSString、NSURL（文件路径）、SSDKData、SSDKImage
 *  @param emoticonData         表情数据，可以为NSData、UIImage、NSURL（文件路径）、SSDKData、SSDKImage
 *  @param sourceFileExtension  源文件后缀名
 *  @param sourceFileData       源文件数据，可以为NSData、NSString、NSURL（文件路径）、SSDKData
 *  @param type                 分享类型，支持SSDKContentTypeText、SSDKContentTypeImage、SSDKContentTypeWebPage、SSDKContentTypeApp、SSDKContentTypeAudio和SSDKContentTypeVideo
 *  @param platformType 平台子类型，只能传入SSDKPlatformTypeWechatSession、SSDKPlatformTypeWechatTimeline和SSDKPlatformTypeWechatFav其中一个
 *
 *  分享文本时：
 *  设置type为SSDKContentTypeText, 并填入text参数
 *
 *  分享图片时：
 *  设置type为SSDKContentTypeImage, 非gif图片时：填入title和image参数，如果为gif图片则需要填写title和emoticonData参数
 *
 *  分享网页时：
 *  设置type为SSDKContentTypeWebPage, 并设置text、title、url以及thumbImage参数，如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作。
 *
 *  分享应用时：
 *  设置type为SSDKContentTypeApp，并设置text、title、extInfo（可选）以及fileData（可选）参数。
 *
 *  分享音乐时：
 *  设置type为SSDKContentTypeAudio，并设置text、title、url以及musicFileURL（可选）参数。
 *
 *  分享视频时：
 *  设置type为SSDKContentTypeVideo，并设置text、title、url参数
 *
 *  分享文件时：
 *  设置type为SSDKContentTypeFile（例如.mp3、.mp4、.pdf、.docx的分享），设置title、sourceFileExtension、sourceFileData，以及thumbImage参数，如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作参数
 */
- (void)SSDKSetupWeChatParamsByText:(NSString *)text
                              title:(NSString *)title
                                url:(NSURL *)url
                         thumbImage:(id)thumbImage
                              image:(id)image
                       musicFileURL:(NSURL *)musicFileURL
                            extInfo:(NSString *)extInfo
                           fileData:(id)fileData
                       emoticonData:(id)emoticonData
                sourceFileExtension:(NSString *)fileExtension
                     sourceFileData:(id)sourceFileData
                               type:(SSDKContentType)type
                 forPlatformSubType:(SSDKPlatformType)platformSubType;
/**
 *  设置QQ分享参数
 *
 *  @param text            分享内容
 *  @param title           分享标题
 *  @param url             分享链接
 *  @param thumbImage      缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、NSData
 *  @param image           图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、NSData
 *  @param type            分享类型, 仅支持Text（仅QQFriend）、Image（仅QQFriend）、WebPage、Audio、Video类型
 *  @param platformSubType 平台子类型，只能传入SSDKPlatformSubTypeQZone或者SSDKPlatformSubTypeQQFriend其中一个
 */
- (void)SSDKSetupQQParamsByText:(NSString *)text
                          title:(NSString *)title
                            url:(NSURL *)url
                     thumbImage:(id)thumbImage
                          image:(id)image
                           type:(SSDKContentType)type
             forPlatformSubType:(SSDKPlatformType)platformSubType;

@end
