//
//  AGSSDKContentEntity.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/20.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AGSSDKContentEntity : NSObject
/**
 *  内容标识
 */
@property (nonatomic, copy) NSString *cid;

/**
 *  分享文本
 */
@property (nonatomic, copy) NSString *text;

/**
 *  分享图片列表,元素为SSDKImage
 */
@property (nonatomic, retain) NSArray *images;

/**
 *  分享链接列表,元素为NSURL
 */
@property (nonatomic, retain) NSArray *urls;

/**
 *  原始数据
 */
@property (nonatomic, retain) id rawData;
@end
