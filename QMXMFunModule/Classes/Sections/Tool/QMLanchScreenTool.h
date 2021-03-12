//
//  QMLanchScreenTool.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/21.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QMLanchScreenTool : NSObject <NSCopying,NSMutableCopying>

+(instancetype)shareTool;

@property (nonatomic, assign) BOOL isFull;

@end

NS_ASSUME_NONNULL_END
