//
//  QMViewController.m
//  QMXMFunModule
//
//  Created by wangfang on 03/10/2021.
//  Copyright (c) 2021 wangfang. All rights reserved.
//

#import "QMViewController.h"
#import "QMXMPlayViewController.h"
#import "QMXMDeviceTool.h"
#import "QMBundleTool.h"
#import "Masonry.h"
#import "UIImage+QMCategory.h"

@interface QMViewController ()
@property (nonatomic, strong) QMXMDeviceTool* deviceTool;
@end

@implementation QMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.deviceTool = [[QMXMDeviceTool alloc] init];
    [self.deviceTool initDeviceManager];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitleColor:[[UIColor alloc] initWithRed:33/255 green:123/255 blue:19/255 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn setTitle:@"开始播放" forState:UIControlStateNormal];
    UIImage *img = [[UIImage createImageColor:[UIColor redColor] size:CGSizeMake(10, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setBackgroundImage:img forState:UIControlStateHighlighted];
    //    UIImage *iconImage = [QMBundleTool getSectionsImg:@""];
    //    [btn setImage:iconImage forState:UIControlStateNormal];
    //    [btn setImage:iconImage forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
}

- (void)clickedBtn:(UIButton *)sender{
    NSString *orgID = @"";
    NSString *gatewayId = @"";
    NSString *shopName = @"";
    NSString *username = @"";
    NSString *pwd = @"";
    NSString *mac = @"";
    [self.deviceTool loginWithUserName:username pwd:pwd mac:mac callBack:^(DeviceObject * _Nonnull obj) {
        obj.gatewayId = gatewayId;
        obj.shopName = shopName;
        QMXMPlayViewController * vc = [[QMXMPlayViewController alloc] init];
        vc.deviceObj = obj;
        vc.shopID = orgID;
        [self.navigationController pushViewController:vc animated:true];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
