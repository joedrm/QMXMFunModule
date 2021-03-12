//
//  NSDate+Extension.m
//  FunSDKDemo
//
//  Created by wf on 2020/9/15.
//  Copyright © 2020 wf. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSArray<NSDate*> *)getLastMondayTime{
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit| NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    
    //获取今天是周几
    NSInteger weekDay = [comp weekday];
    //获取某天是几号
    NSInteger day = [comp day];
    
    //计算当前日期和上周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        
        firstDiff = -13;
        lastDiff = 0;
    }
    else{
        
        firstDiff = [calendar firstWeekday] - weekDay +1-7;
        lastDiff = 8 - weekDay;
    }
    
    //在当前日期基础上加上时间差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"MM月dd日"];
//    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
//    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
//
//    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",firstDay,lastDay];
    
    return @[firstDayOfWeek, lastDayOfWeek];
}
@end
