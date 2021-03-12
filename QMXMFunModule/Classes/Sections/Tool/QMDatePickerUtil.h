//
//  QMDatePickerUtil.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/23.
//  Copyright © 2020 wf. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedDateCallBack)(NSDate* date);

@interface QMDatePickerUtil : NSObject
+ (void)showDatePicker:(NSString *)title callBack:(SelectedDateCallBack)callBack;

+ (NSString *)getSecondStringWithSecond:(int)second;
@end

NS_ASSUME_NONNULL_END
