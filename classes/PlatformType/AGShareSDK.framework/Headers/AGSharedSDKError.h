//
//  AGSharedSDKError.h
//  AGSharedSDK
//
//  Created by 覃凤姣 on 16/4/25.
//  Copyright © 2016年 覃凤姣. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *AGErrorDomain;
typedef NS_ENUM(NSUInteger, AGErrorCode) {
    AGErrorUnknowError               = 1,
    AGErrorCodeNetworkNotAvailable   = 1001,
    AGErrorCodeUserCancelLogin       = 1002,
    AGErrorCodeInvalidOpenid         =1003,
    AGErrorCodeAPPNotRegistered      =1004,
    AGErrorCodeAPIParameterError     =1005,
    AGErrorCodeAPPNotInstall         =1006,
    AGErrorCodeAPINotSupport        =1007
};

