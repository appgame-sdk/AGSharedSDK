//
//  AGExtension.h
//  LittleGame
//
//  Created by Mao on 14-8-22.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define HexColor(c) [UIColor colorWithHexString:c]

@interface UIColor(AGExtension)
+ (UIColor *)colorWithRedInt:(NSInteger)red greenInt:(NSInteger)green blueInt:(NSInteger)blue alphaInt:(NSInteger)alpha;
+ (UIColor *)colorWithRedInt:(NSInteger)red greenInt:(NSInteger)green blueInt:(NSInteger)blue;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
@end
