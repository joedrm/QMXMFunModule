//
//  QMPhotoPickerService.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImagePickerBlock)(UIImage *selectedImage);

@interface QMPhotoPickerService : NSObject

+ (instancetype) createServiceSelectedImage:(ImagePickerBlock)callBack;

- (void)presentWithVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
