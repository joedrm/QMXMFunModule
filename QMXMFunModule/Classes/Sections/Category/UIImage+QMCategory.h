//
//  UIImage+QMCategory.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (QMCategory)
+ (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end

NS_ASSUME_NONNULL_END
