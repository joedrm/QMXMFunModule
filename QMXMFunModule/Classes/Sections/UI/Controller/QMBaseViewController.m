//
//  QMBaseViewController.m
//  Qomo
//
//  Created by wdy on 2020/6/4.
//  Copyright © 2020 sengled. All rights reserved.
//

#import "QMBaseViewController.h"
//#import "QNNLib-Swift.h"
#import "UIColor+TransformColor.h"
#import "UIColor+LBECategory.h"

@interface QMBaseViewController ()

@end

@implementation QMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.extendedLayoutIncludesOpaqueBars = true;
    self.view.backgroundColor = UIColor.whiteColor;
    if (@available(iOS 11.0, *)) { // iOS 11.0 及以后的版本
        
    } else { // iOS 11.0 之前
        self.automaticallyAdjustsScrollViewInsets = true;
    }
    
    UIColor *color = [UIColor colorWithHexString:@"D93124"];
    UIImage* img = [UIImage createImageColor:color size:CGSizeMake(10, 10)];
    UIImage* resizableImage = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    UIColor *titleColor = [UIColor colorWithHexString:@"ffffff"];
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance * appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundImage = resizableImage;
        [appearance setTitleTextAttributes:@{
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        
    } else {
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTitleTextAttributes:@{
            NSForegroundColorAttributeName: titleColor,
            NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
    }
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 40);
    UIImage *btnImage = [QMBundleTool getSectionsImg:@"backImage_white"];
    UIImage *renderImg = [btnImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:renderImg forState:UIControlStateNormal];
    [btn setImage:renderImg forState:UIControlStateSelected];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    UIBarButtonItem* spaceBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceBarBtn.width = -15;
    
    self.navigationItem.leftBarButtonItems = @[barBtn];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)backAction {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)popDisable:(BOOL)disable {
//    self.sh_interactivePopDisabled = disable;
}

@end
