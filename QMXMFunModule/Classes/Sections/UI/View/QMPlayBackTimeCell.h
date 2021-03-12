//
//  QMPlayBackTimeCell.h
//  FunSDKDemo
//
//  Created by wf on 2020/9/23.
//  Copyright © 2020 wf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeInfo.h"
#import "RecordInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface QMPlayBackTimeCell : UITableViewCell
+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UIView *lineView;
- (void)configTimeSubArr:(NSMutableArray<TimeInfo*>*) subArr;
- (void)configVideFile:(RecordInfo *)recordInfo;
@end

NS_ASSUME_NONNULL_END
