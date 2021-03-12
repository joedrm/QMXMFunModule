//
//  QMDatePickerUtil.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/23.
//  Copyright © 2020 wf. All rights reserved.
//

#import "QMDatePickerUtil.h"
//#import "FunSDkDemo-Swift.h"

@implementation QMDatePickerUtil

+ (void)showDatePicker:(NSString *)title callBack:(SelectedDateCallBack)callBack {
    NSDate* date = [NSDate date];
//    [[QMDatePickerView show:title datePickerMode:UIDatePickerModeDate minDate:NULL maxDate:NULL selectedDate:date selectCallBack:^(NSDate * _Nonnull selectedDate) {
//        if (callBack != NULL) {
//            callBack(selectedDate);
//        }
//    } cancelCallBack:^{
//        
//    }] openView];
}


+ (NSString *)getSecondStringWithSecond:(int)second {
    int h = second / 3600;
    int m = (second % 3600) / 60;
    int s = ((second % 3600) % 60);
    NSString* hourStr = h>=10?[NSString stringWithFormat:@"%i",h]:[NSString stringWithFormat:@"0%i",h];
    NSString* mStr = m>=10?[NSString stringWithFormat:@"%i",m]:[NSString stringWithFormat:@"0%i",m];
    NSString* sStr = s>=10?[NSString stringWithFormat:@"%i",s]:[NSString stringWithFormat:@"0%i",s];
    return [NSString stringWithFormat:@"%@:%@:%@",hourStr,mStr,sStr];
}
@end
