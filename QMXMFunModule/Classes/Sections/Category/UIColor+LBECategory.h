//
//  UIColor+LBECategory.h
//  LBEeacher
//
//  Created by lowell on 16/9/5.
//  Copyright © 2016年 lebaoedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LBECategory)

//0x2d3f4a
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor opacity:(float)opacity;

//@"ffffff" or @"#ffffff"
+ (UIColor *)colorWithHexString:(NSString *)str;
+ (UIColor *)colorWithHexString:(NSString *)str opacity:(float)opacity;

@end
