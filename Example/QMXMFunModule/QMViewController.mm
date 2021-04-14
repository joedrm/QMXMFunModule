//
//  QMViewController.m
//  QMXMFunModule
//
//  Created by wangfang on 03/10/2021.
//  Copyright (c) 2021 wangfang. All rights reserved.
//

#import "QMViewController.h"
#import "QMXMFunModule_Example-Bridging-Header.h"
//#import <QNNLib/QNNLib-Swift.h>

@interface QMViewController ()
@property (nonatomic, strong) QMXMDeviceTool* deviceTool;
@end

@implementation QMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.deviceTool = [[QMXMDeviceTool alloc] init];
    [self.deviceTool initDeviceManager];
    
    self.extendedLayoutIncludesOpaqueBars = true;
    self.view.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 11.0, *)) { // iOS 11.0 及以后的版本
        
    } else { // iOS 11.0 之前
        self.automaticallyAdjustsScrollViewInsets = true;
    }
//    self.view.
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor *color = [UIColor colorWithHexString:@"D93124"];
    UIImage* img = [UIImage createImageColor:color size:CGSizeMake(10, 10)];
    UIImage* resizableImage = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
    
    UIColor *titleColor = [UIColor colorWithHexString:@"ffffff"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName: titleColor,
        NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btn setTitleColor:[[UIColor alloc] initWithRed:33/255 green:123/255 blue:19/255 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn setTitle:@"开始播放" forState:UIControlStateNormal];
    UIImage *btnImage = [[UIImage createImageColor:[UIColor redColor] size:CGSizeMake(10, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [btn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [btn setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    btn.titleLabel.textColor = UIColor.whiteColor;
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.clipsToBounds = true;
    btn.layer.cornerRadius = 4;
    [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
}

- (void)clickedBtn:(UIButton *)sender{
    NSString *orgID = @"0eb0dd2f-9ea0-fdaa-3931-e282a325d4fe";
    NSString *gatewayId = @"06e5d3e38ae644c9";
    NSString *shopName = @"办公室NVR";
    NSString *username = @"admin";
    NSString *pwd = @"sengled123";
    NSString *mac = @"06e5d3e38ae644c9";
    [self.deviceTool loginWithUserName:username pwd:pwd mac:mac callBack:^(DeviceObject * _Nonnull obj) {
        obj.gatewayId = gatewayId;
        obj.shopName = shopName;
        QMXMPlayViewController * vc = [[QMXMPlayViewController alloc] init];
        vc.deviceObj = obj;
        vc.shopID = orgID;
//        vc
        [self.navigationController pushViewController:vc animated:true];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
