//
//  QMXMPlayBackViewController.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/13.
//  Copyright © 2020 wf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QMBaseViewController.h"
#import "ChannelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMXMPlayBackViewController : QMBaseViewController
@property (nonatomic, strong) ChannelObject *channel;
@property (nonatomic, strong) NSDate *selectedDate;
- (void)showDatePicker;
-(void)dateSelectedAction;
@end

NS_ASSUME_NONNULL_END
