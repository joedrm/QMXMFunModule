//
//  AuthorizationService.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizationService : NSObject
+ (BOOL)isHaveCameraAuthor;
+ (BOOL)isHavePhotoAuthor;
@end

NS_ASSUME_NONNULL_END
