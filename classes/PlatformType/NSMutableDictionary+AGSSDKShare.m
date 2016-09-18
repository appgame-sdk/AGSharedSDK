//
//  NSMutableDictionary+AGSSDKShare.m
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/26.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import "NSMutableDictionary+AGSSDKShare.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <NYXImagesKit/NYXImagesKit.h>
#import "AGSSDKContentEntity.h"


@implementation NSMutableDictionary (AGSSDKShare)

- (void)SSDKSetupShareParamsByText:(NSString *)text images:(id)images url:(NSURL *)url title:(NSString *)title type:(SSDKContentType)type{
    
}

- (void)SSDKSetupSinaWeiboShareParamsByText:(NSString *)text title:(NSString *)title image:(id)image url:(NSURL *)url latitude:(double)latitude longitude:(double)longitude objectID:(NSString *)objectID type:(SSDKContentType)type{
    WBMessageObject *message = [WBMessageObject message];
    switch (type) {
        case SSDKContentTypeText:
        {
            message.text = text;
            break;

        }
        case SSDKContentTypeImage:{
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = [self receiveDataWithImage:image];
            message.imageObject = imageObject;
            break;

        }
        case SSDKContentTypeWebPage:{
            WBWebpageObject *webpage = [WBWebpageObject object];
            webpage.objectID = objectID;
            webpage.title = title;
            webpage.description = text;
            webpage.thumbnailData = [self receiveDataWithImage:image];
            webpage.webpageUrl = [url absoluteString];
            message.mediaObject = webpage;
            break;

        }
        default:
            break;
    }
    [self setObject:message forKey:kAG_WBMessage_Key];
      
}

- (void)SSDKSetupQQParamsByText:(NSString *)text title:(NSString *)title url:(NSURL *)url thumbImage:(id)thumbImage image:(id)image type:(SSDKContentType)type forPlatformSubType:(SSDKPlatformType)platformSubType{
//    AGSSDKContentEntity *contentEntity = [[AGSSDKContentEntity alloc] init];
//    contentEntity.text = text;
//    contentEntity.images = @[image];
//    contentEntity.urls = @[url];
    SendMessageToQQReq* req;
       switch (type) {
        case SSDKContentTypeText:
        {
            QQApiTextObject* txtObj = [QQApiTextObject objectWithText:text];
            req = [SendMessageToQQReq reqWithContent:txtObj];
            break;

        }
        case SSDKContentTypeImage:{
            NSData *thumbImageData = [self receiveDataWithImage:thumbImage];
            NSData *imageData = [self receiveDataWithImage:image];
            QQApiImageObject* imgObj = [QQApiImageObject objectWithData:thumbImageData previewImageData:imageData title:title description:text];
            req = [SendMessageToQQReq reqWithContent:imgObj];
            break;

        }
        case SSDKContentTypeWebPage:{
            NSURL *thumbImageURL = nil;
            NSData *thumbImageData = nil;
            QQApiNewsObject* newsObject = nil;
            if ([thumbImage isKindOfClass:[NSString class]]) {
                thumbImageURL = [NSURL URLWithString:thumbImage];
                newsObject = [QQApiNewsObject objectWithURL:url title:title description:text previewImageURL:thumbImageURL];
            }else if ([thumbImage isKindOfClass:[NSURL class]]){
                thumbImageURL = thumbImage;
                newsObject = [QQApiNewsObject objectWithURL:url title:title description:text previewImageURL:thumbImageURL];
            }else if ([thumbImage isKindOfClass:[UIImage class]]){
                thumbImageData = UIImagePNGRepresentation(thumbImage);
                //分享新闻消息本地图片
                newsObject = [QQApiNewsObject objectWithURL:url title:title description:text previewImageData:thumbImageData];
            }else if ([thumbImage isKindOfClass:[NSData class]]){
                thumbImageData = thumbImage;
                newsObject = [QQApiNewsObject objectWithURL:url title:title description:text previewImageData:thumbImageData];
            }
            req = [SendMessageToQQReq reqWithContent:newsObject];
            break;

        }
        case SSDKContentTypeAudio:{
            NSData* thumbImageData = [self receiveDataWithImage:thumbImage];
            QQApiAudioObject* audioObject = [QQApiAudioObject objectWithURL:url title:title description:text previewImageData:thumbImageData];
            req = [SendMessageToQQReq reqWithContent:audioObject];
//            sent = [self reqWithContent:audioObject withPlatformSubType:platformSubType];
            break;


        }
        case SSDKContentTypeVideo:{
            QQApiNewsObject* newsObject = nil;
            if ([thumbImage isKindOfClass:[NSURL class]]) {
                newsObject = [QQApiNewsObject objectWithURL:url title:title description:text previewImageURL:thumbImage];
            }else if([thumbImage isKindOfClass:[NSString class]]){
                newsObject = [QQApiNewsObject objectWithURL:url title:title description:text previewImageURL:[NSURL URLWithString:thumbImage]];
            }else{
                NSData *thumbImageData = [self receiveDataWithImage:thumbImage];
                newsObject = [QQApiNewsObject objectWithURL:url title:title description:text previewImageData:thumbImageData];
            }
            req = [SendMessageToQQReq reqWithContent:newsObject];
            break;

        }
        default:
            break;
    }
    [self setObject:req forKey:kAG_QQMessage_Key];
    [self setObject:[NSNumber numberWithUnsignedInteger:platformSubType] forKey:kAG_QQPlatformSubType_Key];

}

- (void)SSDKSetupWeChatParamsByText:(NSString *)text title:(NSString *)title url:(NSURL *)url thumbImage:(id)thumbImage image:(id)image musicFileURL:(NSURL *)musicFileURL extInfo:(NSString *)extInfo fileData:(id)fileData emoticonData:(id)emoticonData type:(SSDKContentType)type forPlatformSubType:(SSDKPlatformType)platformSubType{
    [self SSDKSetupWeChatParamsByText:text title:title url:url thumbImage:thumbImage image:image musicFileURL:musicFileURL extInfo:extInfo fileData:fileData emoticonData:emoticonData sourceFileExtension:nil sourceFileData:nil type:type forPlatformSubType:platformSubType];
}

- (void)SSDKSetupWeChatParamsByText:(NSString *)text title:(NSString *)title url:(NSURL *)url thumbImage:(id)thumbImage image:(id)image musicFileURL:(NSURL *)musicFileURL extInfo:(NSString *)extInfo fileData:(id)fileData emoticonData:(id)emoticonData sourceFileExtension:(NSString *)fileExtension sourceFileData:(id)sourceFileData type:(SSDKContentType)type forPlatformSubType:(SSDKPlatformType)platformSubType{
    enum WXScene scene = WXSceneSession;
    SendMessageToWXReq* req = nil;
    switch (platformSubType) {
        case SSDKPlatformSubTypeWechatSession:
        {
            scene = WXSceneSession;
            break;

        }
        case SSDKPlatformSubTypeWechatTimeline:{
            scene = WXSceneTimeline;
            break;

        }
        case SSDKPlatformSubTypeWechatFav:{
            scene = WXSceneFavorite;
            break;


        }
            
        default:
            break;
    }
    switch (type) {
        case SSDKContentTypeText:
        {
            req = [self requestWithText:text
                                                           OrMediaMessage:nil
                                                                    bText:YES
                                                                  InScene:scene];
            break;

        }
        case SSDKContentTypeImage:{
            WXMediaMessage *message = nil;
            //是否为表情数据
            if (emoticonData) {
                WXEmoticonObject *ext = [WXEmoticonObject object];
                ext.emoticonData = emoticonData;
                message = [self messageWithTitle:nil
                                     Description:nil
                                          Object:ext
                                      MessageExt:nil
                                   MessageAction:nil
                                      ThumbImage:thumbImage
                                        MediaTag:nil];
            }else{
                WXImageObject *ext = [WXImageObject object];
                if ([thumbImage isKindOfClass:[NSURL class]]) {
                    ext.imageUrl = [thumbImage absoluteString];
                }else if ([thumbImage isKindOfClass:[NSString class]]){
                ext.imageUrl = thumbImage;
                }else{
                ext.imageData = [self receiveDataWithImage:thumbImage];
                }
                message = [self messageWithTitle:nil
                                     Description:nil
                                          Object:ext
                                      MessageExt:nil
                                   MessageAction:nil
                                      ThumbImage:thumbImage
                                        MediaTag:nil];
            }
            
            req = [self requestWithText:nil
                                                           OrMediaMessage:message
                                                                    bText:NO
                                                                  InScene:scene];
            break;

        }
        case SSDKContentTypeWebPage:{
            //如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作
            if (!thumbImage && image) {
               thumbImage = [[self receiveUIImageWithImage:image] scaleToFillSize:CGSizeMake(50, 50)];
            }
            WXWebpageObject *ext = [WXWebpageObject object];
            ext.webpageUrl = [url absoluteString];
            
            WXMediaMessage *message = [self messageWithTitle:title
                                                           Description:text
                                                                Object:ext
                                                            MessageExt:nil
                                                         MessageAction:nil
                                                            ThumbImage:thumbImage
                                                              MediaTag:nil];
            
            req = [self requestWithText:nil
                                                           OrMediaMessage:message
                                                                    bText:NO
                                                                  InScene:scene];
            break;

        }
        case SSDKContentTypeApp:{
            WXAppExtendObject *ext = [WXAppExtendObject object];
            ext.url = [url absoluteString];
            ext.extInfo = extInfo;
            ext.fileData = fileData;
            
            WXMediaMessage *message = [self messageWithTitle:title
                                                           Description:text
                                                                Object:ext
                                                            MessageExt:nil
                                                         MessageAction:nil
                                                            ThumbImage:thumbImage
                                                              MediaTag:nil];
            
            req = [self requestWithText:nil
                                                           OrMediaMessage:message
                                                                    bText:NO
                                                                  InScene:scene];
            break;

        }
        case SSDKContentTypeAudio:{
            WXMusicObject *ext = [WXMusicObject object];
            ext.musicUrl = [musicFileURL absoluteString];
            ext.musicDataUrl = [musicFileURL absoluteString];
            
            WXMediaMessage *message = [self messageWithTitle:title
                                                           Description:text
                                                                Object:ext
                                                            MessageExt:nil
                                                         MessageAction:nil
                                                            ThumbImage:thumbImage
                                                              MediaTag:nil];
            
            req = [self requestWithText:nil
                                                           OrMediaMessage:message
                                                                    bText:NO
                                                                  InScene:scene];
            break;

            
        }
        case SSDKContentTypeVideo:{
            WXVideoObject *ext = [WXVideoObject object];
            ext.videoUrl = [url absoluteString];
            
            WXMediaMessage *message = [self messageWithTitle:title
                                                 Description:text
                                                      Object:ext
                                                  MessageExt:nil
                                               MessageAction:nil
                                                  ThumbImage:thumbImage
                                                    MediaTag:nil];
            req = [self requestWithText:nil
                                                           OrMediaMessage:message
                                                                    bText:NO
                                                                  InScene:scene];
            break;

        }
        case SSDKContentTypeFile:{
            //如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作
            if (!thumbImage && image) {
              thumbImage = [[self receiveUIImageWithImage:image] scaleToFillSize:CGSizeMake(50, 50)];
            }

            WXFileObject *ext = [WXFileObject object];
            ext.fileExtension = fileExtension;
            ext.fileData = [self receiveDataWithImage:sourceFileData];
            
            WXMediaMessage *message = [self messageWithTitle:title
                                                 Description:text
                                                      Object:ext
                                                  MessageExt:nil
                                               MessageAction:nil
                                                  ThumbImage:thumbImage
                                                    MediaTag:nil];
            req = [self requestWithText:nil
                                                           OrMediaMessage:message
                                                                    bText:NO
                                                                  InScene:scene];
            break;
        }
        default:
            break;
    }
    [self setObject:req forKey:kAG_WXMessage_Key];
}

#pragma mark - 获得NSData的图片
- (NSData *)receiveDataWithImage:(id)imageInfo{
    NSData *imageData = nil;
    if ([imageInfo isKindOfClass:[NSData class]]) {
        imageData = imageInfo;
    }else if([imageInfo isKindOfClass:[UIImage class]]){
        imageData = UIImageJPEGRepresentation(imageInfo,0);
    }else if ([imageInfo isKindOfClass:[NSURL class]]){
        imageData = [NSData dataWithContentsOfURL:imageInfo];
    }else if ([imageInfo isKindOfClass:[NSString class]]){
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageInfo]];
    }
    return imageData;
}
#pragma mark - 获得UIImage的图片
- (UIImage *)receiveUIImageWithImage:(id)imageInfo{
    UIImage *image = nil;
    if ([imageInfo isKindOfClass:[NSData class]]) {
        image = [UIImage imageWithData:imageInfo];
    }else if ([imageInfo isKindOfClass:[NSString class]]){
       image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageInfo]]];

    }else if ([imageInfo isKindOfClass:[NSURL class]]){
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageInfo]];
    }
    return image;
}
#pragma mark - 腾讯分享获得分享的结果状态值
//- (QQApiSendResultCode)reqWithContent:(QQApiObject*)apiObject withPlatformSubType:(SSDKPlatformType)platformSubType{
//    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:apiObject];
//    QQApiSendResultCode sent;
//    //分享到QQ好友
//    if (platformSubType == SSDKPlatformSubTypeQQFriend) {
//        sent = [QQApiInterface sendReq:req];
//    }else{
//        //将内容分享到qzone
//        sent = [QQApiInterface SendReqToQZone:req];
//    }
//    return sent;
//}
#pragma mark - 发送消息至微信终端程序的消息结构体
- (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}
#pragma mark - 返回微信终端和第三方程序之间传递消息的多媒体消息内容
- (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(id)thumbImage
                            MediaTag:(NSString *)tagName {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    if ([thumbImage isKindOfClass:[UIImage class]]) {
        [message setThumbImage:thumbImage];
    }else{
        [message setThumbData:[self receiveDataWithImage:thumbImage]];
    }
    return message;
}
#pragma mark - 
@end
