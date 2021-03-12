//
//  QMHud.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMHud : NSObject
+ (void) showHUD:(NSString *)msg;
+ (void) showSuccess:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
