//
//  QMWeakProxy.h
//  FunSDKDemo
//
//  Created by wf on 2020/11/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMWeakProxy : NSProxy
@property (weak,nonatomic,readonly)id target;

+ (instancetype)proxyWithTarget:(id)target;

- (instancetype)initWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
