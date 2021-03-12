//
//  QMXMPlayTableViewCell.h
//  FunSDKDemo
//
//  Created by wf on 2020/8/12.
//  Copyright © 2020 wf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *QMXMPlayTableViewCellReuseId = @"QMXMPlayTableViewCell";

@interface QMXMPlayTableViewCell : UITableViewCell
+ (UITableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
- (void)configWithIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
