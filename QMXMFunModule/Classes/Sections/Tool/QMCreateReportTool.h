//
//  QMCreateReportTool.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/11.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMTempleteModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(id JSON);
typedef void(^FailBlock)();

@interface QMCreateReportTool : NSObject

+ (void) createReportWithHandler:(NSString *)handler
                            desc:(NSString *)desc
                    organization:(NSString *)organization
                        templete:(QMTempleteModel *)templete
                           imges:(NSArray <UIImage *>*)imgs
                         success:(SuccessBlock)successBlock
                           faile:(FailBlock)failBlock;

+ (NSArray<NSDate*> *)getLastMondayTime;
@end

NS_ASSUME_NONNULL_END
