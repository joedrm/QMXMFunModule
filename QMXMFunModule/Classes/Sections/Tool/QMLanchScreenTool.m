//
//  QMLanchScreenTool.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/21.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMLanchScreenTool.h"

@implementation QMLanchScreenTool

//提供一个全局静态变量
static QMLanchScreenTool * _instance;

+(instancetype)shareTool{
    return [[self alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFull = false;
    }
    return self;
}

//当调用alloc的时候会调用allocWithZone
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //方案一:加互斥锁,解决多线程访问安全问题
//    @synchronized(self){//同步的
//        if (!_instance) {
//            _instance = [super allocWithZone:zone];
//        }
//    }
    //方案二.GCD dispatch_onec,本身是线程安全的,保证整个程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//严谨
//遵从NSCopying协议,可以通过copy方式创建对象
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return _instance;
}
//遵从NSMutableCopying协议,可以通过mutableCopy方式创建对象
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return _instance;
}



@end
